const Gallery = (function () {
    function selectThumb(idx) {
        const indicators = document.querySelectorAll('.indicator-dot');
        indicators.forEach((el, i) => {
            el.classList.toggle('active', i === idx);
        });
    }
    return { selectThumb };
})();

const WishModule = (function () {
    let wished = false;
    let albaIdx = 0;

    function init(initialWished, idx) {
        wished = initialWished;
        albaIdx = idx;
        updateUI();
    }

    function toggle() {
        fetch('/alba/wish', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ albaIdx: albaIdx })
        })
        .then(res => {
            if (res.status === 401) { Toast.show('로그인이 필요합니다.'); return null; }
            return res.json();
        })
        .then(data => {
            if (!data) return;
            wished = data.wished;
            updateUI();
            Toast.show(wished ? '관심 알바에 담았습니다.' : '관심 알바에서 제외했습니다.');
        })
        .catch(() => Toast.show('오류가 발생했습니다.'));
    }

    function updateUI() {
        const btn = document.getElementById('wishBtnLarge');
        if (btn) {
            btn.classList.toggle('active', wished);
            btn.innerHTML = wished ? '<i class="ri-heart-3-fill"></i>' : '<i class="ri-heart-3-line"></i>';
        }
    }

    return { init, toggle };
})();

const StatusModule = (function () {
    const getModal = () => document.getElementById('statusModal');

    function open() {
        const modal = getModal();
        if (modal) {
            modal.classList.add('open');
            document.body.style.overflow = 'hidden';
        }
    }

    function close() {
        const modal = getModal();
        if (modal) {
            modal.classList.remove('open');
            document.body.style.overflow = '';
        }
    }

    function update(albaIdx, status) {
        const params = new URLSearchParams();
        params.append('albaIdx', albaIdx);
        params.append('status', status);

        fetch(`${window.location.origin}/alba/updateStatus`, {
            method: 'POST',
            body: params
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                location.reload();
            } else {
                Toast.show('상태 변경에 실패했습니다.');
            }
        })
        .catch(() => Toast.show('네트워크 오류입니다.'));
    }

    return { open, close, update };
})();

const PullUpModule = (function () {
    function execute(albaIdx) {
        if (!confirm('이 공고를 목록 최상단으로 끌어올리시겠습니까?')) return;

        const params = new URLSearchParams();
        params.append('albaIdx', albaIdx);

        fetch(`${window.location.origin}/alba/pullUp`, {
            method: 'POST',
            body: params
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                Toast.show('성공적으로 끌어올렸습니다.');
                setTimeout(() => location.reload(), 1200);
            } else {
                Toast.show(data.message || '요청 처리에 실패했습니다.');
            }
        })
        .catch(() => Toast.show('네트워크 오류가 발생했습니다.'));
    }

    return { execute };
})();

const Toast = (function () {
    let timer = null;
    function show(msg) {
        const el = document.getElementById('toast');
        if (!el) return;
        el.textContent = msg;
        el.classList.add('show');
        clearTimeout(timer);
        timer = setTimeout(() => el.classList.remove('show'), 2500);
    }
    return { show };
})();

function copyAddress(address) {
    if (navigator.clipboard) {
        navigator.clipboard.writeText(address).then(() => {
            Toast.show('근무지 주소가 복사되었습니다.');
        });
    } else {
        const ta = document.createElement('textarea');
        ta.value = address;
        document.body.appendChild(ta);
        ta.select();
        document.execCommand('copy');
        document.body.removeChild(ta);
        Toast.show('근무지 주소가 복사되었습니다.');
    }
}

function confirmDelete(albaIdx) {
    if (confirm('이 공고를 정말 삭제하시겠습니까?\n삭제된 공고는 복구할 수 없습니다.')) {
        //location.href = '/alba/delete?postingIdx=' + albaIdx;
		location.href = CONTEXT_PATH + '/alba/delete?postingIdx=' + idx;
    }
}

window.addEventListener('DOMContentLoaded', function () {
    const articleEl = document.getElementById('articleData');
    if (articleEl) {
        const wished = articleEl.dataset.wished === 'true';
        const albaIdx = parseInt(articleEl.dataset.albaIdx) || 0;
        WishModule.init(wished, albaIdx);
    }
});