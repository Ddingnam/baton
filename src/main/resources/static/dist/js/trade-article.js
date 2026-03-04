const Gallery = (function () {
    let images = [];
    let currentIdx = 0;

    function init() {
        const thumbItems = document.querySelectorAll('.thumb-item');
        const mainImg    = document.getElementById('mainImage');
        if (!mainImg) return;

        thumbItems.forEach(function (el, i) {
            const img = el.querySelector('img');
            if (img) {
				images.push(img.src);
				console.log("로드된 이미지 주소:", img.src);
			}
            el.addEventListener('click', function () { selectThumb(i); });
        });
        if (images.length === 0) {
            const src = mainImg.src;
            if (src) images.push(src);
        }
        mainImg.addEventListener('click', function () { Lightbox.open(currentIdx); });
        mainImg.parentElement.style.cursor = 'zoom-in';
    }

    function selectThumb(idx) {
        currentIdx = idx;
        const mainImg   = document.getElementById('mainImage');
        const thumbItems = document.querySelectorAll('.thumb-item');

        if (mainImg && images[idx]) mainImg.src = images[idx];
        thumbItems.forEach(function (el, i) {
            el.classList.toggle('active', i === idx);
        });
    }

    function getCurrent() { return currentIdx; }
    function getImages()  { return images; }

    return { init, selectThumb, getCurrent, getImages };
})();

const Lightbox = (function () {
    let idx = 0;

    function open(startIdx) {
        idx = startIdx || 0;
        render();
        const box = document.getElementById('lightbox');
        if (box) box.classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function close() {
        const box = document.getElementById('lightbox');
        if (box) box.classList.remove('open');
        document.body.style.overflow = '';
    }

    function prev() {
        const images = Gallery.getImages();
        idx = (idx - 1 + images.length) % images.length;
        render();
    }

    function next() {
        const images = Gallery.getImages();
        idx = (idx + 1) % images.length;
        render();
    }

    function render() {
        const images = Gallery.getImages();
        const img    = document.getElementById('lightboxImg');
        const count  = document.getElementById('lightboxCount');
		
        if (img)   img.src = images[idx] || '';
        if (count) count.textContent = (idx + 1) + ' / ' + images.length;
    }

    function init() {
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') close();
            if (e.key === 'ArrowLeft')  prev();
            if (e.key === 'ArrowRight') next();
        });

        const box = document.getElementById('lightbox');
        if (box) {
            box.addEventListener('click', function (e) {
                if (e.target === box) close();
            });
        }
    }

    return { init, open, close, prev, next };
})();

const WishModule = {
    isProcessing: false,
    isLiked: false,

    init: function(wished, wishCount, tradeIdx) {
        this.isLiked = wished;
    },

    toggle: function() {
        if(this.isProcessing) return;
        
        const dataDiv = document.getElementById('articleData');
        if(!dataDiv) return;
        
        const productIdx = dataDiv.getAttribute('data-trade-idx');
        
        const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
        const headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
        if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

        this.isProcessing = true;

        fetch('/trade/toggleLike', {
            method: 'POST',
            headers: headers,
            body: new URLSearchParams({ productIdx: productIdx })
        })
        .then(response => response.json())
        .then(data => {
            if(data.status === 'success') {
                const btn = document.getElementById('wishBtnLarge');
                const statWish = document.getElementById('statWish'); 
                const statWishSide = document.getElementById('statWishSide');
                
                this.isLiked = data.isLiked;
                
                if(btn) {
                    btn.classList.toggle('active', data.isLiked);
                    btn.innerHTML = (data.isLiked ? '❤️' : '🤍') + ' 찜 ' + data.likeCount;
                }
                
                if(statWish) statWish.innerText = data.likeCount;
                if(statWishSide) statWishSide.innerText = data.likeCount;
                
                Toast.show(data.isLiked ? "관심 목록에 추가되었습니다." : "관심 목록에서 제거되었습니다.");
            }
        })
        .catch(err => {
            console.error("찜하기 에러:", err);
            Toast.show("처리 중 오류가 발생했습니다.");
        })
        .finally(() => { this.isProcessing = false; });
    }
};

const ShareModule = (function () {
    function share() {
        if (navigator.share) {
            navigator.share({
                title: document.title,
                url: location.href
            }).catch(function () {});
        } else {
            copyLink();
        }
    }

    function copyLink() {
        if (navigator.clipboard) {
            navigator.clipboard.writeText(location.href).then(function () {
                Toast.show('링크가 복사되었습니다!');
            });
        } else {
            const ta = document.createElement('textarea');
            ta.value = location.href;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
            Toast.show('링크가 복사되었습니다!');
        }
    }

    return { share };
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

    function update(productIdx, status) {
        const params = new URLSearchParams();
        params.append('productIdx', productIdx);
        params.append('status', status);

        fetch(`${window.location.origin}/trade/updateStatus`, {
            method: 'POST',
            body: params
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                location.reload();
            } else {
                Toast.show('상태 변경 처리에 실패했습니다.');
            }
        })
        .catch(() => Toast.show('네트워크 오류가 발생했습니다.'));
    }

    return { open, close, update };
})();

const PullUpModule = (function () {
    function execute(productIdx) {
        if (!confirm('🚀 이 게시글을 목록 맨 위로 올리시겠습니까?')) return;

        const params = new URLSearchParams();
        params.append('productIdx', productIdx);

        fetch(`${window.location.origin}/trade/pullUp`, {
            method: 'POST',
            body: params
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'success') {
                Toast.show('🚀 게시글이 맨 위로 올라갔습니다!');
                setTimeout(() => location.reload(), 1200);
            } else {
                Toast.show(data.message || '끌어올리기를 할 수 없습니다.');
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
        timer = setTimeout(function () { el.classList.remove('show'); }, 2500);
    }

    return { show };
})();

function confirmDelete(productIdx) {
    if (confirm('정말 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) {
        location.href = '/trade/delete?productIdx=' + productIdx;
    }
}

window.addEventListener('DOMContentLoaded', function () {
    Gallery.init();
    Lightbox.init();

    const articleEl   = document.getElementById('articleData');
    if (articleEl) {
        const wished    = articleEl.dataset.wished === 'true';
        const wishCount = parseInt(articleEl.dataset.wishCount) || 0;
        const tradeIdx  = parseInt(articleEl.dataset.tradeIdx)  || 0;
        WishModule.init(wished, wishCount, tradeIdx);
    }
});
