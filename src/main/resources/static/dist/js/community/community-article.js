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
        const options = { center: new kakao.maps.LatLng(lat, lng), level: 3 };
        const map = new kakao.maps.Map(mapContainer, options);
        const marker = new kakao.maps.Marker({ position: new kakao.maps.LatLng(lat, lng) });
        marker.setMap(map);
        map.setDraggable(false);
        map.setZoomable(false);
    });
}

function formatPollDate() {
    const el = document.getElementById('pollEndDate');
    if (!el) return;

    const dateStr = el.dataset.date;
    if (!dateStr) {
        el.innerText = '기간 제한 없음';
        return;
    }

    const end = new Date(dateStr);
    const diff = end - new Date();
    if (diff < 0) {
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

    const pollCommunityId = pollSection.dataset.pollId;

    fetch(`${contextPath}/api/community/poll?id=${pollCommunityId}`)
        .then(resp => resp.json())
        .then(data => {
            const box         = document.getElementById('pollOptionsBox');
            const totalDisplay = document.getElementById('totalVotesDisplay');
            const submitBtn   = document.getElementById('btnVoteSubmit');

            if (!data || !data.options || data.options.length === 0) {
                box.innerHTML = '<p style="color:var(--text-3);text-align:center;padding:16px;">투표 항목이 없습니다.</p>';
                return;
            }

            const total     = data.totalVotes || 0;
            const realPollId = data.pollId;
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

            const isLoggedIn = parseInt(currentMemberIdx, 10) > 0;
            if (isLoggedIn && !data.voted) {
                submitBtn.style.display = 'inline-block';
                submitBtn.onclick = () => submitVote(realPollId);
            } else if (data.voted) {
                submitBtn.style.display = 'none';
                totalDisplay.innerText = total + '명 참여 (투표 완료)';
            } else {
                submitBtn.style.display = 'none'; // 비로그인
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
            initPoll();
        } else {
            showToast(data.message || '투표에 실패했습니다.');
        }
    })
    .catch(() => showToast('오류가 발생했습니다.'));
}

function toggleLike(id) {
    if (!parseInt(currentMemberIdx, 10)) { alert('로그인이 필요합니다.'); return; }
    fetch(`${contextPath}/community/like`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `id=${id}`
    })
    .then(resp => resp.json())
    .then(data => {
        const btn = document.getElementById('btnLike');
        const icon = btn.querySelector('i');
        if (data.liked) { btn.classList.add('active');    icon.className = 'ri-heart-3-fill'; }
        else             { btn.classList.remove('active'); icon.className = 'ri-heart-3-line'; }
        document.getElementById('likeCount').innerText = data.count;
    })
    .catch(err => console.error(err));
}

function toggleScrap(id) {
    if (!parseInt(currentMemberIdx, 10)) { alert('로그인이 필요합니다.'); return; }
    fetch(`${contextPath}/community/scrap`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `id=${id}`
    })
    .then(resp => resp.json())
    .then(data => {
        const btn  = document.getElementById('btnScrap');
        const icon = btn.querySelector('i');
        if (data.scraped) { btn.classList.add('active');    icon.className = 'ri-bookmark-fill';  showToast('게시글을 스크랩했습니다.'); }
        else               { btn.classList.remove('active'); icon.className = 'ri-bookmark-line';  showToast('스크랩을 취소했습니다.'); }
    });
}

function toggleMenu() {
    const menu = document.getElementById('dropdownMenu');
    if (menu) menu.classList.toggle('show');
}

document.addEventListener('click', (e) => {
    const wrapper = document.querySelector('.more-btn-wrapper');
    if (wrapper && !wrapper.contains(e.target)) {
        document.getElementById('dropdownMenu')?.classList.remove('show');
    }
});

function deleteArticle(id) {
    if (confirm('정말 삭제하시겠습니까?')) {
        const pageParam = currentPage ? currentPage : '1';
        location.href = `${contextPath}/community/delete?id=${id}&page=${pageParam}`;
    }
}

function loadReplies() {
    fetch(`${contextPath}/community/reply/list?communityId=${communityId}`)
        .then(resp => resp.json())
        .then(data => {
            document.getElementById('replyCount').innerText = data.count || 0;
            renderReplies(data.list || []);
        })
        .catch(err => console.error('댓글 로드 실패:', err));
}

