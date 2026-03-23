package com.sp.app.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sp.app.domain.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
	@Query(value = "SELECT NICKNAME AS nickname, PROFILE_PHOTO AS profilePhoto " +
            "FROM Users WHERE USERIDX = :userIdx", 
    nativeQuery = true)
	Optional<BoardUserInfo> findBoardUserInfoByUserIdx(@Param("userIdx") Long userIdx);
}
