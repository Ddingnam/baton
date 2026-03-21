package com.sp.app.admin.service;

import com.sp.app.admin.model.AdminCalMemo;
import com.sp.app.admin.model.AdminTodo;

import java.util.List;

public interface AdminUtilService {
	public AdminCalMemo getMemo(Long adminIdx, String memoDate);
	public List<AdminCalMemo> getMemosByMonth(Long adminIdx, String yearMonth);
	public void saveMemo(Long adminIdx, String memoDate, String content);
	public void deleteMemo(Long adminIdx, String memoDate);

	public List<AdminTodo> getTodoList(Long adminIdx);
	public AdminTodo addTodo(Long adminIdx, String content);
	public void toggleTodo(Long adminIdx, Long todoIdx, int isDone);
	public void editTodo(Long adminIdx, Long todoIdx, String content);
	public void deleteTodo(Long adminIdx, Long todoIdx);
	public void deleteDoneTodos(Long adminIdx);
}