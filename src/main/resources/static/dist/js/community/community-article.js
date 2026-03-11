function batonConfirm(message, onConfirm, onCancel) {
	const overlay = document.createElement('div');
	overlay.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.45);z-index:999999;display:flex;align-items:center;justify-content:center;';
	overlay.innerHTML = `
		<div style="background:#fff;border-radius:20px;padding:28px 32px;min-width:300px;max-width:400px;box-shadow:0 10px 40px rgba(0,0,0,0.15);text-align:center;">
			<p style="font-size:15px;font-weight:600;color:#191F28;margin:0 0 24px;line-height:1.6;">${message}</p>
			<div style="display:flex;gap:10px;justify-content:center;">
				<button id="batonConfirmCancel" style="flex:1;padding:12px;border:1px solid #E5E8EB;background:#fff;border-radius:12px;font-size:14px;font-weight:600;color:#4E5968;cursor:pointer;">취소</button>
				<button id="batonConfirmOk" style="flex:1;padding:12px;border:none;background:#8A63FF;border-radius:12px;font-size:14px;font-weight:600;color:#fff;cursor:pointer;">확인</button>
			</div>
		</div>`;
	document.body.appendChild(overlay);
	const close = () => document.body.removeChild(overlay);
	overlay.querySelector('#batonConfirmOk').onclick = () => { close(); if (onConfirm) onConfirm(); };
	overlay.querySelector('#batonConfirmCancel').onclick = () => { close(); if (onCancel) onCancel(); };
	overlay.onclick = (e) => { if (e.target === overlay) { close(); if (onCancel) onCancel(); } };
}

