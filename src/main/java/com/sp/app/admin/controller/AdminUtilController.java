package com.sp.app.admin.controller;

import com.sp.app.admin.model.AdminCalMemo;
import com.sp.app.admin.model.AdminTodo;
import com.sp.app.admin.service.AdminUtilService;
import com.sp.app.domain.dto.MemberDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.model.Notification;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.MemberService;
import com.sp.app.service.NotificationService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin/util")
@RequiredArgsConstructor
public class AdminUtilController {

    private final AdminUtilService utilService;
    private final NotificationService notificationService;
    private final MemberService memberService;

    @Value("${file.upload-root}/profile")
    private String profileUploadPath;
    private final PasswordEncoder passwordEncoder;

    private Long getAdminIdx(CustomUserDetails u) {
        return u == null ? null : u.getUserIdx();
    }

    @GetMapping("/memo/month")
    public List<AdminCalMemo> getMemosByMonth(
            @RequestParam("yearMonth") String yearMonth,
            @AuthenticationPrincipal CustomUserDetails u) {
        Long adminIdx = getAdminIdx(u);
        if (adminIdx == null) return List.of();
        return utilService.getMemosByMonth(adminIdx, yearMonth);
    }

    @GetMapping("/memo")
    public AdminCalMemo getMemo(
            @RequestParam("date") String date,
            @AuthenticationPrincipal CustomUserDetails u) {
        Long adminIdx = getAdminIdx(u);
        if (adminIdx == null) return null;
        return utilService.getMemo(adminIdx, date);
    }

