'use strict';

let _page = 1;
let _profileMemberIdx = '';
let _repliesLoaded = false;

function initUserProfileModal(memberIdx) {
    _profileMemberIdx = String(memberIdx);
    _page = 1;
    _repliesLoaded = false;

    const container = document.querySelector('.up-modal-wrap') || document;

    renderDates(container);
    animateStats(container);

    container.querySelectorAll('.up-tab').forEach(tab => {
        tab.addEventListener('click', function () {
            container.querySelectorAll('.up-tab').forEach(t => t.classList.remove('on'));
            container.querySelectorAll('.up-panel').forEach(p => p.classList.remove('on'));
            this.classList.add('on');

            const target = container.querySelector('#' + this.dataset.panel);
            if (target) target.classList.add('on');

            if (this.dataset.panel === 'panel-replies-modal' && !_repliesLoaded) {
                loadReplies(container);
                _repliesLoaded = true;
            }
        });
    });

    const moreBtn = container.querySelector('#moreBtn');
    if (moreBtn) {
        moreBtn.addEventListener('click', () => loadMorePosts(container));
    }
}

function renderDates(container) {
    const joinEl = container.querySelector('#profileJoinDate') || container.querySelector('#joinDate');
    if (joinEl?.dataset.date) {
        joinEl.textContent = fmtFull(joinEl.dataset.date);
    }

    container.querySelectorAll('[data-date]:not(#profileJoinDate):not(#joinDate)').forEach(el => {
        if (el.dataset.date) el.textContent = fmtRelative(el.dataset.date);
    });
}

function fmtFull(s) {
    if (!s) return '';
    const d = new Date(s);
    if (isNaN(d)) return s;
    const p = n => String(n).padStart(2, '0');
    return `${d.getFullYear()}.${p(d.getMonth() + 1)}.${p(d.getDate())}`;
}

function fmtRelative(s) {
    if (!s) return '';
    const d = new Date(s);
    if (isNaN(d)) return s;
    const sec = Math.floor((Date.now() - d) / 1000);
    if (sec < 60)     return '방금 전';
    if (sec < 3600)   return `${Math.floor(sec / 60)}분 전`;
    if (sec < 86400)  return `${Math.floor(sec / 3600)}시간 전`;
    if (sec < 604800) return `${Math.floor(sec / 86400)}일 전`;
    return fmtFull(s);
}

function animateStats(container) {
    container.querySelectorAll('[data-stat]').forEach(el => {
        const target = parseInt(el.dataset.stat, 10) || 0;
        if (!target) { el.textContent = '0'; return; }
        let t0 = null;
        (function tick(ts) {
            if (!t0) t0 = ts;
            const p = Math.min((ts - t0) / 900, 1);
            el.textContent = Math.round((1 - Math.pow(1 - p, 3)) * target).toLocaleString();
            if (p < 1) requestAnimationFrame(tick);
        })(performance.now());
    });
}

function loadReplies(container) {
    const box = container.querySelector('#replyList');
    if (!box) return;

    box.innerHTML = `<div class="up-loading">
        <div class="up-spinner"></div>
        <span>불러오는 중</span>
    </div>`;

    const basePath = typeof contextPath !== 'undefined' ? contextPath : '';

    fetch(`${basePath}/community/user/replies?memberIdx=${encodeURIComponent(_profileMemberIdx)}`)
        .then(r => {
            if (!r.ok) throw new Error('network');
            return r.json();
        })
        .then(data => {
            if (!data?.length) {
                box.innerHTML = emptyHTML('ri-chat-3-line', '아직 남긴 댓글이 없어요');
                return;
            }
            box.innerHTML = data.map(item => `
                <div class="up-row"
                     onclick="location.href='${basePath}/community/article/${esc(item.communityId)}'">
                    <div class="up-row-info">
                        <div class="up-origin">
                            <i class="ri-corner-up-right-line"></i>
                            <span>${esc(item.postTitle || '게시글')}</span>
                        </div>
                        <p class="up-row-title">${esc(item.content)}</p>
                        <div class="up-row-stats">
                            <span data-date="${esc(item.regDate)}"></span>
                        </div>
                    </div>
                </div>`).join('');

            /* 방금 추가된 날짜 요소 렌더링 */
            box.querySelectorAll('[data-date]').forEach(el => {
                el.textContent = fmtRelative(el.dataset.date);
            });
        })
        .catch(() => {
            box.innerHTML = emptyHTML('ri-error-warning-line', '댓글을 불러오지 못했어요');
        });
}

function loadMorePosts(container) {
    _page++;
    const btn = container.querySelector('#moreBtn');
    if (btn) { btn.disabled = true; btn.textContent = '불러오는 중...'; }

    const basePath = typeof contextPath !== 'undefined' ? contextPath : '';

    fetch(`${basePath}/community/user/posts?memberIdx=${encodeURIComponent(_profileMemberIdx)}&page=${_page}`)
        .then(r => {
            if (!r.ok) throw new Error('network');
            return r.json();
        })
        .then(data => {
            if (!data?.length) {
                const wrap = container.querySelector('#moreBtnWrap');
                if (wrap) wrap.remove();
                return;
            }
            const list = container.querySelector('#postList');
            if (!list) return;

            data.forEach(item => {
                const div = document.createElement('div');
                div.className = 'up-row';
                div.addEventListener('click', () => {
                    location.href = `${basePath}/community/article/${item.id}`;
                });
                div.innerHTML = `
                    <div class="up-row-info">
                        <span class="up-row-cat">${esc(item.category || '')}</span>
                        <p class="up-row-title">${esc(item.subject)}</p>
                        <div class="up-row-stats">
                            <span><i class="ri-eye-line"></i> ${item.hitCount}</span>
                            <span><i class="ri-heart-3-line"></i> ${item.likeCount}</span>
                            <span>${fmtRelative(item.regDate)}</span>
                        </div>
                    </div>`;
                list.appendChild(div);
            });

            if (btn) { btn.disabled = false; btn.textContent = '더 보기'; }
        })
        .catch(() => {
            if (btn) { btn.disabled = false; btn.textContent = '다시 시도'; }
        });
}

function emptyHTML(icon, msg) {
    return `<div class="up-empty">
        <i class="${icon}"></i>
        <p>${msg}</p>
    </div>`;
}

function esc(s) {
    return String(s ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}