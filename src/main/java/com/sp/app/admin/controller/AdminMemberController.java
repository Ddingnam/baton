package com.sp.app.admin.controller;

import com.sp.app.admin.service.AdminMemberService;
import com.sp.app.domain.dto.UserDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/member")
public class AdminMemberController {

	private final AdminMemberService adminMemberService;

	@GetMapping("/list")
	public String memberList(
	        @RequestParam(name = "page", defaultValue = "1") int page, 
	        @RequestParam(name = "schType", required = false) String schType,
	        @RequestParam(name = "kwd", required = false) String kwd, 
	        @RequestParam(name = "status", required = false) String status, 
	        Model model) {

		int pageSize = 15;
		int offset = (page - 1) * pageSize;

		Map<String, Object> map = new HashMap<>();
		map.put("schType", schType);
		map.put("kwd", kwd);
		map.put("status", status);
		map.put("offset", offset);
		map.put("pageSize", pageSize);

		List<UserDto> list = adminMemberService.listMembers(map);
		int totalCount = adminMemberService.countMembers(map);
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		model.addAttribute("list", list);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("page", page);
		model.addAttribute("schType", schType);
		model.addAttribute("kwd", kwd);
		model.addAttribute("status", status);

		return "admin/member/list";
	}

	@GetMapping("/detail/{userIdx}")
	@ResponseBody
	public ResponseEntity<UserDto> memberDetail(@PathVariable Long userIdx) {
		UserDto dto = adminMemberService.getMemberDetail(userIdx);
		if (dto == null)
			return ResponseEntity.notFound().build();
		return ResponseEntity.ok(dto);
	}

	@PostMapping("/status")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateStatus(@RequestBody Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			adminMemberService.updateMemberStatus(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("msg", e.getMessage());
		}
		return ResponseEntity.ok(result);
	}

	@PostMapping("/authority")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateAuthority(@RequestBody Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			adminMemberService.updateAuthority(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("msg", e.getMessage());
		}
		return ResponseEntity.ok(result);
	}

	@GetMapping("/sanction")
	public String sanctionList(
	        @RequestParam(name = "page", defaultValue = "1") int page, 
	        @RequestParam(name = "kwd", required = false) String kwd,
	        Model model) {

		int pageSize = 15;
		int offset = (page - 1) * pageSize;

		Map<String, Object> map = new HashMap<>();
		map.put("kwd", kwd);
		map.put("offset", offset);
		map.put("pageSize", pageSize);

		List<Map<String, Object>> list = adminMemberService.listSanctions(map);
		int totalCount = adminMemberService.countSanctions(map);
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		model.addAttribute("list", list);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("page", page);
		model.addAttribute("kwd", kwd);

		return "admin/member/sanction";
	}

	@PostMapping("/sanction/add")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> addSanction(@RequestBody Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			adminMemberService.insertSanction(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("msg", e.getMessage());
		}
		return ResponseEntity.ok(result);
	}

	@PostMapping("/sanction/lift")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> liftSanction(@RequestBody Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			adminMemberService.liftSanction(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("msg", e.getMessage());
		}
		return ResponseEntity.ok(result);
	}

	@GetMapping("/withdrawal")
	public String withdrawalList(
	        @RequestParam(name = "page", defaultValue = "1") int page, 
	        @RequestParam(name = "kwd", required = false) String kwd,
	        Model model) {

		int pageSize = 15;
		int offset = (page - 1) * pageSize;

		Map<String, Object> map = new HashMap<>();
		map.put("kwd", kwd);
		map.put("offset", offset);
		map.put("pageSize", pageSize);

		List<Map<String, Object>> list = adminMemberService.listWithdrawals(map);
		int totalCount = adminMemberService.countWithdrawals(map);
		int totalPages = (int) Math.ceil((double) totalCount / pageSize);

		model.addAttribute("list", list);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("page", page);
		model.addAttribute("kwd", kwd);

		return "admin/member/withdrawal";
	}

	@PostMapping("/withdrawal/approve")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> approveWithdrawal(@RequestBody Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			adminMemberService.approveWithdrawal(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("msg", e.getMessage());
		}
		return ResponseEntity.ok(result);
	}

	@PostMapping("/withdrawal/reject")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> rejectWithdrawal(@RequestBody Map<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			adminMemberService.rejectWithdrawal(param);
			result.put("success", true);
		} catch (Exception e) {
			result.put("success", false);
			result.put("msg", e.getMessage());
		}
		return ResponseEntity.ok(result);
	}
}