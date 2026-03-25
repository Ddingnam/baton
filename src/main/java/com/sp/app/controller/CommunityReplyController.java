package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.sp.app.domain.dto.CommunityDto;
import com.sp.app.domain.dto.CommunityReplyDto;
import com.sp.app.domain.dto.SessionInfo;
import com.sp.app.service.CommunityReplyService;
import com.sp.app.service.CommunityService;
import com.sp.app.service.NotificationService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/community/reply")
public class CommunityReplyController {

    private final CommunityReplyService service;
    private final NotificationService notificationService;
    private final CommunityService communityService;

    @GetMapping("/list")
    public Map<String, Object> list(@RequestParam("communityId") Long communityId) {
        List<CommunityReplyDto> list = service.listReply(communityId);
        int count = service.replyCount(communityId);
        
        Map<String, Object> model = new HashMap<>();
        model.put("list", list);
        model.put("count", count);
        return model;
    }

    @PostMapping("/write")
    public Map<String, Object> write(
            @RequestParam("communityId") Long communityId,
            @RequestParam("content") String content,
            @RequestParam(value = "parentId", required = false) Long parentId,
            @SessionAttribute("member") SessionInfo info) {
        
        Map<String, Object> model = new HashMap<>();
        try {
            CommunityReplyDto dto = CommunityReplyDto.builder()
                    .memberIdx(info.getUserIdx())
                    .writerNickname(info.getName())
                    .content(content)
                    .parentId(parentId)
                    .build();

            service.insertReply(communityId, dto);
            model.put("state", "true");
            
            CommunityDto communityDto = communityService.getCommunity(communityId);
            if(!communityDto.getMemberIdx().equals(info.getUserIdx())) {
                notificationService.sendCommunityNotification(
                    communityDto.getMemberIdx(), 
                    "[" + communityDto.getSubject() + "] 글에 새로운 댓글이 달렸습니다.", 
                    "/community/article?id=" + communityId
                );
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            model.put("state", "false");
        }
        return model;
    }

    @PostMapping("/delete")
    public Map<String, Object> delete(
            @RequestParam("id") Long id,
            @SessionAttribute("member") SessionInfo info) {
        
        Map<String, Object> model = new HashMap<>();
        try {
            service.deleteReply(id, info.getUserIdx());
            model.put("state", "true");
        } catch (Exception e) {
            e.printStackTrace();
            model.put("state", "false");
        }
        return model;
    }
}