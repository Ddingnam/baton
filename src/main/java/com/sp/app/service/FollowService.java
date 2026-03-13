package com.sp.app.service;

public interface FollowService {
	public long follow(Long followerIdx, Long followingIdx) throws Exception;
	public long unfollow(Long followerIdx, Long followingIdx) throws Exception;
	public boolean isFollowing(Long followerIdx, Long followingIdx);
}
