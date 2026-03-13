'use strict';

let _page = 1;

document.addEventListener('DOMContentLoaded', () => {
    renderDates();
    animateStats();
    loadReplies();

    document.querySelectorAll('.up-tab').forEach(tab => {
        tab.addEventListener('click', function () {
            document.querySelectorAll('.up-tab').forEach(t => t.classList.remove('on'));
            document.querySelectorAll('.up-panel').forEach(p => p.classList.remove('on'));
            this.classList.add('on');
            const target = document.getElementById(this.dataset.panel);
            if (target) target.classList.add('on');
        });
    });
});

function renderDates() {
    const joinEl = document.getElementById('joinDate');
    if (joinEl?.dataset.date) {
        joinEl.textContent = fmtFull(joinEl.dataset.date);
    }
    document.querySelectorAll('[data-date]:not(#joinDate)').forEach(el => {
        el.textContent = fmtRelative(el.dataset.date);
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

function animateStats() {
    document.querySelectorAll('[data-stat]').forEach(el => {
        const target = parseInt(el.dataset.stat) || 0;
        if (!target) return;
        let t0 = null;
        (function tick(ts) {
            if (!t0) t0 = ts;
            const p = Math.min((ts - t0) / 900, 1);
            el.textContent = Math.round((1 - Math.pow(1 - p, 3)) * target).toLocaleString();
            if (p < 1) requestAnimationFrame(tick);
        })(performance.now());
    });
}

function loadReplies() {
    const box = document.getElementById('replyList');
    if (!box) return;

    fetch(`${contextPath}/community/user/replies?memberIdx=${profileMemberIdx}`)
        .then(r => r.json())
        .then(data => {
            if (!data?.length) {
                box.innerHTML = emptyHTML('ri-chat-3-line', '아직 남긴 댓글이 없어요');
                return;
            }
            box.innerHTML = data.map(item => `
                <div class="up-row"
                     onclick="location.href='${contextPath}/community/article/${esc(item.communityId)}'">
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

            box.querySelectorAll('[data-date]').forEach(el => {
                el.textContent = fmtRelative(el.dataset.date);
            });
        })
        .catch(() => {
            box.innerHTML = emptyHTML('ri-error-warning-line', '불러오지 못했어요');
        });
}

function loadMorePosts() {
    _page++;
    const btn = document.getElementById('moreBtn');
    if (btn) { btn.disabled = true; btn.textContent = '불러오는 중...'; }

    fetch(`${contextPath}/community/user/posts?memberIdx=${profileMemberIdx}&page=${_page}`)
        .then(r => r.json())
        .then(data => {
            if (!data?.length) {
                document.getElementById('moreBtnWrap')?.remove();
                return;
            }
            const list = document.getElementById('postList');
            data.forEach(item => {
                const div = document.createElement('div');
                div.className = 'up-row';
                div.onclick = () => location.href = `${contextPath}/community/article/${item.id}`;
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
            if (btn) { btn.disabled = false; btn.textContent = '더 보기'; }
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