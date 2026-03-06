document.addEventListener('DOMContentLoaded', () => {
    initMap();
    initPoll();
    loadReplies();
    formatPollDate();
});

function initMap() {
    const mapContainer = document.getElementById('map');
    if (!mapContainer) return;

    const lat = mapContainer.dataset.lat;
    const lng = mapContainer.dataset.lng;

    const options = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 3
    };

    const map = new kakao.maps.Map(mapContainer, options);
    
    // 마커 표시
    const markerPosition  = new kakao.maps.LatLng(lat, lng); 
    const marker = new kakao.maps.Marker({
        position: markerPosition
    });
    marker.setMap(map);
    
    map.setDraggable(false);
    map.setZoomable(false);
}

let pollData = null;

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

    fetch(`${contextPath}/api/community/${id}/like`, {
        method: 'POST'
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

    fetch(`${contextPath}/api/community/${id}/scrap`, {
        method: 'POST'
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
    menu.classList.toggle('show');
}

document.addEventListener('click', (e) => {
    const wrapper = document.querySelector('.more-btn-wrapper');
    if (wrapper && !wrapper.contains(e.target)) {
        document.getElementById('dropdownMenu').classList.remove('show');
    }
});

function deleteArticle(id) {
    if(confirm('정말 삭제하시겠습니까?')) {
        location.href = `${contextPath}/community/delete?id=${id}`;
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