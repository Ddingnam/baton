package com.sp.app.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sp.app.domain.dto.CrewScheduleRequestDto;
import com.sp.app.domain.dto.CrewScheduleResponseDto;
import com.sp.app.security.CustomUserDetails;
import com.sp.app.service.CrewScheduleService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/crew/schedule")
public class CrewScheduleRestController {

    private final CrewScheduleService crewScheduleService;

    @PostMapping("/{crewIdx}")
    public ResponseEntity<String> createSchedule(
    		@PathVariable("crewIdx") Long crewIdx,
            @RequestBody CrewScheduleRequestDto requestDto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        Long scheduleIdx = crewScheduleService.createSchedule(crewIdx, userIdx, requestDto);
        return ResponseEntity.status(HttpStatus.CREATED).body("일정이 성공적으로 생성되었습니다. (ID: " + scheduleIdx + ")");
    }

    @GetMapping("/detail/{scheduleIdx}")
    public ResponseEntity<CrewScheduleResponseDto> getScheduleDetail(
    		@PathVariable("scheduleIdx") Long scheduleIdx,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
    	Long userIdx = userDetails.getMember().getUserIdx();
        CrewScheduleResponseDto responseDto = crewScheduleService.getScheduleDetail(scheduleIdx, userIdx);
        return ResponseEntity.ok(responseDto);
    }

    @PostMapping("/{scheduleIdx}/update")
    public ResponseEntity<String> updateSchedule(
    		@PathVariable("scheduleIdx") Long scheduleIdx,
            @RequestBody CrewScheduleRequestDto requestDto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        Long userIdx = userDetails.getMember().getUserIdx();
        crewScheduleService.updateSchedule(scheduleIdx, userIdx, requestDto);
        return ResponseEntity.ok("일정이 수정되었습니다.");
    }

    @PostMapping("/{scheduleIdx}/delete")
    public ResponseEntity<String> deleteSchedule(
    		@PathVariable("scheduleIdx") Long scheduleIdx,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        
        Long userIdx = userDetails.getMember().getUserIdx();
        crewScheduleService.deleteSchedule(scheduleIdx, userIdx);
        return ResponseEntity.ok("일정이 삭제되었습니다.");
    }

    @PostMapping("/{scheduleIdx}/vote")
    public ResponseEntity<?> toggleVote(
    		@PathVariable("scheduleIdx") Long scheduleIdx,
            @RequestParam("status") String status,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
        try {
        	Long userIdx = userDetails.getMember().getUserIdx();
            boolean isRegistered = crewScheduleService.toggleVote(scheduleIdx, userIdx, status);
            
            if (isRegistered) {
                return ResponseEntity.ok("상태가 [" + status + "](으)로 등록/변경되었습니다.");
            } else {
                return ResponseEntity.ok("참여 의사가 취소되었습니다.");
            }
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
    
    @GetMapping("/{crewIdx}/monthly")
    public ResponseEntity<List<CrewScheduleResponseDto>> getMonthlySchedules(
    		@PathVariable("crewIdx") Long crewIdx,
            @RequestParam("year") int year,
            @RequestParam("month") int month,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewScheduleResponseDto> schedules = crewScheduleService.getMonthlySchedules(userIdx, crewIdx, year, month);
        return ResponseEntity.ok(schedules);
    }

    @GetMapping("/{crewIdx}/daily")
    public ResponseEntity<List<CrewScheduleResponseDto>> getDailySchedules(
    		@PathVariable("crewIdx") Long crewIdx,
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @AuthenticationPrincipal CustomUserDetails userDetails) {
    	
    	Long userIdx = userDetails.getMember().getUserIdx();
        List<CrewScheduleResponseDto> schedules = crewScheduleService.getDailySchedules(userIdx, crewIdx, date);
        return ResponseEntity.ok(schedules);
    }

    @GetMapping("/{crewIdx}/upcoming")
    public ResponseEntity<List<CrewScheduleResponseDto>> getUpcomingSchedules(
    		@PathVariable("crewIdx") Long crewIdx,
    		@AuthenticationPrincipal CustomUserDetails userDetails) {
    	
    	Long userIdx = userDetails.getMember().getUserIdx();
    	
        List<CrewScheduleResponseDto> schedules = crewScheduleService.getUpcomingSchedules(userIdx, crewIdx);
        return ResponseEntity.ok(schedules);
    }
}