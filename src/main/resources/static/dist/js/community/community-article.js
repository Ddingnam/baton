function batonConfirm(message, onConfirm, onCancel) {
	var overlay = document.createElement('div');
	overlay.className = 'baton-modal-overlay';
	overlay.innerHTML =
		'<div class="baton-modal-box">' +
			'<p class="baton-modal-msg">' + message + '</p>' +
			'<div class="baton-modal-btns">' +
				'<button id="batonConfirmCancel" class="baton-btn-cancel">취소</button>' +
				'<button id="batonConfirmOk" class="baton-btn-ok">확인</button>' +
			'</div>' +
		'</div>';
	document.body.appendChild(overlay);
	requestAnimationFrame(function() { overlay.classList.add('show'); });
	var close = function() {
		overlay.classList.remove('show');
		setTimeout(function() { if (overlay.parentNode) document.body.removeChild(overlay); }, 220);
	};
	overlay.querySelector('#batonConfirmOk').onclick = function() { close(); if (onConfirm) onConfirm(); };
	overlay.querySelector('#batonConfirmCancel').onclick = function() { close(); if (onCancel) onCancel(); };
	overlay.onclick = function(e) { if (e.target === overlay) { close(); if (onCancel) onCancel(); } };
}

document.addEventListener('DOMContentLoaded', () => {
    try {
        initMap();
    } catch (e) {
        console.error("Map initialization failed:", e);
    }

    initPoll();
    loadArticleReplies();
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
        map.setDraggable(true);
        map.setZoomable(true);

        let dragStartX, dragStartY;
        mapContainer.addEventListener('mousedown', e => {
            dragStartX = e.clientX;
            dragStartY = e.clientY;
        });

        kakao.maps.event.addListener(map, 'click', (mouseEvent) => {
            const dx = Math.abs((window.event?.clientX || dragStartX) - dragStartX);
            const dy = Math.abs((window.event?.clientY || dragStartY) - dragStartY);
            if (dx > 5 || dy > 5) return;
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
    var pollSection = document.getElementById('pollSection');
    if (!pollSection) return;

    var pollCommunityId = pollSection.dataset.pollId;
    var box = document.getElementById('pollOptionsBox');

    fetch(contextPath + '/api/community/poll?id=' + pollCommunityId)
        .then(function(resp) {
            if (!resp.ok) throw new Error('HTTP ' + resp.status);
            return resp.json();
        })
        .then(function(data) {
            var totalDisplay = document.getElementById('totalVotesDisplay');
            var submitBtn    = document.getElementById('btnVoteSubmit');

            if (!data || data.error || !data.options || data.options.length === 0) {
                box.innerHTML = '<p style="color:var(--text-3);text-align:center;padding:20px 16px;font-size:13px;">투표 항목이 없습니다.</p>';
                return;
            }

            var total       = data.totalVotes || 0;
            var realPollId  = data.pollId;
            var isMultiple  = data.multiple;
            var myOptionIds = data.myOptionIds || [];
            var isLoggedIn  = parseInt(currentMemberIdx, 10) > 0;

            totalDisplay.innerText = total + '명 참여';
            box.innerHTML = '';

            data.options.forEach(function(opt) {
                var pct      = total > 0 ? Math.round((opt.voteCount / total) * 100) : 0;
                var isMyVote = myOptionIds.indexOf(opt.optionId) !== -1;
                var div      = document.createElement('div');
                div.className = 'poll-option-row' + (isMyVote ? ' selected' : '');
                div.dataset.optionId = opt.optionId;

                var checkIcon = isMultiple
                    ? (isMyVote ? 'ri-checkbox-fill' : 'ri-checkbox-blank-line')
                    : (isMyVote ? 'ri-radio-button-fill' : 'ri-radio-button-line');

                div.innerHTML =
                    '<div class="poll-option-label">' +
                        '<span class="poll-option-check"><i class="' + checkIcon + '"></i></span>' +
                        '<span class="option-text">' + escapeHtml(opt.content) + '</span>' +
                        '<span class="option-pct">' + pct + '%</span>' +
                    '</div>' +
                    '<div class="poll-bar-track">' +
                        '<div class="poll-bar-fill" style="width:' + pct + '%"></div>' +
                    '</div>';

                if (isLoggedIn) {
                    (function(el, multiple) {
                        el.addEventListener('click', function() { selectPollOption(el, multiple); });
                    })(div, isMultiple);
                }
                box.appendChild(div);
            });

            if (isLoggedIn) {
                submitBtn.style.display = 'inline-block';
                submitBtn.textContent   = data.voted ? '투표 변경' : '투표하기';
                submitBtn.onclick       = null;

                // 마감일 체크
                var endDateEl = document.getElementById('pollEndDate');
                var endDateStr = endDateEl ? endDateEl.dataset.date : null;
                var isExpired = endDateStr && new Date(endDateStr) < new Date();

                if (isExpired) {
                    submitBtn.disabled = true;
                    submitBtn.textContent = '투표 마감';
                    submitBtn.style.opacity = '0.5';
                    submitBtn.style.cursor = 'not-allowed';
                    var cancelBtn = document.getElementById('btnVoteCancel');
                    if (cancelBtn) cancelBtn.style.display = 'none';
                } else {
                    submitBtn.disabled = false;
                    submitBtn.style.opacity = '';
                    submitBtn.style.cursor = '';
                    submitBtn.onclick = function() { submitVote(realPollId); };

                    var cancelBtn = document.getElementById('btnVoteCancel');
                    if (cancelBtn) {
                        if (data.voted) {
                            cancelBtn.style.display = 'inline-block';
                            cancelBtn.onclick = null;
                            cancelBtn.onclick = function() { cancelVote(realPollId); };
                        } else {
                            cancelBtn.style.display = 'none';
                        }
                    }
                }
            } else {
                submitBtn.style.display = 'none';
            }

            if (data.voted) {
                totalDisplay.innerText = total + '명 참여 · 내 선택 표시됨';
            }
        })
        .catch(function(err) {
            console.error('투표 로드 실패:', err);
            if (box) box.innerHTML = '<p style="color:var(--text-3);text-align:center;padding:20px 16px;font-size:13px;">투표를 불러올 수 없습니다.</p>';
        });
}


function selectPollOption(el, isMultiple) {
    if (isMultiple) {
        var wasSelected = el.classList.contains('selected');
        el.classList.toggle('selected');
        var icon = el.querySelector('.poll-option-check i');
        if (icon) icon.className = wasSelected ? 'ri-checkbox-blank-line' : 'ri-checkbox-fill';
    } else {
        var wasSelected = el.classList.contains('selected');
        document.querySelectorAll('.poll-option-row').forEach(function(row) {
            row.classList.remove('selected');
            var icon = row.querySelector('.poll-option-check i');
            if (icon) icon.className = 'ri-radio-button-line';
        });
        if (!wasSelected) {
            el.classList.add('selected');
            var icon = el.querySelector('.poll-option-check i');
            if (icon) icon.className = 'ri-radio-button-fill';
        }
    }
}




function submitVote(realPollId) {
    const selected = document.querySelectorAll('.poll-option-row.selected');
    if (selected.length === 0) {
        showBatonToast('투표 항목을 선택해주세요.');
        return;
    }

    const submitBtn = document.getElementById('btnVoteSubmit');
    const isChange = submitBtn && submitBtn.textContent.trim() === '투표 변경';
    const confirmMsg = isChange
        ? '투표를 변경하시겠습니까?<br><span style="font-size:13px;color:var(--text-3);font-weight:400;">이전 투표는 취소되고 새로 반영돼요.</span>'
        : '투표하시겠습니까?';

    batonConfirm(confirmMsg, function() {
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
                showBatonToast(isChange ? '투표가 변경되었습니다!' : '투표가 완료되었습니다!');
                initPoll();
            } else {
                showBatonToast(data.message || '투표에 실패했습니다.');
            }
        })
        .catch(() => showBatonToast('오류가 발생했습니다.'));
    });
}

