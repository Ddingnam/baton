package com.sp.app.admin.mapper;

import com.sp.app.admin.model.AdminCalendarEvent;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminCalendarMapper {
    List<AdminCalendarEvent> listEvents(@Param("adminIdx") Long adminIdx,
                                        @Param("from") String from,
                                        @Param("to") String to);

    AdminCalendarEvent findById(@Param("id") Long id, @Param("adminIdx") Long adminIdx);

    void insertEvent(AdminCalendarEvent event);

    int updateEvent(AdminCalendarEvent event);

    int deleteEvent(@Param("id") Long id, @Param("adminIdx") Long adminIdx);
}