function renderReplies(list) {
    const container = document.getElementById('replyList');
    if (!list || list.length === 0) {
        container.innerHTML = '<p class="no-reply">아직 댓글이 없습니다. 첫 댓글을 남겨보세요!</p>';
        return;
    }

    container.innerHTML = list.map(reply => {
        const isMyReply = parseInt(currentMemberIdx, 10) === reply.memberIdx;
        const indentStyle = reply.depth > 0 ? `style="margin-left:${reply.depth * 24}px;"` : '';
        const depthIcon   = reply.depth > 0 ? '<i class="ri-corner-down-right-line" style="color:var(--text-3);margin-right:4px;"></i>' : '';

        if (reply.isDeleted) {
            return `
            <div class="reply-item deleted" ${indentStyle}>
                ${depthIcon}
                <span class="reply-deleted-text">삭제된 댓글입니다.</span>
            </div>`;
        }

        return `
        <div class="reply-item" data-id="${reply.id}" ${indentStyle}>
            <div class="reply-header">
                <div class="reply-profile">
                    <img src="${contextPath}/dist/images/avatar.png" alt="프로필" class="reply-avatar">
                    <div>
                        <span class="reply-nickname">${escapeHtml(reply.writerNickname)}</span>
                        <span class="reply-date">${formatDate(reply.regDate)}</span>
                    </div>
                </div>
                <div class="reply-actions">
                    <button type="button" class="btn-reply-re" onclick="openReplyBox(${reply.id})">답글</button>
                    ${isMyReply ? `<button type="button" class="btn-reply-del" onclick="deleteReply(${reply.id})">삭제</button>` : ''}
                </div>
            </div>
            <div class="reply-content">${escapeHtml(reply.content)}</div>
            <div class="reply-sub-input" id="replyBox_${reply.id}" style="display:none;">
                <textarea class="input-reply sub" placeholder="답글을 입력하세요..."></textarea>
                <div style="display:flex;gap:8px;margin-top:6px;">
                    <button type="button" class="btn-reply-submit" onclick="sendSubReply(${reply.id})">등록</button>
                    <button type="button" class="btn-reply-cancel" onclick="closeReplyBox(${reply.id})">취소</button>
                </div>
            </div>
        </div>`;
    }).join('');
}

function sendReply(id) {
    if (!parseInt(currentMemberIdx, 10)) { alert('로그인이 필요합니다.'); return; }

    const content = document.getElementById('replyContent').value.trim();
    if (!content) { showToast('내용을 입력해주세요.'); return; }

    fetch(`${contextPath}/community/reply/write`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `communityId=${communityId}&content=${encodeURIComponent(content)}`
    })
    .then(resp => resp.json())
    .then(data => {
        if (data.state === 'true') {
            document.getElementById('replyContent').value = '';
            loadReplies();
        } else {
            showToast('댓글 등록에 실패했습니다.');
        }
    })
    .catch(() => showToast('오류가 발생했습니다.'));
}

function openReplyBox(parentId) {
    document.querySelectorAll('.reply-sub-input').forEach(el => el.style.display = 'none');
    const box = document.getElementById(`replyBox_${parentId}`);
    if (box) box.style.display = 'block';
}

function closeReplyBox(parentId) {
    const box = document.getElementById(`replyBox_${parentId}`);
    if (box) box.style.display = 'none';
}

function sendSubReply(parentId) {
    if (!parseInt(currentMemberIdx, 10)) { alert('로그인이 필요합니다.'); return; }

    const box = document.getElementById(`replyBox_${parentId}`);
    const textarea = box.querySelector('textarea');
    const content = textarea.value.trim();
    if (!content) { showToast('내용을 입력해주세요.'); return; }

    fetch(`${contextPath}/community/reply/write`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `communityId=${communityId}&content=${encodeURIComponent(content)}&parentId=${parentId}`
    })
    .then(resp => resp.json())
    .then(data => {
        if (data.state === 'true') {
            textarea.value = '';
            closeReplyBox(parentId);
            loadReplies();
        } else {
            showToast('답글 등록에 실패했습니다.');
        }
    })
    .catch(() => showToast('오류가 발생했습니다.'));
}

function deleteReply(replyId) {
    if (!confirm('댓글을 삭제하시겠습니까?')) return;
    fetch(`${contextPath}/community/reply/delete`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `id=${replyId}`
    })
    .then(resp => resp.json())
    .then(data => {
        if (data.state === 'true') {
            loadReplies();
        } else {
            showToast('삭제에 실패했습니다.');
        }
    })
    .catch(() => showToast('오류가 발생했습니다.'));
}

function showToast(msg) {
    const container = document.getElementById('toastContainer');
    const div = document.createElement('div');
    div.className = 'toast';
    div.innerHTML = `<i class="ri-notification-badge-fill"></i> ${msg}`;
    container.appendChild(div);
    setTimeout(() => div.remove(), 3000);
}

function escapeHtml(text) {
    if (!text) return '';
    return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function formatDate(dateStr) {
    if (!dateStr) return '';
    const d = new Date(dateStr);
    const now = new Date();
    const diff = now - d;
    if (diff < 60000)        return '방금 전';
    if (diff < 3600000)      return Math.floor(diff / 60000) + '분 전';
    if (diff < 86400000)     return Math.floor(diff / 3600000) + '시간 전';
    if (diff < 86400000 * 7) return Math.floor(diff / 86400000) + '일 전';
    return d.toLocaleDateString('ko-KR');
}