document.addEventListener('DOMContentLoaded', () => {
    try {
        initMap();
    } catch (e) {
        console.error("Map initialization failed:", e);
    }

    initPoll();
    loadReplies();
    formatPollDate();
    formatArticleDate();
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
        map.setZoomable(true);

        mapContainer.style.cursor = 'pointer';
        kakao.maps.event.addListener(map, 'click', () => {
            const placeName = mapContainer.closest('.map-card').querySelector('strong')?.innerText || '';
            window.open(`https://map.kakao.com/link/map/${encodeURIComponent(placeName)},${lat},${lng}`, '_blank');
        });
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

function formatArticleDate() {
    const el = document.getElementById('articleRegDate');
    if (!el) return;
    const dateStr = el.dataset.date;
    if (!dateStr) return;
    el.innerText = formatDate(dateStr);
}

function initPoll() {
    const pollSection = document.getElementById('pollSection');
    if (!pollSection) return;

    const pollCommunityId = pollSection.dataset.pollId;

    fetch(`${contextPath}/api/community/poll?id=${pollCommunityId}`)
        .then(resp => resp.json())
        .then(data => {
            const box          = document.getElementById('pollOptionsBox');
            const totalDisplay = document.getElementById('totalVotesDisplay');
            const submitBtn    = document.getElementById('btnVoteSubmit');

            if (!data || !data.options || data.options.length === 0) {
                box.innerHTML = '<p style="color:var(--text-3);text-align:center;padding:16px;">투표 항목이 없습니다.</p>';
                return;
            }

            const total      = data.totalVotes || 0;
            const realPollId = data.pollId;
            const isMultiple = data.multiple;
            const myOptionIds = data.myOptionIds || [];

            totalDisplay.innerText = total + '명 참여';

            box.innerHTML = '';
            data.options.forEach(opt => {
                const pct       = total > 0 ? Math.round((opt.voteCount / total) * 100) : 0;
                const isMyVote  = myOptionIds.includes(opt.optionId);
                const div       = document.createElement('div');
                div.className   = 'poll-option-row' + (isMyVote ? ' selected' : '');
                div.dataset.optionId = opt.optionId;
                div.innerHTML = `
                    <div class="poll-option-label">
                        <span class="poll-option-check"><i class="${isMultiple
                            ? (isMyVote ? 'ri-checkbox-fill' : 'ri-checkbox-blank-line')
                            : (isMyVote ? 'ri-radio-button-fill' : 'ri-radio-button-line')}"></i></span>
                        <span class="option-text">${opt.content}</span>
                        <span class="option-pct">${pct}%</span>
                    </div>
                    <div class="poll-bar-track">
                        <div class="poll-bar-fill" style="width:${pct}%"></div>
                    </div>`;

                const isLoggedIn = parseInt(currentMemberIdx, 10) > 0;
                if (isLoggedIn) {
                    div.addEventListener('click', () => selectPollOption(div, isMultiple));
                }
                box.appendChild(div);
            });

            const isLoggedIn = parseInt(currentMemberIdx, 10) > 0;
            if (isLoggedIn) {
                submitBtn.style.display = 'inline-block';
                submitBtn.textContent   = data.voted ? '투표 변경' : '투표하기';
                submitBtn.onclick       = () => submitVote(realPollId);
            } else {
                submitBtn.style.display = 'none';
                if (!data.voted) totalDisplay.innerText = total + '명 참여 (로그인 후 투표 가능)';
            }

            if (data.voted) {
                totalDisplay.innerText = total + '명 참여 · 내 선택 표시됨';
            }
        })
        .catch(() => {
            const box = document.getElementById('pollOptionsBox');
            box.innerHTML = '<p style="color:var(--text-3);text-align:center;padding:16px;">투표를 불러올 수 없습니다.</p>';
        });
}

function selectPollOption(el, isMultiple) {
    if (isMultiple) {
        el.classList.toggle('selected');
        const icon = el.querySelector('.poll-option-check i');
        if (icon) {
            icon.className = el.classList.contains('selected')
                ? 'ri-checkbox-fill'
                : 'ri-checkbox-blank-line';
        }
    } else {
        document.querySelectorAll('.poll-option-row').forEach(row => {
            row.classList.remove('selected');
            const icon = row.querySelector('.poll-option-check i');
            if (icon) icon.className = 'ri-radio-button-line';
        });
        el.classList.add('selected');
        const icon = el.querySelector('.poll-option-check i');
        if (icon) icon.className = 'ri-radio-button-fill';
    }
}

function submitVote(realPollId) {
    const selected = document.querySelectorAll('.poll-option-row.selected');
    if (selected.length === 0) {
        showToast('투표 항목을 선택해주세요.');
        return;
    }
    const optionIds = Array.from(selected).map(el => el.dataset.optionId);
    const params = new URLSearchParams();
    params.append('pollId', realPollId);
    optionIds.forEach(id => params.append('optionIds', id));

    fetch(`${contextPath}/api/community/poll/vote`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
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

function checkAndEdit(id, page) {
    const pollSection = document.getElementById('pollSection');

    if (!pollSection) {
        location.href = `${contextPath}/community/update?id=${id}&page=${page}`;
        return;
    }

    fetch(`${contextPath}/api/community/poll?id=${id}`)
        .then(resp => resp.json())
        .then(data => {
            if (data && data.totalVotes > 0) {
                showBatonToast('투표에 참여한 이웃이 있어 수정할 수 없어요.');
            } else {
                location.href = `${contextPath}/community/update?id=${id}&page=${page}`;
            }
        })
        .catch(() => {
            location.href = `${contextPath}/community/update?id=${id}&page=${page}`;
        });
}

function deleteArticle(id) {
    batonConfirm('정말 삭제하시겠습니까?', () => {
        const pageParam = currentPage ? currentPage : '1';
        location.href = `${contextPath}/community/delete?id=${id}&page=${pageParam}`;
    });
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
    batonConfirm('댓글을 삭제하시겠습니까?', () => {
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
    });
}
function escapeHtml(text) {
    if (!text) return '';
    return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function showToast(message) {
    const container = document.getElementById('toastContainer');
    if (!container) return;
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = `<i class="ri-checkbox-circle-line"></i> ${message}`;
    container.appendChild(toast);
    setTimeout(() => {
        toast.style.animation = 'fadeUp 0.3s reverse forwards';
        setTimeout(() => toast.remove(), 300);
    }, 2500);
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