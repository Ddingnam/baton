package com.sp.app.admin.mapper;

import com.sp.app.admin.model.AdminTodo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminTodoMapper {
	public List<AdminTodo> getTodoList(@Param("adminIdx") Long adminIdx);
	public void insertTodo(AdminTodo todo);
	public void updateTodoDone(@Param("todoIdx") Long todoIdx, @Param("adminIdx") Long adminIdx, @Param("isDone") int isDone);
	public void updateTodoContent(@Param("todoIdx") Long todoIdx, @Param("adminIdx") Long adminIdx, @Param("content") String content);
	public void deleteTodo(@Param("todoIdx") Long todoIdx, @Param("adminIdx") Long adminIdx);
	public void deleteDoneTodos(@Param("adminIdx") Long adminIdx);
}