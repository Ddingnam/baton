const Gallery = (function () {
    let images = [];
    let currentIdx = 0;
    let mainImg = null;

    function init() {
        mainImg = document.getElementById('mainImage');
        if (!mainImg) return;

        const thumbItems = document.querySelectorAll('.thumb-item');
        
        if (thumbItems.length > 0) {
            thumbItems.forEach(function (el) {
                const img = el.querySelector('img');
                if (img) images.push(img.src);
            });
        } else if (mainImg.src) {
            images.push(mainImg.src);
        }

        if (images.length <= 1) {
            const navBtns = mainImg.parentElement.querySelectorAll('.nav-btn');
            navBtns.forEach(btn => btn.style.display = 'none');
        } else {
            const prevBtn = mainImg.parentElement.querySelector('.prev-btn');
            const nextBtn = mainImg.parentElement.querySelector('.next-btn');

            if (prevBtn) prevBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                prev();
            });
            if (nextBtn) nextBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                next();
            });
        }

        showImage(0);
		
        mainImg.parentElement.style.cursor = 'zoom-in';
        mainImg.addEventListener('click', function () { Lightbox.open(currentIdx); });
    }

	function showImage(idx) {
	    if (!images[idx]) return;
	    
	    currentIdx = idx;
		
	    mainImg.src = images[currentIdx];

	    const thumbItems = document.querySelectorAll('.thumb-item');
	    thumbItems.forEach(function (el, i) {
	        el.classList.toggle('active', i === idx);
	    });
	}

    function prev() {
        const idx = (currentIdx - 1 + images.length) % images.length;
        showImage(idx);
    }

    function next() {
        const idx = (currentIdx + 1) % images.length;
        showImage(idx);
    }

    function getCurrent() { return currentIdx; }
    function getImages()  { return images; }

    return { init, getCurrent, getImages, showImage, prev, next };
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
		Gallery.showImage(idx);
        render();
    }

    function next() {
        const images = Gallery.getImages();
        idx = (idx + 1) % images.length;
		Gallery.showImage(idx);
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

const TimeAgoModule = (function () {
    function format(dateString) {
        if (!dateString) return "";

		let cleanDate = dateString.trim().split('.')[0].replace(/-/g, '/');
		const date = new Date(cleanDate);
		const now = new Date();
		const diff = Math.floor((now - date) / 1000);

        if (isNaN(date.getTime())) return dateString;
        if (diff < 60) return "방금 전";
        if (diff < 3600) return Math.floor(diff / 60) + "분 전";
        if (diff < 86400) return Math.floor(diff / 3600) + "시간 전";
        if (diff < 2592000) return Math.floor(diff / 86400) + "일 전";
        
        return dateString.split(' ')[0];
    }

	function init() {
	        const elements = document.querySelectorAll('.time-ago');
	        elements.forEach(el => {
	            const rawDate = el.getAttribute('data-time') || el.innerText;
	            if (rawDate) {
	                el.setAttribute('data-time', rawDate); 
	                el.innerText = format(rawDate);
	            }
	        });
	    }

    return { init };
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
                    btn.innerHTML = ' 찜 ' + data.likeCount;
                }
                
                if(statWish) statWish.innerText = data.likeCount;
                if(statWishSide) statWishSide.innerText = data.likeCount;
                
				
                showBatonToast(data.isLiked ? "관심 목록에 추가되었습니다." : "관심 목록에서 제거되었습니다.");
            }
        })
        .catch(err => {
            console.error("찜하기 에러:", err);
            showBatonToast("오류가 발생했습니다.");
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
                showBatonToast('링크가 복사되었습니다.');
            });
        } else {
            const ta = document.createElement('textarea');
            ta.value = location.href;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
            showBatonToast('링크가 복사되었습니다!');
        }
    }

    return { share };
})();

const StatusModule = (function () {
    const getModal = () => document.getElementById('statusModal');
	

    function open() {
		const articleData = document.getElementById('articleData');
		const currentStatus = articleData ? articleData.dataset.tradeStatus : '';
	
		if (currentStatus === '판매완료') {
			showBatonToast("판매 완료된 상품은 상태를 변경할 수 없습니다.");
			return;
		}
		
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

	function update(productIdx, tradeStatus) {
		const params = new URLSearchParams();
		params.append('productIdx', productIdx);
		params.append('tradeStatus', tradeStatus);

		fetch(`${window.location.origin}/trade/updateStatus`, {
			method: 'POST',
			body: params
		})
		.then(() => {
			close();

			let msg = `상품 상태가 [${tradeStatus}]로 변경되었습니다.`;
	            
			if (tradeStatus === '숨기기') {
				msg = '게시글이 숨김 처리되었습니다. 목록으로 이동합니다.';
			} else if (tradeStatus === '판매완료') {
				msg = '🎉 판매가 완료되었습니다! 상태가 변경되었습니다.';
			}

	        showBatonToast(msg);

	        setTimeout(() => {
	            if (tradeStatus === '숨기기') {
	            	location.href = '/trade/list'; 
	            } else {
	                location.reload();
	            }
	        }, 1200);
		})
		.catch(err => {
			console.error("통신 실패:", err);
			showBatonToast("상태 변경 중 오류가 발생했습니다.");
		});
	}

    return { open, close, update };
})();

const PullUpModule = (function () {
    function execute(productIdx) {
		const articleData = document.getElementById('articleData');
		const currentStatus = articleData ? articleData.dataset.tradeStatus : '';

		if (currentStatus === '판매완료') {
			showBatonToast("판매 완료된 상품은 끌어올리기를 할 수 없습니다.");
			return; 
		}
		
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
                showBatonToast('🚀 게시글이 맨 위로 올라갔습니다!');
                setTimeout(() => location.reload(), 1200);
            } else if (data.status === 'limit') {
				showBatonToast(data.message);
			} else {
                showBatonToast('끌어올리기를 할 수 없습니다.');
            }
        })
        .catch(() => showBatonToast('네트워크 오류가 발생했습니다.'));
    }

    return { execute };
})();

