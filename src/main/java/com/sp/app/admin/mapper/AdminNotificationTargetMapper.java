package com.sp.app.admin.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface AdminNotificationTargetMapper {

    @Select("SELECT userIdx FROM users WHERE userLevel = 99 AND status = 1")
    public List<Long> findAdminUserIdxList();
}