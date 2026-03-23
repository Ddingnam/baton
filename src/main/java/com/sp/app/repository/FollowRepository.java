package com.sp.app.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.sp.app.domain.entity.Follow;
import com.sp.app.domain.entity.User;

public interface FollowRepository extends JpaRepository<Follow, Long> {

    boolean existsByFollowerAndFollowing(User follower, User following);
    void deleteByFollowerAndFollowing(User follower, User following);
    
    Long countByFollower(User follower);
    Long countByFollowing(User following);
    
    @Query("SELECT f.follower FROM Follow f WHERE f.following.userIdx = :userIdx AND f.following.status = 1")
    List<User> findFollowerList(@Param("userIdx") Long userIdx);

    @Query("SELECT f.following FROM Follow f WHERE f.follower.userIdx = :userIdx AND f.following.status = 1")
    List<User> findFollowingList(@Param("userIdx") Long userIdx);
}
