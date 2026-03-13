package com.sp.app.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.sp.app.domain.entity.Follow;
import com.sp.app.domain.entity.User;
import com.sp.app.repository.FollowRepository;
import com.sp.app.repository.UserRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional
public class FollowServiceImpl implements FollowService{
	private final FollowRepository followRepository;
    private final UserRepository userRepository;

	@Override
	public long follow(Long followerIdx, Long followingIdx) throws Exception {
		if (followerIdx.equals(followingIdx)) throw new RuntimeException("자기 자신은 팔로우 불가");

        User follower = userRepository.findById(followerIdx).orElseThrow();
        User following = userRepository.findById(followingIdx).orElseThrow();
        
        if (!followRepository.existsByFollowerAndFollowing(follower, following)) {
            followRepository.save(new Follow(follower, following));
        }
        
        return followRepository.countByFollowing(following);
	}

	@Override
	public long unfollow(Long followerIdx, Long followingIdx) throws Exception {
		User follower = userRepository.findById(followerIdx).orElseThrow();
        User following = userRepository.findById(followingIdx).orElseThrow();
        
        followRepository.deleteByFollowerAndFollowing(follower, following);
        
        return followRepository.countByFollowing(following);
		
	}

	@Override
	public boolean isFollowing(Long followerIdx, Long followingIdx) {
		User follower = userRepository.getReferenceById(followerIdx);
        User following = userRepository.getReferenceById(followingIdx);
        return followRepository.existsByFollowerAndFollowing(follower, following);
	}

	@Override
	public long countByFollowing(long userIdx) {
		User user = userRepository.getReferenceById(userIdx);
	    return followRepository.countByFollowing(user);
	}

	@Override
	public long countByFollower(long userIdx) {
		User user = userRepository.getReferenceById(userIdx);
	    return followRepository.countByFollower(user);
	}

	@Override
	public List<User> getFollowerList(Long userIdx) {
		return followRepository.findFollowerList(userIdx);
	}

	@Override
	public List<User> getFollowingList(Long userIdx) {
		return followRepository.findFollowingList(userIdx);
	}

}
