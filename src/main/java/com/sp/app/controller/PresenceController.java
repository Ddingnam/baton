package com.sp.app.controller;

import com.sp.app.admin.service.AdminChatService;
import com.sp.app.domain.dto.UserDto;
import com.sp.app.security.CustomUserDetails;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/presence")
public class PresenceController {
	private final AdminChatService adminChatService;
	private final SimpMessagingTemplate messagingTemplate;

	public PresenceController(AdminChatService adminChatService, SimpMessagingTemplate messagingTemplate) {
		this.adminChatService = adminChatService;
		this.messagingTemplate = messagingTemplate;
	}

	@PostMapping("/heartbeat")
	public Map<String, Object> heartbeat(@RequestParam("status") int status,
			@AuthenticationPrincipal CustomUserDetails userDetails) {
		if (userDetails == null)
			return Map.of("success", false);
		long userIdx = userDetails.getUserIdx();
		int prev = adminChatService.getOnlineStatus(userIdx);
		if (prev != status) {
			adminChatService.setOnlineStatus(userIdx, status);
			messagingTemplate.convertAndSend("/topic/presence", Map.of("userIdx", userIdx, "status", status));
		}
		return Map.of("success", true);
	}

	@PostMapping("/offline")
	public Map<String, Object> offline(@AuthenticationPrincipal CustomUserDetails userDetails) {
		if (userDetails == null)
			return Map.of("success", false);
		long userIdx = userDetails.getUserIdx();
		adminChatService.setOnlineStatus(userIdx, 0);
		messagingTemplate.convertAndSend("/topic/presence", Map.of("userIdx", userIdx, "status", 0));
		return Map.of("success", true);
	}

	@GetMapping("/all")
	public List<Map<String, Object>> getAllStatus(@AuthenticationPrincipal CustomUserDetails userDetails) {
		if (userDetails == null)
			return List.of();
		List<UserDto> members = adminChatService.listAdminMembers();
		return members.stream().map(m -> {
			Map<String, Object> item = new HashMap<>();
			item.put("userIdx", m.getUserIdx());
			item.put("status", m.getIsOnline());
			return item;
		}).collect(Collectors.toList());
	}
}