package com.sp.app.service;

public interface FollowService {
	public void follow(Long followerIdx, Long followingIdx) throws Exception;
	public void unfollow(Long followerIdx, Long followingIdx) throws Exception;
	public boolean isFollowing(Long followerIdx, Long followingIdx);
}
