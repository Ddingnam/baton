function useTradeArticle(shared) {
    const { Vue } = window;
    const { ref, reactive, computed, nextTick } = Vue;

    function csrfHeaders() {
        const token = document.querySelector('meta[name="_csrf"]')?.content;
        const header = document.querySelector('meta[name="_csrf_header"]')?.content;
        const h = { 'Content-Type': 'application/x-www-form-urlencoded' };
        if (token && header) h[header] = token;
        return h;
    }

    function formatTimeAgo(dateString) {
        if (!dateString) return '';
        const clean = dateString.trim().split('.')[0].replace(/-/g, '/');
        const date  = new Date(clean);
        const diff  = Math.floor((Date.now() - date) / 1000);
        if (isNaN(date.getTime())) return dateString;
        if (diff < 60) return '방금 전';
        if (diff < 3600) return Math.floor(diff / 60) + '분 전';
        if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
        if (diff < 2592000) return Math.floor(diff / 86400) + '일 전';
        return dateString.split(' ')[0];
    }

    const article = ref(null);
    const articleImages = ref([]);
    const articleTags = ref([]);
    const escrowInfo = ref(null);
    const articleIsLiked = ref(false);
    const articleLikeCount = ref(0);
    const articleIsLoggedIn = ref(false);
    const articleIsOwner = ref(false);
    const articleCurrentUserIdx = ref(null);
	
    const currentImg = ref(0);
    const lightboxOpen = ref(false);
    const lightboxIdx = ref(0);
    const statusOpen = ref(false);
    const shippingOpen = ref(false);
    const reportOpen = ref(false);
    const shipping = reactive({ company: 'CJ대한통운', trackingNumber: '' });
    const report = reactive({ type: '', content: '' });

    const mainImgSrc = computed(() => articleImages.value[currentImg.value]  || ('/dist/images/noimage.png'));
    const lightboxSrc = computed(() => articleImages.value[lightboxIdx.value] || '');
    const articleStatusLabel = computed(() => {
        const s = article.value?.tradeStatus;
        return s === '판매중' ? '판매 중' : s === '예약중' ? '예약 중' : s === '판매완료' ? '판매 완료' : (s||'');
    });

	let _map = null, _marker = null;

	function initMapArticle() {
	    if (!window.kakao || !window.kakao.maps) {
	        setTimeout(initMapArticle, 100);
	        return;
	    }

	    const container = document.getElementById('articleMap');
	    if (!container) {
	        setTimeout(initMapArticle, 100);
	        return;
	    }

	    window.kakao.maps.load(() => {
	        const lat = parseFloat(article.value?.latitude);
	        const lng = parseFloat(article.value?.longitude);
	        
	        if (isNaN(lat) || isNaN(lng)) {
	            container.style.display = 'none';
	            return;
	        }
	        
	        container.style.display = 'block';
	        const loc = new kakao.maps.LatLng(lat, lng);

	        if (_map) {
	            _map.relayout();
	            _map.setCenter(loc);
	            if (_marker) _marker.setPosition(loc);
	        } else {
	            _map = new kakao.maps.Map(container, { center: loc, level: 3 });
	            _marker = new kakao.maps.Marker({ position: loc, map: _map });
	            _map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
	            _map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
	        }
	        
			setTimeout(() => {
			        if (_map) {
			            _map.relayout();
			            _map.setCenter(loc);
			        }
			    }, 200);
	    });
	}

    async function loadArticle(productIdx) {
        article.value = null;
        articleImages.value = [];
        articleTags.value = [];
        escrowInfo.value = null;
        currentImg.value = 0;
        lightboxOpen.value = false;
        _map = null; _marker = null;

        try {
            const res = await fetch('/api/trade/article/' + productIdx);
            const data = await res.json();

            article.value = data.trade;
            articleImages.value = (data.imageList||[]).length > 0
                ? data.imageList.map(i => i.imgUrl)
                : (data.trade?.imgUrl ? [data.trade.imgUrl] : ['/dist/images/noimage.png']);
            articleTags.value = data.tagList || [];
            escrowInfo.value = data.escrowInfo || null;
            articleIsLiked.value = data.isLiked || false;
            articleLikeCount.value = data.trade?.likeCount || 0;
            articleIsLoggedIn.value = data.isLoggedIn || false;
            articleIsOwner.value = data.isOwner || false;
            articleCurrentUserIdx.value = data.currentUserIdx || null;
        } catch (e) { console.error(e); return; }

        nextTick(() => {
            if (!article.value?.tradePlace || !article.value?.latitude) return;
            setTimeout(initMapArticle, 150);
        });
    }

    function openLightbox(i) { 
		lightboxIdx.value = i; 
		lightboxOpen.value = true; 
	}
	
	function prevImg() {
	    currentImg.value = (currentImg.value - 1 + articleImages.value.length) % articleImages.value.length;
	}

	function nextImg() {
	    currentImg.value = (currentImg.value + 1) % articleImages.value.length;
	}
	
    function lightboxPrev()  {
        lightboxIdx.value = (lightboxIdx.value - 1 + articleImages.value.length) % articleImages.value.length;
        currentImg.value = lightboxIdx.value;
    }
	
    function lightboxNext()  {
        lightboxIdx.value = (lightboxIdx.value + 1) % articleImages.value.length;
        currentImg.value = lightboxIdx.value;
    }

	async function toggleWishArticle() {
	    const res = await fetch('/api/trade/toggleLike', { 
	        method: 'POST', 
	        headers: csrfHeaders(), 
	        body: new URLSearchParams({ productIdx: article.value.productIdx }) 
	    });
	    const data = await res.json();
	    
	    if (data.status === 'success' || data.isLiked !== undefined) {
	        articleIsLiked.value = data.isLiked;
	        articleLikeCount.value = data.likeCount;
	        if (typeof showBatonToast === 'function') {
				showBatonToast(data.isLiked ? '관심 목록에 추가되었습니다.' : '관심 목록에서 제거되었습니다.');
			}
	    }
	}

    async function updateStatus(status) {
        await fetch('/api/trade/updateStatus', { 
			method: 'POST', 
			headers: csrfHeaders(), 
			body: new URLSearchParams({ productIdx: article.value.productIdx, tradeStatus: status }) 
		});
		
        article.value.tradeStatus = status;
        statusOpen.value = false;
        if (typeof showBatonToast === 'function') {
			showBatonToast('상태가 변경되었습니다.');
		}
    }

    async function pullUp() {
        if (article.value?.tradeStatus === '판매완료') { 
			if (typeof showBatonToast === 'function') {
				showBatonToast('판매 완료된 상품은 끌어올리기를 할 수 없습니다.'); 
				return;
			}
		}
        if (!confirm('이 게시글을 목록 맨 위로 올리시겠습니까?')) return;
		
        const res = await fetch('/api/trade/pullUp', { 
			method: 'POST', 
			headers: csrfHeaders(), 
			body: new URLSearchParams({ productIdx: article.value.productIdx }) 
		});
		
        const data = await res.json();
        if (typeof showBatonToast === 'function') {
			showBatonToast(data.status === 'success' ? '게시글이 맨 위로 올라갔습니다!' : (data.message||'끌어올리기 실패'));
		}
    }

	async function doDelete() {
		if (!confirm('정말 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.')) return;

		try {
			const res = await fetch('/api/trade/delete', {
				method: 'POST',
				headers: csrfHeaders(),
				body: new URLSearchParams({ productIdx: article.value.productIdx })
	        });

	        const data = await res.json();

	        if (data.status === 'success') {
	            if (typeof showBatonToast === 'function') {
					showBatonToast('게시글이 삭제되었습니다.');
	            }
	            if (shared.router) {
	                shared.router.push('/');
	            } else {
	                location.href = '/trade/main';
	            }
	        } else {
	            showBatonToast('삭제에 실패했습니다: ' + (data.message || '알 수 없는 오류'));
	        }
		} catch (e) {
			console.error('삭제 오류:', e);
			showBatonToast('삭제 중 오류가 발생했습니다.');
		}
	}
	
    function openChatList() { window.open('/chat/tradeList?tradeIdx=' + article.value.productIdx, 'chatList', 'width=450,height=850,left=200,top=100,scrollbars=no,resizable=yes'); }
    function openChatRoom() { window.open('/chat/room?tradeIdx=' + article.value.productIdx + '&toUserIdx=' + article.value.userIdx, 'chatRoom', 'width=450,height=850,left=200,top=100,scrollbars=yes,resizable=yes'); }

    function shareArticle() {
        if (navigator.share) navigator.share({ title: article.value?.title, url: location.href });
        else { navigator.clipboard?.writeText(location.href); if (typeof showBatonToast === 'function') showBatonToast('링크가 복사되었습니다.'); }
    }
	
	function goToCheckout(productIdx) {
		window.location.href = '/escrow/checkout?productIdx=' + productIdx;
	}
	
	function goToMyPage() {
		window.location.href = '/mypage';
	}
	
	function goToTradePage(userIdx) {
		window.location.href = '/mypage/tradeUserMain?userIdx=' + userIdx;
	}

    async function submitShipping() {
        if (!shipping.trackingNumber.trim()) { 
			alert('운송장 번호를 입력해주세요.'); 
			return; 
		}
        const res  = await fetch('/escrow/shipping', { 
			method: 'POST', 
			headers: csrfHeaders(), 
			body: new URLSearchParams({ productIdx: article.value.productIdx, deliveryCompany: shipping.company, trackingNumber: shipping.trackingNumber }) 
		});
        const data = await res.json();
        alert(data.message);
        if (data.state === 'true') location.reload();
    }

    async function cancelTrade() {
        if (!confirm('정말 거래를 취소하시겠습니까?')) return;
		
        const res  = await fetch('/escrow/cancel', { 
			method: 'POST', 
			headers: csrfHeaders(), 
			body: new URLSearchParams({ productIdx: article.value.productIdx }) 
		});
		
        const data = await res.json();
        alert(data.message);
        if (data.state === 'true') location.reload();
    }

    async function confirmPurchase() {
        if (!confirm('물건을 무사히 받으셨나요? 구매 확정 시 환불이 불가능합니다.')) return;
        const res  = await fetch('/escrow/confirm', { 
			method: 'POST', 
			headers: csrfHeaders(), 
			body: new URLSearchParams({ productIdx: article.value.productIdx }) 
		});
        const data = await res.json();
        alert(data.message);
        if (data.state === 'true') location.href = '/review/write?productIdx=' + article.value.productIdx + '&role=BUYER';
    }

    function requestRefund() {
        if (confirm('반품 및 환불은 판매자와의 채팅을 통해 협의해야 합니다. 채팅을 시작하시겠습니까?'))
            openChatRoom();
    }

    async function submitReport() {
        if (!report.type) { alert('신고 사유를 선택해주세요.'); return; }
        await fetch('/report/submit', { 
			method: 'POST', 
			headers: csrfHeaders(), 
			body: new URLSearchParams({ 
				domainType: 'TRADE', 
				targetIdx: article.value.productIdx, 
				reportedUserIdx: article.value.userIdx, 
				reportType: report.type, 
				content: report.content 
			}) 
		});
		
        alert('신고가 접수되었습니다.');
        reportOpen.value = false; 
		report.type = ''; 
		report.content = '';
    }

    return {
        article, articleImages, articleTags, escrowInfo,
        articleIsLiked, articleLikeCount, articleIsLoggedIn, articleIsOwner, articleCurrentUserIdx,
        currentImg, mainImgSrc, lightboxOpen, lightboxIdx, lightboxSrc,
        statusOpen, shippingOpen, reportOpen, shipping, report, articleStatusLabel,
        loadArticle, openLightbox, prevImg, nextImg, lightboxPrev, lightboxNext,
        toggleWishArticle, updateStatus, pullUp, doDelete,
        openChatList, openChatRoom, shareArticle, goToCheckout, goToMyPage, goToTradePage,
        submitShipping, cancelTrade, confirmPurchase, requestRefund, submitReport,
        formatTimeAgo
    };
}
