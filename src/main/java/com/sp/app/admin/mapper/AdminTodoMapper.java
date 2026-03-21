package com.sp.app.admin.mapper;

import com.sp.app.admin.model.AdminTodo;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AdminTodoMapper {

    @Select("SELECT todoIdx, adminIdx, content, isDone, sortOrder, " +
            "TO_CHAR(createdAt, 'YYYY-MM-DD HH24:MI') AS createdAt " +
            "FROM ADMIN_TODO " +
            "WHERE adminIdx = #{adminIdx} " +
            "ORDER BY isDone ASC, sortOrder ASC, todoIdx DESC")
    List<AdminTodo> getTodoList(@Param("adminIdx") Long adminIdx);

    @Insert("INSERT INTO ADMIN_TODO (todoIdx, adminIdx, content, isDone, sortOrder, createdAt, updatedAt) " +
            "VALUES (admin_todo_seq.NEXTVAL, #{adminIdx}, #{content}, 0, " +
            "NVL((SELECT MAX(sortOrder) + 1 FROM ADMIN_TODO WHERE adminIdx = #{adminIdx}), 0), " +
            "SYSTIMESTAMP, SYSTIMESTAMP)")
    void insertTodo(AdminTodo todo);

    @Update("UPDATE ADMIN_TODO SET isDone = #{isDone}, updatedAt = SYSTIMESTAMP " +
            "WHERE todoIdx = #{todoIdx} AND adminIdx = #{adminIdx}")
    void updateTodoDone(@Param("todoIdx") Long todoIdx, @Param("adminIdx") Long adminIdx, @Param("isDone") int isDone);

    @Update("UPDATE ADMIN_TODO SET content = #{content}, updatedAt = SYSTIMESTAMP " +
            "WHERE todoIdx = #{todoIdx} AND adminIdx = #{adminIdx}")
    void updateTodoContent(@Param("todoIdx") Long todoIdx, @Param("adminIdx") Long adminIdx, @Param("content") String content);

    @Delete("DELETE FROM ADMIN_TODO WHERE todoIdx = #{todoIdx} AND adminIdx = #{adminIdx}")
    void deleteTodo(@Param("todoIdx") Long todoIdx, @Param("adminIdx") Long adminIdx);

    @Delete("DELETE FROM ADMIN_TODO WHERE adminIdx = #{adminIdx} AND isDone = 1")
    void deleteDoneTodos(@Param("adminIdx") Long adminIdx);
}