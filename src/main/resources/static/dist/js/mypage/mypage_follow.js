window.FollowModule = {
    isProcessing: false,
	
	toggle: function(followingIdx) {
		if(this.isProcessing) return;
	        
		const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
		const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
		const headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
		if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

		this.isProcessing = true;

		fetch('/api/trade/toggleFollow', {
			method: 'POST',
			headers: headers,
			body: new URLSearchParams({ followingIdx: followingIdx })
		})
		.then(response => response.json())
		.then(data => {
			if(data.status === 'success') {
				const btn = document.getElementById('btnFollow');
				const followerCountEl = document.getElementById('followerCount'); // 팔로워 숫자 엘리먼트

				if(btn) {
					if(data.isFollowing) {
						btn.classList.add('following');
	                    btn.innerText = '팔로잉';
	                } else {
	                	btn.classList.remove('following');
	                    btn.innerText = '팔로우';
					}
				}

				if(followerCountEl && data.followerCount !== undefined) {
					followerCountEl.innerText = data.followerCount + ' 명';
				}

				showBatonToast(data.isFollowing ? "팔로우를 시작했습니다." : "팔로우를 취소했습니다.");
			} else if(data.status === 'loginRequired') {
				alert("로그인이 필요합니다.");
				location.href = "/member/login";
			}
		})
		.catch(err => {
	    	console.error("팔로우 에러:", err);
			showBatonToast("오류가 발생했습니다.");
		})
		.finally(() => { this.isProcessing = false; });
	},
		
	loadList: function(type, userIdx, containerId) {
		const container = document.getElementById(containerId);
		if(!container) return;

		fetch(`/mypage/followList?userIdx=${userIdx}&type=${type}`)
		.then(response => response.json())
		.then(data => {
		    const list = data.list || (Array.isArray(data) ? data : []);
		    
		    container.innerHTML = '';
		    
		    if (list.length > 0) {
		        list.forEach(user => {
		            const photo = user.profile_photo ? `/uploads/profile/${user.profile_photo}` : '/dist/images/default-profile.png';
		            const html = `
		                <div class="lc-item">
		                    <div class="item-icon theme-icon-bg" style="background-image: url('${photo}'); background-size: cover; border-radius: 50%;">
		                        ${user.profile_photo ? '' : '<i class="ri-user-smile-fill"></i>'}
		                    </div>
		                    <div class="item-info">
		                        <h4>${user.nickname}</h4>
		                        
		                    </div>
		                    <div class="item-right">
		                        <button class="theme-btn-outline" 
		                            onclick="location.href='/mypage/tradeUserMain?userIdx=${user.userIdx}'">
		                            상점방문
		                        </button>
		                    </div>
		                </div>`;
		            container.innerHTML += html;
		        });
		    } else {
		        container.innerHTML = `
		            <div class="lc-empty">
		                <i class="ri-user-unfollow-line"></i>
		                <p>${type === 'follower' ? '나를 팔로우하는 사람이 아직 없어요.' : '아직 팔로우한 사람이 없어요.'}</p>
		            </div>`;
		    }
		})
		.catch(err => {
			console.error("목록 로딩 에러:", err);
			container.innerHTML = '<p class="text-center p-4">목록을 불러오지 못했습니다.</p>';
		});
	}		
};

document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.inner-tab').forEach(function(tab) {
        tab.addEventListener('click', function() {
            const targetId = this.getAttribute('data-inner');
            
            if (targetId === 'trade-follower' || targetId === 'trade-following') {
                const type = (targetId === 'trade-follower') ? 'follower' : 'following';
                
                const userIdx = document.getElementById('sessionUserIdx')?.value; 
                
                if(userIdx) {
                    const section = document.getElementById(targetId);
                    const container = section.querySelector('.lc-list');
                    
                    if(container) {
                        if(!container.id) container.id = targetId + '-list-box';
                        FollowModule.loadList(type, userIdx, container.id);
                    }
                }
            }
        });
    });
});