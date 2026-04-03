package com.sp.app.service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.domain.dto.AttendeeDto;
import com.sp.app.domain.dto.CrewScheduleRequestDto;
import com.sp.app.domain.dto.CrewScheduleResponseDto;
import com.sp.app.domain.entity.Crew;
import com.sp.app.domain.entity.CrewSchedule;
import com.sp.app.domain.entity.CrewScheduleVote;
import com.sp.app.domain.entity.User;
import com.sp.app.repository.CrewRepository;
import com.sp.app.repository.CrewScheduleRepository;
import com.sp.app.repository.CrewScheduleVoteRepository;
import com.sp.app.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class CrewScheduleServiceImpl implements CrewScheduleService {

    private final CrewScheduleRepository scheduleRepository;
    private final CrewScheduleVoteRepository voteRepository;
    
    private final CrewRepository crewRepository;
    private final UserRepository userRepository;
    
    @Override
    @Transactional
    public Long createSchedule(Long crewIdx, Long userIdx, CrewScheduleRequestDto req) {
    	User user = userRepository.findById(userIdx)
	            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저입니다. ID: " + userIdx));
    	
    	Crew crew = crewRepository.findById(crewIdx)
	            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 모임입니다. ID: " + crewIdx));
    	
        CrewSchedule schedule = CrewSchedule.builder()
                .crew(crew)
                .user(user)
                .title(req.getTitle())
                .content(req.getContent())
                .startDate(req.getStartDate())
                .endDate(req.getEndDate())
                .locationName(req.getLocationName())
                .lat(req.getLat())
                .lng(req.getLng())
                .maxPeople(req.getMaxPeople())
                .build();
        
        scheduleRepository.save(schedule);
        
        CrewScheduleVote hostVote = CrewScheduleVote.builder()
                .schedule(schedule)
                .user(user)
                .status("ATTEND")
                .build();
        
        voteRepository.save(hostVote);
                
        return schedule.getScheduleIdx();
    }

    @Override
    public CrewScheduleResponseDto getScheduleDetail(Long scheduleIdx, Long userIdx) {
        CrewSchedule schedule = scheduleRepository.findById(scheduleIdx)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 일정입니다."));
        
        int currentCount = voteRepository.countBySchedule_ScheduleIdxAndStatus(scheduleIdx, "ATTEND");
        boolean isAttending = voteRepository.findBySchedule_ScheduleIdxAndUser_UserIdx(scheduleIdx, userIdx).isPresent();
        List<AttendeeDto> attendees = getAttendees(scheduleIdx, schedule.getUser().getUserIdx());
        
        return CrewScheduleResponseDto.fromEntity(schedule, currentCount, isAttending, attendees);
    }

    @Override
    @Transactional
    public void updateSchedule(Long scheduleIdx, Long userIdx, CrewScheduleRequestDto req) {
        CrewSchedule schedule = scheduleRepository.findById(scheduleIdx)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 일정입니다."));
        
        if (schedule.getUser() == null || !schedule.getUser().getUserIdx().equals(userIdx)) {
            throw new SecurityException("수정 권한이 없습니다.");
        }

        schedule.setTitle(req.getTitle());
        schedule.setContent(req.getContent());
        schedule.setStartDate(req.getStartDate());
        schedule.setEndDate(req.getEndDate());
        schedule.setLocationName(req.getLocationName());
        schedule.setLat(req.getLat());
        schedule.setLng(req.getLng());
        schedule.setMaxPeople(req.getMaxPeople());
    }

    @Override
    @Transactional
    public void deleteSchedule(Long scheduleIdx, Long userIdx) {
        CrewSchedule schedule = scheduleRepository.findById(scheduleIdx)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 일정입니다."));
        
        if (schedule.getUser() == null || !schedule.getUser().getUserIdx().equals(userIdx)) {
            throw new SecurityException("삭제 권한이 없습니다.");
        }
        
        scheduleRepository.delete(schedule);
    }
    
    @Override
    @Transactional
    public boolean toggleVote(Long scheduleIdx, Long userIdx, String newStatus) {
        CrewSchedule schedule = scheduleRepository.findById(scheduleIdx)
                .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 일정입니다."));
        
        if (schedule.getStartDate().isBefore(LocalDateTime.now())) {
            throw new IllegalStateException("이미 시작되었거나 종료된 일정은 참석 여부를 변경할 수 없습니다.");
        }
        
        User user = userRepository.findById(userIdx)
	            .orElseThrow(() -> new IllegalArgumentException("존재하지 않는 유저입니다. ID: " + userIdx));
        
        Optional<CrewScheduleVote> existingVote = 
                voteRepository.findBySchedule_ScheduleIdxAndUser_UserIdx(scheduleIdx, userIdx);
        
        if (existingVote.isPresent()) {
            CrewScheduleVote vote = existingVote.get();
            if (vote.getStatus().equals(newStatus)) {
                voteRepository.delete(vote);
                return false;
            }
            voteRepository.delete(vote);
        }
        
        if ("ATTEND".equals(newStatus)) {
            int currentCount = voteRepository.countBySchedule_ScheduleIdxAndStatus(scheduleIdx, "ATTEND");
            if (schedule.getMaxPeople() > 0 && currentCount >= schedule.getMaxPeople()) {
                throw new IllegalStateException("모임 정원이 초과되었습니다.");
            }
        }

        CrewScheduleVote newVote = CrewScheduleVote.builder()
                .schedule(schedule)
                .user(user)
                .status(newStatus)
                .build();

        voteRepository.save(newVote);
        return true;
    }

    @Override
    public List<CrewScheduleResponseDto> getAllSchedules(Long userIdx, Long crewIdx) {
    	List<CrewSchedule> schedules = scheduleRepository.findAllByCrew_CrewIdx(crewIdx);
        return convertToDtoList(schedules, userIdx);
    }

    @Override
    public List<CrewScheduleResponseDto> getMonthlySchedules(Long userIdx, Long crewIdx, int year, int month) {
        YearMonth yearMonth = YearMonth.of(year, month);
        LocalDateTime start = yearMonth.atDay(1).atStartOfDay(); 
        LocalDateTime end = yearMonth.atEndOfMonth().atTime(LocalTime.MAX); 
        
        List<CrewSchedule> schedules = scheduleRepository.findAllByCrew_CrewIdxAndStartDateBetweenOrderByStartDateAsc(crewIdx, start, end);
        return convertToDtoList(schedules, userIdx);
    }

    @Override
    public List<CrewScheduleResponseDto> getWeeklySchedules(Long userIdx, Long crewIdx, LocalDate startOfWeek, LocalDate endOfWeek) {
        LocalDateTime start = startOfWeek.atStartOfDay();
        LocalDateTime end = endOfWeek.atTime(LocalTime.MAX);
        
        List<CrewSchedule> schedules = scheduleRepository.findAllByCrew_CrewIdxAndStartDateBetweenOrderByStartDateAsc(crewIdx, start, end);
        return convertToDtoList(schedules, userIdx);
    }

    @Override
    public List<CrewScheduleResponseDto> getDailySchedules(Long userIdx, Long crewIdx, LocalDate date) {
        LocalDateTime start = date.atStartOfDay();
        LocalDateTime end = date.atTime(LocalTime.MAX);
        
        List<CrewSchedule> schedules = scheduleRepository.findAllByCrew_CrewIdxAndStartDateBetweenOrderByStartDateAsc(crewIdx, start, end);
        return convertToDtoList(schedules, userIdx);
    }
    
    @Override
    public List<CrewScheduleResponseDto> getUpcomingSchedules(Long userIdx, Long crewIdx) {
    	LocalDateTime now = LocalDateTime.now();
        
        LocalDateTime endOfWeek = now.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY))
                                     .withHour(23).withMinute(59).withSecond(59);
    	
    	List<CrewSchedule> schedules = scheduleRepository.findTop3ByCrew_CrewIdxAndStartDateBetweenOrderByStartDateAsc(crewIdx, now, endOfWeek);
    	return convertToDtoList(schedules, userIdx);
    }
    
    private List<CrewScheduleResponseDto> convertToDtoList(List<CrewSchedule> schedules, Long userIdx) {
        return schedules.stream()
                .map(entity -> {
                    int count = voteRepository.countBySchedule_ScheduleIdxAndStatus(entity.getScheduleIdx(), "ATTEND");
                    
                    boolean isAttending = voteRepository.findBySchedule_ScheduleIdxAndUser_UserIdx(entity.getScheduleIdx(), userIdx)
                            .isPresent();
                    
                    return CrewScheduleResponseDto.fromEntity(entity, count, isAttending, null);
                })
                .collect(Collectors.toList());
    }
    
    public List<AttendeeDto> getAttendees(Long scheduleIdx, Long hostUserIdx) {
        List<CrewScheduleVote> votes = voteRepository.findAllBySchedule_ScheduleIdx(scheduleIdx);

        return votes.stream()
                .filter(vote -> "ATTEND".equals(vote.getStatus()))
                .map((CrewScheduleVote vote) -> {
                    User user = vote.getUser();
                    return AttendeeDto.builder()
                            .nickname(user.getNickname())
                            .profileImg(user.getProfilePhoto())
                            .isHost(user.getUserIdx().equals(hostUserIdx))
                            .build();
                })
                .collect(Collectors.toList());
    }
}