package com.sp.app.service;

import java.util.List;

import com.sp.app.domain.entity.User;

public interface FollowService {
	public long follow(Long followerIdx, Long followingIdx) throws Exception;
	public long unfollow(Long followerIdx, Long followingIdx) throws Exception;
	public boolean isFollowing(Long followerIdx, Long followingIdx);
	
	public long countByFollowing(long userIdx);
	public long countByFollower(long userIdx);
	
	public List<User> getFollowerList(Long userIdx);
	public List<User> getFollowingList(Long userIdx);
}
