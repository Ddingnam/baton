package com.sp.app.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sp.app.domain.entity.Follow;
import com.sp.app.domain.entity.User;

public interface FollowRepository extends JpaRepository<Follow, Long> {

    boolean existsByFollowerAndFollowing(User follower, User following);

    void deleteByFollowerAndFollowing(User follower, User following);

    Long countByFollower(User follower);

    Long countByFollowing(User following);
}
