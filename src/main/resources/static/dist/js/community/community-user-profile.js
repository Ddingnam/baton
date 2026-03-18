'use strict';

let _page = 1;
let _profileMemberIdx = '';
let _repliesLoaded = false;
let _postsLoading = false;
let _postsEnd = false;

function initUserProfileModal(memberIdx) {
    _profileMemberIdx = String(memberIdx);
    _page = 1;
    _repliesLoaded = false;
    _postsLoading = false;
    _postsEnd = false;

    const container = document.querySelector('.upm-wrap') || document;

    renderDates(container);
    animateStats(container);

    container.querySelectorAll('.upm-tab').forEach(tab => {
        tab.addEventListener('click', function () {
            container.querySelectorAll('.upm-tab').forEach(t => t.classList.remove('on'));
            container.querySelectorAll('.upm-panel').forEach(p => p.classList.remove('on'));
            this.classList.add('on');

            const target = container.querySelector('#' + this.dataset.panel);
            if (target) target.classList.add('on');

            if (this.dataset.panel === 'panel-replies-modal' && !_repliesLoaded) {
                loadReplies(container);
                _repliesLoaded = true;
            }
        });
    });

    const scrollEl = document.querySelector('#profileModal .modal-content');
    if (scrollEl) {
        scrollEl._infiniteHandler && scrollEl.removeEventListener('scroll', scrollEl._infiniteHandler);
        scrollEl._infiniteHandler = function () {
            const postPanel = container.querySelector('#panel-posts-modal');
            if (!postPanel || !postPanel.classList.contains('on')) return;
            if (_postsLoading || _postsEnd) return;
            const threshold = 100;
            if (this.scrollTop + this.clientHeight >= this.scrollHeight - threshold) {
                loadMorePosts(container);
            }
        };
        scrollEl.addEventListener('scroll', scrollEl._infiniteHandler);
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

    box.innerHTML = `<div class="upm-loading">
        <div class="upm-spinner"></div>
        <span>불러오는 중</span>
    </div>`;

    const basePath = typeof contextPath !== 'undefined' ? contextPath : '';

    fetch(`${basePath}/community/user/replies?memberIdx=${encodeURIComponent(_profileMemberIdx)}`, { credentials: 'same-origin' })
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
                <div class="upm-row"
                     onclick="location.href='${basePath}/community/article/${esc(item.communityId)}'">
                    <div class="upm-row-info">
                        <div class="upm-origin">
                            <i class="ri-corner-up-right-line"></i>
                            <span>${esc(item.postTitle || '게시글')}</span>
                        </div>
                        <p class="upm-row-title">${esc(item.content)}</p>
                        <div class="upm-row-meta">
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
    if (_postsLoading || _postsEnd) return;
    _postsLoading = true;
    _page++;

    const basePath = typeof contextPath !== 'undefined' ? contextPath : '';
    const list = container.querySelector('#postList');

    const spinner = document.createElement('div');
    spinner.className = 'upm-loading upm-scroll-spinner';
    spinner.innerHTML = '<div class="up-spinner"></div>';
    if (list) list.appendChild(spinner);

    fetch(`${basePath}/community/user/posts?memberIdx=${encodeURIComponent(_profileMemberIdx)}&page=${_page}`, {
        credentials: 'same-origin'
    })
        .then(r => {
            if (!r.ok) throw new Error('network');
            return r.json();
        })
        .then(data => {
            spinner.remove();
            if (!data?.length) {
                _postsEnd = true;
                return;
            }
            if (!list) return;

            data.forEach(item => {
                const div = document.createElement('div');
                div.className = 'upm-row';
                div.addEventListener('click', () => {
                    location.href = `${basePath}/community/article/${item.id}`;
                });
                div.innerHTML = `
                    <div class="upm-row-info">
                        <span class="upm-cat">${catLabel(item.category)}</span>
                        <p class="upm-row-title">${esc(item.subject)}</p>
                        <div class="upm-row-meta">
                            <span><i class="ri-eye-line"></i> ${item.hitCount}</span>
                            <span><i class="ri-heart-3-line"></i> ${item.likeCount}</span>
                            <span>${fmtRelative(item.regDate)}</span>
                        </div>
                    </div>`;
                list.appendChild(div);
            });
        })
        .catch(() => {
            spinner.remove();
            _page--;
        })
        .finally(() => {
            _postsLoading = false;
        });
}

function emptyHTML(icon, msg) {
    return `<div class="upm-empty">
        <i class="${icon}"></i>
        <p>${msg}</p>
    </div>`;
}

function catLabel(c) {
    const map = {
        '1': '일상', '2': '동네질문', '3': '동네맛집',
        '4': '같이해요', '5': '분실/실종', '6': '동네사건사고',
        '7': '생활정보', '8': '취미생활'
    };
    return map[String(c)] || esc(c || '');
}

function esc(s) {
    return String(s ?? '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}