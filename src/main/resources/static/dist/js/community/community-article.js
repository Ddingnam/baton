document.addEventListener('DOMContentLoaded', () => {
    try {
        initMap();
    } catch (e) {
        console.error("Map initialization failed:", e);
    }
    
    initPoll();
    loadReplies();
    formatPollDate();
});

function initMap() {
    const mapContainer = document.getElementById('map');
    if (!mapContainer) return;

    const latStr = mapContainer.dataset.lat;
    const lngStr = mapContainer.dataset.lng;

    if (!latStr || !lngStr) return;

    const lat = parseFloat(latStr);
    const lng = parseFloat(lngStr);

    if (typeof kakao === 'undefined' || !kakao.maps) {
        console.error("Kakao Maps API is not loaded.");
        return;
    }

    kakao.maps.load(() => {
        const options = {
            center: new kakao.maps.LatLng(lat, lng),
            level: 3
        };

        const map = new kakao.maps.Map(mapContainer, options);
        
        const markerPosition  = new kakao.maps.LatLng(lat, lng); 
        const marker = new kakao.maps.Marker({
            position: markerPosition
        });
        marker.setMap(map);
        
        map.setDraggable(false);
        map.setZoomable(false);
    });
}

function formatPollDate() {
    const el = document.getElementById('pollEndDate');
    if(!el) return;
    
    const dateStr = el.dataset.date;
    if(!dateStr) {
        el.innerText = '기간 제한 없음';
        return;
    }
    
    const end = new Date(dateStr);
    const now = new Date();
    
    const diff = end - now;
    if(diff < 0) {
        el.innerText = '투표 종료';
        el.style.color = '#F04452';
    } else {
        const days = Math.ceil(diff / (1000 * 60 * 60 * 24));
        el.innerText = days + '일 남음';
        el.style.color = '#8A63FF';
    }
}

function initPoll() {
    const pollSection = document.getElementById('pollSection');
    if (!pollSection) return;

    const communityId = pollSection.dataset.pollId;

    fetch(`${contextPath}/api/community/poll?id=${communityId}`)
        .then(resp => resp.json())
        .then(data => {
            const box = document.getElementById('pollOptionsBox');
            const totalDisplay = document.getElementById('totalVotesDisplay');
            const submitBtn = document.getElementById('btnVoteSubmit');

            if (!data || !data.options || data.options.length === 0) {
                box.innerHTML = '<p style="color:var(--text-3);text-align:center;padding:16px;">투표 항목이 없습니다.</p>';
                return;
            }

            const total = data.totalVotes || 0;
            const realPollId = data.pollId; // 실제 poll_id
            totalDisplay.innerText = total + '명 참여';

            box.innerHTML = '';
            data.options.forEach(opt => {
                const pct = total > 0 ? Math.round((opt.voteCount / total) * 100) : 0;
                const div = document.createElement('div');
                div.className = 'poll-option-row';
                div.dataset.optionId = opt.optionId;
                div.innerHTML = `
                    <div class="poll-option-label">
                        <span class="option-text">${opt.content}</span>
                        <span class="option-pct">${pct}%</span>
                    </div>
                    <div class="poll-bar-track">
                        <div class="poll-bar-fill" style="width:${pct}%"></div>
                    </div>`;
                if (!data.voted) {
                    div.addEventListener('click', () => selectPollOption(div));
                }
                box.appendChild(div);
            });

            if (currentMemberIdx && !data.voted) {
                submitBtn.style.display = 'inline-block';
                submitBtn.onclick = () => submitVote(realPollId);
            } else if (data.voted) {
                submitBtn.style.display = 'none';
                totalDisplay.innerText = total + '명 참여 (투표 완료)';
            }
        })
        .catch(() => {
            const box = document.getElementById('pollOptionsBox');
            box.innerHTML = '<p style="color:var(--text-3);text-align:center;padding:16px;">투표를 불러올 수 없습니다.</p>';
        });
}

function selectPollOption(el) {
    document.querySelectorAll('.poll-option-row').forEach(row => row.classList.remove('selected'));
    el.classList.add('selected');
}

function submitVote(realPollId) {
    const selected = document.querySelector('.poll-option-row.selected');
    if (!selected) {
        showToast('투표 항목을 선택해주세요.');
        return;
    }
    const optionId = selected.dataset.optionId;
    fetch(`${contextPath}/api/community/poll/vote`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `pollId=${realPollId}&optionId=${optionId}`
    })
    .then(resp => resp.json())
    .then(data => {
        if (data.success) {
            showToast('투표가 완료되었습니다!');
            initPoll(); // 결과 다시 로드
        } else {
            showToast(data.message || '투표에 실패했습니다.');
        }
    })
    .catch(() => showToast('오류가 발생했습니다.'));
}

function toggleLike(id) {
    if(!currentMemberIdx) {
        alert('로그인이 필요합니다.');
        return;
    }

    fetch(`${contextPath}/community/like`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `id=${id}`
    })
    .then(resp => resp.json())
    .then(data => {
        const btn = document.getElementById('btnLike');
        const countSpan = document.getElementById('likeCount');
        const icon = btn.querySelector('i');
        
        if(data.liked) {
            btn.classList.add('active');
            icon.className = 'ri-heart-3-fill';
        } else {
            btn.classList.remove('active');
            icon.className = 'ri-heart-3-line';
        }
        countSpan.innerText = data.count;
    })
    .catch(err => console.error(err));
}

function toggleScrap(id) {
    if(!currentMemberIdx) {
        alert('로그인이 필요합니다.');
        return;
    }

    fetch(`${contextPath}/community/scrap`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `id=${id}`
    })
    .then(resp => resp.json())
    .then(data => {
        const btn = document.getElementById('btnScrap');
        const icon = btn.querySelector('i');
        
        if(data.scraped) {
            btn.classList.add('active');
            icon.className = 'ri-bookmark-fill';
            showToast('게시글을 스크랩했습니다.');
        } else {
            btn.classList.remove('active');
            icon.className = 'ri-bookmark-line';
            showToast('스크랩을 취소했습니다.');
        }
    });
}

function toggleMenu() {
    const menu = document.getElementById('dropdownMenu');
    if(menu) menu.classList.toggle('show');
}

document.addEventListener('click', (e) => {
    const wrapper = document.querySelector('.more-btn-wrapper');
    if (wrapper && !wrapper.contains(e.target)) {
        document.getElementById('dropdownMenu')?.classList.remove('show');
    }
});

function deleteArticle(id) {
    if(confirm('정말 삭제하시겠습니까?')) {
        const pageParam = currentPage ? currentPage : '1';
        location.href = `${contextPath}/community/delete?id=${id}&page=${pageParam}`;
    }
}

function showToast(msg) {
    const container = document.getElementById('toastContainer');
    const div = document.createElement('div');
    div.className = 'toast';
    div.innerHTML = `<i class="ri-notification-badge-fill"></i> ${msg}`;
    container.appendChild(div);
    setTimeout(() => div.remove(), 3000);
}

function sendReply(id) {
    const content = document.getElementById('replyContent').value;
    if(!content.trim()) {
        alert('내용을 입력해주세요.');
        return;
    }
    console.log("댓글 전송:", content);
    document.getElementById('replyContent').value = '';
}

function loadReplies() {
}