const MapModule = (function () {
    function init() {
        const mapContainer = document.getElementById('map');
        if (!mapContainer) return;
		
		const dataDiv = document.getElementById('articleData');
		const lat = parseFloat(dataDiv.getAttribute('data-lat'));
		const lng = parseFloat(dataDiv.getAttribute('data-lng'));

        if (isNaN(lat) || isNaN(lng)) {
            mapContainer.style.display = 'none';
            return;
        }

        const mapOption = {
            center: new kakao.maps.LatLng(lat, lng),
            level: 3
        };

        const map = new kakao.maps.Map(mapContainer, mapOption);

        const markerPosition = new kakao.maps.LatLng(lat, lng);
        const marker = new kakao.maps.Marker({
            position: markerPosition
        });
        marker.setMap(map);

        map.setDraggable(true);
        map.setZoomable(true);
		
		const zoomControl = kakao.maps.ControlPosition.RIGHT;
		map.addControl(new kakao.maps.ZoomControl(), zoomControl);
		        
		const mapTypeControl = kakao.maps.ControlPosition.TOPRIGHT;
		map.addControl(new kakao.maps.MapTypeControl(), mapTypeControl);
    }

    return { init };
})();

function confirmDelete(productIdx) {
    if (confirm('정말 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) {
        location.href = '/trade/delete?productIdx=' + productIdx;
    }
}

window.addEventListener('DOMContentLoaded', function () {
    Gallery.init();
    Lightbox.init();
	MapModule.init();
	TimeAgoModule.init();

    const articleEl   = document.getElementById('articleData');
    if (articleEl) {
        const wished    = articleEl.dataset.wished === 'true';
        const wishCount = parseInt(articleEl.dataset.wishCount) || 0;
        const tradeIdx  = parseInt(articleEl.dataset.tradeIdx)  || 0;
        WishModule.init(wished, wishCount, tradeIdx);
    }
});

function openShippingModal() {
    document.getElementById('shippingModal').classList.add('open');
}

function closeShippingModal() {
    document.getElementById('shippingModal').classList.remove('open');
    document.getElementById('trackingNumber').value = '';
}

function submitShippingInfo() {
    const company = document.getElementById('deliveryCompany').value;
    const trackingNo = document.getElementById('trackingNumber').value.trim();

    if (!trackingNo) {
        alert('운송장 번호를 입력해주세요.');
        document.getElementById('trackingNumber').focus();
        return;
    }

    const articleData = document.getElementById('articleData');
    const productIdx = articleData ? articleData.dataset.tradeIdx : '';

    const params = new URLSearchParams();
    params.append('productIdx', productIdx);
    params.append('deliveryCompany', company);
    params.append('trackingNumber', trackingNo);

    fetch(window.contextPath + '/escrow/shipping', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.state === 'true') {
            alert(data.message);
            location.reload(); 
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('발송 처리 중 오류가 발생했습니다.');
    });
}

function confirmTradePurchase(productIdx) {
    if(!confirm("물건을 무사히 받으셨나요? 구매 확정 시 판매자에게 돈이 정산되며 환불이 불가능합니다.")) return;

    const params = new URLSearchParams();
    params.append('productIdx', productIdx);

    fetch(window.contextPath + '/escrow/confirm', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.state === 'true') {
            alert(data.message);
            location.reload(); 
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
}

function cancelTrade(productIdx) {
    if(!confirm("정말 거래를 취소하시겠습니까?\n취소 시 구매자에게 포인트가 즉시 전액 환불됩니다.")) return;

    const params = new URLSearchParams();
    params.append('productIdx', productIdx);

    fetch(window.contextPath + '/escrow/cancel', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.state === 'true') {
            alert(data.message);
            location.reload(); 
        } else {
            alert(data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('취소 처리 중 오류가 발생했습니다.');
    });
} 

function requestRefundViaChat(productIdx, sellerIdx) {
    if(confirm("반품 및 환불은 판매자와의 채팅을 통해 직접 협의해야 합니다.\n판매자와 1:1 채팅을 시작하시겠습니까?")) {
        const url = window.contextPath + '/chat/room?tradeIdx=' + productIdx + '&toUserIdx=' + sellerIdx;
        window.open(url, 'chatRoom', 'width=450, height=850, left=200, top=100, scrollbars=yes, resizable=yes');
    }
}
