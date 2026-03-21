package com.sp.app.admin.service;

import com.sp.app.admin.mapper.AdminCalMemoMapper;
import com.sp.app.admin.mapper.AdminTodoMapper;
import com.sp.app.admin.model.AdminCalMemo;
import com.sp.app.admin.model.AdminTodo;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminUtilServiceImpl implements AdminUtilService {

    private final AdminCalMemoMapper calMemoMapper;
    private final AdminTodoMapper todoMapper;

    @Override
    public AdminCalMemo getMemo(Long adminIdx, String memoDate) {
        return calMemoMapper.getMemo(adminIdx, memoDate);
    }

    @Override
    public List<AdminCalMemo> getMemosByMonth(Long adminIdx, String yearMonth) {
        return calMemoMapper.getMemosByMonth(adminIdx, yearMonth);
    }

    @Override
    public void saveMemo(Long adminIdx, String memoDate, String content) {
        AdminCalMemo memo = new AdminCalMemo();
        memo.setAdminIdx(adminIdx);
        memo.setMemoDate(memoDate);
        memo.setContent(content);
        calMemoMapper.saveMemo(memo);
    }

    @Override
    public void deleteMemo(Long adminIdx, String memoDate) {
        calMemoMapper.deleteMemo(adminIdx, memoDate);
    }

    @Override
    public List<AdminTodo> getTodoList(Long adminIdx) {
        return todoMapper.getTodoList(adminIdx);
    }

    @Override
    public AdminTodo addTodo(Long adminIdx, String content) {
        AdminTodo todo = new AdminTodo();
        todo.setAdminIdx(adminIdx);
        todo.setContent(content);
        todoMapper.insertTodo(todo);
        return todo;
    }

    @Override
    public void toggleTodo(Long adminIdx, Long todoIdx, int isDone) {
        todoMapper.updateTodoDone(todoIdx, adminIdx, isDone);
    }

    @Override
    public void editTodo(Long adminIdx, Long todoIdx, String content) {
        todoMapper.updateTodoContent(todoIdx, adminIdx, content);
    }

    @Override
    public void deleteTodo(Long adminIdx, Long todoIdx) {
        todoMapper.deleteTodo(todoIdx, adminIdx);
    }

    @Override
    public void deleteDoneTodos(Long adminIdx) {
        todoMapper.deleteDoneTodos(adminIdx);
    }
}