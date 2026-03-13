window.FollowModule = {
    isProcessing: false,
	toggle: function(followingIdx) {
	        if(this.isProcessing) return;
	        
	        const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
	        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
	        const headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
	        if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

	        this.isProcessing = true;

	        fetch('/trade/toggleFollow', {
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
	                    // 버튼 스타일 및 텍스트 변경
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
	    }
};