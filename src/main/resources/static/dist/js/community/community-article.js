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
        
        // 지도 확대/축소 및 드래그 막기 (필요시 제거)
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
        // [수정] page 파라미터가 없으면 1로 설정
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