function cancelVote(realPollId) {
    batonConfirm('투표를 취소하시겠습니까?', function() {
        var params = new URLSearchParams();
        params.append('pollId', realPollId);
        fetch(contextPath + '/api/community/poll/cancel', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(function(resp) { return resp.json(); })
        .then(function(data) {
            if (data.success) {
                showBatonToast('투표가 취소되었습니다.');
                initPoll();
            } else {
                showBatonToast(data.message || '투표 취소에 실패했습니다.');
            }
        })
        .catch(function() { showBatonToast('오류가 발생했습니다.'); });
    });
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
        if (data.scraped) { btn.classList.add('active');    icon.className = 'ri-bookmark-fill';  showBatonToast('게시글을 스크랩했습니다.'); }
        else               { btn.classList.remove('active'); icon.className = 'ri-bookmark-line';  showBatonToast('스크랩을 취소했습니다.'); }
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
        .then(resp => {
            if (!resp.ok) throw new Error('network');
            return resp.json();
        })
        .then(data => {
            const votes = (data && typeof data.totalVotes === 'number') ? data.totalVotes : 0;
            if (votes > 0) {
                showBatonToast('투표에 참여한 이웃이 있어 수정할 수 없어요 🔒');
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

function loadArticleReplies() {
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
                        <span class="reply-nickname" style="cursor: pointer;" onclick="openProfileModal('${reply.memberIdx}')">${escapeHtml(reply.writerNickname)}</span>
                        <span class="reply-date">${formatDate(reply.regDate)}</span>
                    </div>
                </div>
                <div class="reply-actions">
                    <button type="button" class="btn-reply-re" onclick="openReplyBox(${reply.id})">답글</button>
                    ${isMyReply
                        ? `<button type="button" class="btn-reply-del" onclick="deleteReply(${reply.id})">삭제</button>`
                        : `<button type="button" class="btn-reply-report" onclick="openReportModal('COMMUNITY_REPLY', ${reply.id}, ${reply.memberIdx})" title="신고"><i class="ri-alarm-warning-line"></i></button>`
                    }
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
    if (!content) { showBatonToast('내용을 입력해주세요.'); return; }

    fetch(`${contextPath}/community/reply/write`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `communityId=${communityId}&content=${encodeURIComponent(content)}`
    })
    .then(resp => resp.json())
    .then(data => {
        if (data.state === 'true') {
            document.getElementById('replyContent').value = '';
            loadArticleReplies();
        } else {
            showBatonToast('댓글 등록에 실패했습니다.');
        }
    })
    .catch(() => showBatonToast('오류가 발생했습니다.'));
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
    if (!content) { showBatonToast('내용을 입력해주세요.'); return; }

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
            loadArticleReplies();
        } else {
            showBatonToast('답글 등록에 실패했습니다.');
        }
    })
    .catch(() => showBatonToast('오류가 발생했습니다.'));
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
                loadArticleReplies();
            } else {
                showBatonToast('삭제에 실패했습니다.');
            }
        })
        .catch(() => showBatonToast('오류가 발생했습니다.'));
    });
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