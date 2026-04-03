package com.sp.app.service;

import java.time.LocalDate;
import java.util.List;

import com.sp.app.domain.dto.CrewScheduleRequestDto;
import com.sp.app.domain.dto.CrewScheduleResponseDto;

public interface CrewScheduleService {
	// 1. 일정 CRUD
    Long createSchedule(Long crewIdx, Long userIdx, CrewScheduleRequestDto req);
    CrewScheduleResponseDto getScheduleDetail(Long scheduleIdx, Long userIdx);
    void updateSchedule(Long scheduleIdx, Long userIdx, CrewScheduleRequestDto req);
    void deleteSchedule(Long scheduleIdx, Long userIdx);

    boolean toggleVote(Long scheduleIdx, Long userIdx, String newStatus);

    // 3. 기간별 리스트 조회
    List<CrewScheduleResponseDto> getAllSchedules(Long userIdx, Long crewIdx);
    List<CrewScheduleResponseDto> getMonthlySchedules(Long userIdx, Long crewIdx, int year, int month);
    List<CrewScheduleResponseDto> getWeeklySchedules(Long userIdx, Long crewIdx, LocalDate startOfWeek, LocalDate endOfWeek);
    List<CrewScheduleResponseDto> getDailySchedules(Long userIdx, Long crewIdx, LocalDate date);

    // 4. [보너스] 대시보드용 다가오는 일정
    List<CrewScheduleResponseDto> getUpcomingSchedules(Long userIdx, Long crewIdx);
}