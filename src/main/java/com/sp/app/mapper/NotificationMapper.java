package com.sp.app.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.sp.app.model.Notification;

@Mapper
public interface NotificationMapper {

    @Insert("INSERT INTO NOTIFICATION (notifIdx, userIdx, notifType, content, url, isRead, createdAt) " +
            "VALUES (notifSeq.NEXTVAL, #{userIdx}, #{notifType}, #{content}, #{url}, 0, SYSTIMESTAMP)")
    @Options(useGeneratedKeys = false)
    void insertNotification(Notification notification);

    @Select("SELECT notifIdx, userIdx, notifType, content, url, isRead, " +
            "TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI') AS createdAt " +
            "FROM NOTIFICATION WHERE userIdx = #{userIdx} ORDER BY notifIdx DESC")
    @Results({
        @Result(property = "notifIdx",  column = "NOTIFIDX"),
        @Result(property = "userIdx",   column = "USERIDX"),
        @Result(property = "notifType", column = "NOTIFTYPE"),
        @Result(property = "content",   column = "CONTENT"),
        @Result(property = "url",       column = "URL"),
        @Result(property = "isRead",    column = "ISREAD"),
        @Result(property = "createdAt", column = "CREATEDAT")
    })
    List<Notification> listNotification(@Param("userIdx") Long userIdx);

    @Update("UPDATE NOTIFICATION SET isRead = 1 WHERE notifIdx = #{notifIdx}")
    void updateNotificationRead(@Param("notifIdx") Long notifIdx);

    @Update("UPDATE NOTIFICATION SET isRead = 1 WHERE userIdx = #{userIdx}")
    void updateAllNotificationRead(@Param("userIdx") Long userIdx);

    @Select("SELECT COUNT(*) FROM NOTIFICATION WHERE userIdx = #{userIdx} AND isRead = 0")
    int unreadNotificationCount(@Param("userIdx") Long userIdx);

    @Delete("DELETE FROM NOTIFICATION WHERE userIdx = #{userIdx}")
    void deleteAllNotifications(@Param("userIdx") Long userIdx);

    @Delete("DELETE FROM NOTIFICATION WHERE notifIdx = #{notifIdx}")
    void deleteNotification(@Param("notifIdx") Long notifIdx);
}