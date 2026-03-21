package com.sp.app.admin.mapper;

import com.sp.app.admin.model.AdminCalMemo;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AdminCalMemoMapper {

    @Select("SELECT memoIdx, adminIdx, memoDate, content, " +
            "TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI') AS createdAt, " +
            "TO_CHAR(updatedAt, 'YYYY-MM-DD HH24:MI') AS updatedAt " +
            "FROM ADMIN_CAL_MEMO " +
            "WHERE adminIdx = #{adminIdx} AND memoDate = #{memoDate}")
    AdminCalMemo getMemo(@Param("adminIdx") Long adminIdx, @Param("memoDate") String memoDate);

    @Select("SELECT memoIdx, adminIdx, memoDate, content, " +
            "TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI') AS createdAt " +
            "FROM ADMIN_CAL_MEMO " +
            "WHERE adminIdx = #{adminIdx} AND memoDate LIKE #{yearMonth} || '%' " +
            "ORDER BY memoDate ASC")
    List<AdminCalMemo> getMemosByMonth(@Param("adminIdx") Long adminIdx, @Param("yearMonth") String yearMonth);

    @Insert("<script>" +
            "MERGE INTO ADMIN_CAL_MEMO tgt " +
            "USING (SELECT #{adminIdx} AS adminIdx, #{memoDate} AS memoDate FROM DUAL) src " +
            "ON (tgt.adminIdx = src.adminIdx AND tgt.memoDate = src.memoDate) " +
            "WHEN MATCHED THEN UPDATE SET content = #{content}, updatedAt = SYSTIMESTAMP " +
            "WHEN NOT MATCHED THEN INSERT (memoIdx, adminIdx, memoDate, content, createdAt, updatedAt) " +
            "VALUES (admin_cal_memo_seq.NEXTVAL, #{adminIdx}, #{memoDate}, #{content}, SYSTIMESTAMP, SYSTIMESTAMP)" +
            "</script>")
    void saveMemo(AdminCalMemo memo);

    @Delete("DELETE FROM ADMIN_CAL_MEMO WHERE adminIdx = #{adminIdx} AND memoDate = #{memoDate}")
    void deleteMemo(@Param("adminIdx") Long adminIdx, @Param("memoDate") String memoDate);
}