    @PostMapping("/memo/save")
    public Map<String, Object> saveMemo(
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            String date    = body.get("date");
            String content = body.get("content");
            boolean isNew  = utilService.getMemo(adminIdx, date) == null;
            utilService.saveMemo(adminIdx, date, content);
            notificationService.sendNotification(
                adminIdx,
                "CALENDAR",
                date + " 캘린더 메모가 " + (isNew ? "등록" : "수정") + "되었습니다.",
                "/admin"
            );
            result.put("success", true);
            result.put("isNew", isNew);
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", e.getMessage());
        }
        return result;
    }

    @PostMapping("/memo/delete")
    public Map<String, Object> deleteMemo(
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            utilService.deleteMemo(adminIdx, body.get("date"));
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @GetMapping("/todo/list")
    public List<AdminTodo> getTodoList(@AuthenticationPrincipal CustomUserDetails u) {
        Long adminIdx = getAdminIdx(u);
        if (adminIdx == null) return List.of();
        return utilService.getTodoList(adminIdx);
    }

    @PostMapping("/todo/add")
    public Map<String, Object> addTodo(
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            String content = body.get("content");
            AdminTodo todo = utilService.addTodo(adminIdx, content);
            notificationService.sendNotification(
                adminIdx,
                "TODO",
                "새 할 일이 추가되었습니다: " + content,
                "/admin"
            );
            result.put("success", true);
            result.put("todo", todo);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @PostMapping("/todo/toggle")
    public Map<String, Object> toggleTodo(
            @RequestBody Map<String, Object> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            Long todoIdx = Long.valueOf(body.get("todoIdx").toString());
            int  isDone  = Integer.parseInt(body.get("isDone").toString());
            utilService.toggleTodo(adminIdx, todoIdx, isDone);
            if (isDone == 1) {
                String content = body.getOrDefault("content", "").toString();
                notificationService.sendNotification(
                    adminIdx,
                    "TODO_DONE",
                    "할 일 완료: " + content,
                    "/admin"
                );
            }
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @PostMapping("/todo/edit")
    public Map<String, Object> editTodo(
            @RequestBody Map<String, Object> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            Long todoIdx = Long.valueOf(body.get("todoIdx").toString());
            String content = body.get("content").toString();
            utilService.editTodo(adminIdx, todoIdx, content);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @PostMapping("/todo/delete")
    public Map<String, Object> deleteTodo(
            @RequestBody Map<String, Object> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            Long todoIdx = Long.valueOf(body.get("todoIdx").toString());
            utilService.deleteTodo(adminIdx, todoIdx);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @PostMapping("/todo/clearDone")
    public Map<String, Object> clearDoneTodos(@AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            utilService.deleteDoneTodos(adminIdx);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @GetMapping("/noti/list")
    public List<Notification> getNotiList(@AuthenticationPrincipal CustomUserDetails u) {
        Long adminIdx = getAdminIdx(u);
        if (adminIdx == null) return List.of();
        return notificationService.listNotification(adminIdx);
    }

    @GetMapping("/noti/unread")
    public Map<String, Object> getNotiUnread(@AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        Long adminIdx = getAdminIdx(u);
        result.put("count", adminIdx == null ? 0 : notificationService.unreadNotificationCount(adminIdx));
        return result;
    }

    @PostMapping("/noti/read")
    public Map<String, Object> readNoti(
            @RequestBody Map<String, Object> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long notifIdx = Long.valueOf(body.get("notifIdx").toString());
            notificationService.updateNotificationRead(notifIdx);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }

    @PostMapping("/noti/readAll")
    public Map<String, Object> readAllNoti(@AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) { result.put("success", false); return result; }
            notificationService.updateAllNotificationRead(adminIdx);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
        }
        return result;
    }
    
    @PostMapping("/profile/save")
    public Map<String, Object> saveProfile(
            @RequestParam(value = "name", required = false) String name,
            @RequestParam(value = "nickname", required = false) String nickname,
            @RequestParam(value = "profileFile", required = false) MultipartFile profileFile,
            @RequestParam(value = "photoDeleted", defaultValue = "false") boolean photoDeleted,
            @AuthenticationPrincipal CustomUserDetails u,
            HttpSession session) {

        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) {
                result.put("success", false);
                result.put("msg", "인증 정보가 없습니다.");
                return result;
            }

            UserDto currentUser = memberService.findById(adminIdx);
            if (currentUser == null) {
                result.put("success", false);
                result.put("msg", "관리자 정보를 찾을 수 없습니다.");
                return result;
            }

            String pathname = profileUploadPath;

            if (photoDeleted) {
                Map<String, Object> paramMap = new HashMap<>();
                paramMap.put("userIdx", adminIdx);
                memberService.deleteProfilePhoto(paramMap, pathname);
            }

            MemberDto dto = new MemberDto();
            dto.setUserIdx(adminIdx);
            dto.setName(name);
            dto.setNickname(nickname);
            dto.setEmail(currentUser.getEmail());

            if (profileFile != null && !profileFile.isEmpty()) {
                dto.setSelectFile(profileFile);
            }

            memberService.updateMember(dto, pathname);

            UserDto updatedUser = memberService.findById(adminIdx);
            SessionInfo sessionInfo = (SessionInfo) session.getAttribute("member");
            if (sessionInfo != null && updatedUser != null) {
                sessionInfo.setName(updatedUser.getName());
                sessionInfo.setNickname(updatedUser.getNickname());
                sessionInfo.setEmail(updatedUser.getEmail());
                sessionInfo.setAvatar(updatedUser.getProfile_photo());
                session.setAttribute("member", sessionInfo);
            }

            result.put("success", true);
            result.put("name", updatedUser != null ? updatedUser.getName() : name);
            result.put("nickname", updatedUser != null ? updatedUser.getNickname() : nickname);
            result.put("email", updatedUser != null ? updatedUser.getEmail() : currentUser.getEmail());
            result.put("avatarUrl", updatedUser != null && updatedUser.getProfile_photo() != null && !updatedUser.getProfile_photo().isBlank()
                    ? "/uploads/profile/" + updatedUser.getProfile_photo() : "");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("msg", "프로필 저장 중 오류가 발생했습니다.");
        }
        return result;
    }

    @PostMapping("/profile/password")
    public Map<String, Object> changePassword(
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUserDetails u) {
        Map<String, Object> result = new HashMap<>();
        try {
            Long adminIdx = getAdminIdx(u);
            if (adminIdx == null) {
                result.put("success", false);
                result.put("msg", "인증 정보가 없습니다.");
                return result;
            }

            String currentPassword = body.get("currentPassword");
            String newPassword     = body.get("newPassword");
            String confirmPassword = body.get("confirmPassword");

            if (currentPassword == null || newPassword == null || confirmPassword == null
                    || currentPassword.isBlank() || newPassword.isBlank() || confirmPassword.isBlank()) {
                result.put("success", false);
                result.put("msg", "비밀번호를 모두 입력해 주세요.");
                return result;
            }
            if (!newPassword.equals(confirmPassword)) {
                result.put("success", false);
                result.put("msg", "새 비밀번호가 일치하지 않습니다.");
                return result;
            }
            if (newPassword.length() < 4) {
                result.put("success", false);
                result.put("msg", "새 비밀번호는 4자 이상이어야 합니다.");
                return result;
            }

            UserDto userDto = memberService.findById(adminIdx);
            if (userDto == null || !passwordEncoder.matches(currentPassword, userDto.getPwd())) {
                result.put("success", false);
                result.put("msg", "현재 비밀번호가 일치하지 않습니다.");
                return result;
            }
            
            Map<String, Object> map = new HashMap<>();
            map.put("userIdx", adminIdx);
            map.put("pwd", newPassword);
            memberService.updateUserPwd(map);

            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "비밀번호 변경 중 오류가 발생했습니다.");
        }
        return result;
    }
}