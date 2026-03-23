package com.sp.app.admin.mapper;

import com.sp.app.admin.model.AdminCalMemo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminCalMemoMapper {
	public AdminCalMemo getMemo(@Param("adminIdx") Long adminIdx, @Param("memoDate") String memoDate);
	public List<AdminCalMemo> getMemosByMonth(@Param("adminIdx") Long adminIdx, @Param("yearMonth") String yearMonth);
	public void saveMemo(AdminCalMemo memo);
	public void deleteMemo(@Param("adminIdx") Long adminIdx, @Param("memoDate") String memoDate);
}