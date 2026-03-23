package com.sp.app.admin.controller;

import com.sp.app.admin.service.AdminChatService;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.model.ChatMessage;
import com.sp.app.model.ChatRoom;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.ChatService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminChatController {

    private final ChatService chatService;
    private final AdminChatService adminChatService;

    public AdminChatController(ChatService chatService, AdminChatService adminChatService) {
        this.chatService = chatService;
        this.adminChatService = adminChatService;
    }

    @GetMapping("/chat")
    public String adminChat(
            @RequestParam(value = "roomIdx", required = false) Long roomIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            Model model) {

        if (userDetails == null) return "redirect:/member/login";

        Long   myUserIdx   = userDetails.getUserIdx();
        String myNickname  = userDetails.getNickname();
        int    myUserLevel = userDetails.getUserLevel();

        if (roomIdx != null) chatService.updateLastReadDate(roomIdx, myUserIdx);

        List<ChatRoom> roomList   = adminChatService.listAdminRooms(myUserIdx, myUserLevel);
        List<ChatRoom> dmList     = adminChatService.listDMRooms(myUserIdx);
        List<UserDto>  memberList = adminChatService.listAdminMembers();

        if (roomIdx == null && !roomList.isEmpty()) roomIdx = roomList.get(0).getRoomIdx();

        Long   currentRoomIdx  = roomIdx != null ? roomIdx : -1L;
        String currentRoomName = "";
        String currentRoomType = "channel";

        if (roomIdx != null) {
            for (ChatRoom r : roomList) {
                if (r.getRoomIdx().equals(roomIdx)) { currentRoomName = r.getRoomName(); currentRoomType = "channel"; break; }
            }
            if (currentRoomName.isEmpty()) {
                for (ChatRoom r : dmList) {
                    if (r.getRoomIdx().equals(roomIdx)) { currentRoomName = r.getNickname(); currentRoomType = "dm"; break; }
                }
            }
        }

        List<ChatMessage> chatList = currentRoomIdx > 0 ? chatService.listChatMessage(currentRoomIdx) : List.of();

        model.addAttribute("roomList",        roomList);
        model.addAttribute("dmList",          dmList);
        model.addAttribute("chatList",        chatList);
        model.addAttribute("myUserIdx",       myUserIdx);
        model.addAttribute("myNickname",      myNickname);
        model.addAttribute("myUserLevel",     myUserLevel);
        model.addAttribute("currentRoomIdx",  currentRoomIdx);
        model.addAttribute("currentRoomName", currentRoomName);
        model.addAttribute("currentRoomType", currentRoomType);
        model.addAttribute("memberList",      memberList);

        return "admin/chat/chat";
    }

    @PostMapping(value = "/chat/dm", produces = "application/json")
    @ResponseBody
    public Map<String, Object> getOrCreateDM(
            @RequestParam("targetUserIdx") Long targetUserIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long roomIdx = adminChatService.createOrGetDMRoom(userDetails.getUserIdx(), targetUserIdx);
            result.put("success", true); result.put("roomIdx", roomIdx);
        } catch (Exception e) { result.put("success", false); }
        return result;
    }

    @PostMapping(value = "/chat/channel", produces = "application/json")
    @ResponseBody
    public Map<String, Object> createChannel(
            @RequestParam("roomName") String roomName,
            @RequestParam(value = "inviteIdxs", required = false, defaultValue = "") String inviteIdxs,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        try {
            if (roomName == null || roomName.trim().isEmpty()) { result.put("success", false); result.put("msg", "채널명을 입력해주세요."); return result; }
            Long roomIdx = adminChatService.createChannel(roomName.trim(), userDetails.getUserIdx());
            if (inviteIdxs != null && !inviteIdxs.trim().isEmpty()) {
                for (String idxStr : inviteIdxs.split(",")) {
                    try {
                        Long inviteUserIdx = Long.parseLong(idxStr.trim());
                        if (!inviteUserIdx.equals(userDetails.getUserIdx())) adminChatService.addMemberToChannel(roomIdx, inviteUserIdx);
                    } catch (NumberFormatException ignored) {}
                }
            }
            result.put("success", true); result.put("roomIdx", roomIdx); result.put("roomName", roomName.trim());
        } catch (Exception e) { result.put("success", false); }
        return result;
    }

    /** 채널 멤버 목록 — creatorIdx는 DB 컬럼 추가 전까지 null 반환 가능 */
    @GetMapping(value = "/chat/channel/{roomIdx}/members", produces = "application/json")
    @ResponseBody
    public Map<String, Object> getChannelMembers(
            @PathVariable("roomIdx") Long roomIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        if (userDetails.getUserLevel() < 99) { result.put("success", false); return result; }
        result.put("success",    true);
        result.put("members",    adminChatService.listChannelMembers(roomIdx));
        result.put("nonMembers", adminChatService.listNonMembers(roomIdx));
        // creatorIdx: DB 컬럼 없으면 null → JS에서 SUPER 유저가 방장 역할
        try {
            result.put("creatorIdx", adminChatService.getChannelCreator(roomIdx));
        } catch (Exception e) {
            result.put("creatorIdx", null);
        }
        return result;
    }

    @PostMapping(value = "/chat/channel/{roomIdx}/member/add", produces = "application/json")
    @ResponseBody
    public Map<String, Object> addMember(
            @PathVariable("roomIdx") Long roomIdx,
            @RequestParam("userIdx") Long userIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        if (userDetails.getUserLevel() < 99) { result.put("success", false); return result; }
        try { adminChatService.addMemberToChannel(roomIdx, userIdx); result.put("success", true); }
        catch (Exception e) { result.put("success", false); }
        return result;
    }

    /** 강퇴 — creatorIdx 없으면 SUPER(level 99)가 방장 역할 */
    @PostMapping(value = "/chat/channel/{roomIdx}/member/remove", produces = "application/json")
    @ResponseBody
    public Map<String, Object> removeMember(
            @PathVariable("roomIdx") Long roomIdx,
            @RequestParam("userIdx") Long userIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        if (userDetails.getUserLevel() < 99) { result.put("success", false); return result; }
        if (userIdx.equals(userDetails.getUserIdx())) {
            result.put("success", false); result.put("msg", "본인은 강퇴할 수 없습니다."); return result;
        }
        // creatorIdx 컬럼 있으면 방장만, 없으면 SUPER(99)만 가능
        try {
            Long creatorIdx = adminChatService.getChannelCreator(roomIdx);
            if (creatorIdx != null && !creatorIdx.equals(userDetails.getUserIdx())) {
                result.put("success", false); result.put("msg", "방장만 멤버를 강퇴할 수 있습니다."); return result;
            }
        } catch (Exception ignored) {
            // creatorIdx 컬럼 없는 경우 — SUPER 이면 강퇴 허용
        }
        try { adminChatService.removeMemberFromChannel(roomIdx, userIdx); result.put("success", true); }
        catch (Exception e) { result.put("success", false); }
        return result;
    }

    /** 본인 나가기 */
    @PostMapping(value = "/chat/channel/{roomIdx}/leave", produces = "application/json")
    @ResponseBody
    public Map<String, Object> leaveChannel(
            @PathVariable("roomIdx") Long roomIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        Long myIdx = userDetails.getUserIdx();
        try {
            Long creatorIdx = adminChatService.getChannelCreator(roomIdx);
            if (creatorIdx != null && creatorIdx.equals(myIdx)) {
                result.put("success", false); result.put("msg", "방장은 채널을 나갈 수 없습니다. 채널 설정에서 채널을 삭제해 주세요."); return result;
            }
        } catch (Exception ignored) {}
        try { adminChatService.leaveChannel(roomIdx, myIdx); result.put("success", true); }
        catch (Exception e) { result.put("success", false); }
        return result;
    }

    /** 알람 끄기/켜기 토글 */
    @PostMapping(value = "/chat/channel/{roomIdx}/mute", produces = "application/json")
    @ResponseBody
    public Map<String, Object> toggleMute(
            @PathVariable("roomIdx") Long roomIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        try {
            int newState = adminChatService.toggleMute(roomIdx, userDetails.getUserIdx());
            result.put("success", true); result.put("isMuted", newState);
        } catch (Exception e) { result.put("success", false); }
        return result;
    }

    @PostMapping(value = "/chat/channel/{roomIdx}/rename", produces = "application/json")
    @ResponseBody
    public Map<String, Object> renameChannel(
            @PathVariable("roomIdx") Long roomIdx,
            @RequestParam("roomName") String roomName,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        if (userDetails.getUserLevel() < 99) { result.put("success", false); return result; }
        try { adminChatService.renameChannel(roomIdx, roomName.trim()); result.put("success", true); result.put("roomName", roomName.trim()); }
        catch (Exception e) { result.put("success", false); }
        return result;
    }

    /** 방장 위임 */
    @PostMapping(value = "/chat/channel/{roomIdx}/transfer", produces = "application/json")
    @ResponseBody
    public Map<String, Object> transferOwnership(
            @PathVariable("roomIdx") Long roomIdx,
            @RequestParam("newOwnerIdx") Long newOwnerIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long creatorIdx = adminChatService.getChannelCreator(roomIdx);
            if (creatorIdx == null || !creatorIdx.equals(userDetails.getUserIdx())) {
                result.put("success", false); result.put("msg", "방장만 위임할 수 있습니다."); return result;
            }
            adminChatService.transferOwnership(roomIdx, newOwnerIdx);
            result.put("success", true);
        } catch (Exception e) { result.put("success", false); }
        return result;
    }

    @PostMapping(value = "/chat/channel/{roomIdx}/delete", produces = "application/json")
    @ResponseBody
    public Map<String, Object> deleteChannel(
            @PathVariable("roomIdx") Long roomIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        Map<String, Object> result = new HashMap<>();
        if (userDetails.getUserLevel() < 99) { result.put("success", false); return result; }
        try { adminChatService.deleteChannel(roomIdx); result.put("success", true); }
        catch (Exception e) { result.put("success", false); }
        return result;
    }
}