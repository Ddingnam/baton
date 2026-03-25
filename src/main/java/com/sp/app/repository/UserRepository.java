package com.sp.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
}
