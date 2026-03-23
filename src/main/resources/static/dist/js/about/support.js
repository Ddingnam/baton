const { createApp, ref, computed } = Vue;

createApp({
    setup() {
        const faqs = ref([
			// 임시
            { category: 'payment', q: '바톤 포인트가 무엇인가요?', a: '구매자가 결제한 금액을 Baton이 안전하게 보관하다가, 물품 수령 확인 후 판매자에게 정산하는 에스크로 서비스입니다.' },
            { category: 'payment', q: '판매 대금은 언제 정산되나요?', a: '구매자가 구매확정을 누르는 즉시 판매자의 바통 포인트로 합산됩니다. 구매확정이 없더라도 배송 완료 3일 후 자동 정산됩니다.' },
            { category: 'payment', q: '어떤 결제 수단을 지원하나요?', a: '바통 포인트는 카카오페이 간편결제로 지원합니다.' },
            { category: 'payment', q: '안전결제 수수료는 누가 부담하나요?', a: '결제 시 발생하는 수수료는 서비스 보증 비용으로 구매자가 부담하며, 결제 단계에서 명시됩니다.' },
            { category: 'payment', q: '가상계좌 입금 기한이 있나요?', a: '가상계좌 발급 후 24시간 이내에 입금하지 않으면 주문은 자동으로 취소됩니다.' },
            { category: 'payment', q: '카드 결제 취소 후 환불까지 얼마나 걸리나요?', a: '취소 승인 후 카드사 사정에 따라 실제 환불까지는 영업일 기준 3~7일이 소요됩니다.' },
            { category: 'payment', q: '사용하지 않은 바통 포인트 환불이 가능한가요?', a: '포인트 결제 후 사용하지 않은 포인트는 결제로부터 3일(72시간) 내에 환불이 가능합니다.' },
            { category: 'payment', q: '판매자가 현금 송금을 요구해요.', a: '판매자가 바통 포인트 거래를 거부하고 직접 송금을 요구할 경우 사기 위험이 있습니다. 응하지 마시고 즉시 신고해주세요.' },
            { category: 'trade', q: '판매 금지 품목은 어떤 것들이 있나요?', a: '수제 음식·유통기한 지난 식품·개봉 식품, 의약품, 가품, 총기류 등 법적 문제 품목은 판매가 금지됩니다.' },
            { category: 'trade', q: '상품 상태는 어떻게 표기하나요?', a: '미개봉, 거의 새것, 사용감 있음, 하자 있음 4단계 중 실제 상태와 가장 일치하는 것을 선택해야 합니다.' },
            { category: 'trade', q: 'AI 자동완성은 어떻게 작동하나요?', a: '상품의 첫 번째 사진을 분석하여 카테고리, 예상 가격, 상품 설명이 자동으로 작성됩니다.' },
            { category: 'trade', q: '사진은 몇 장 올려야 하나요?', a: '앞·뒤·측면 및 하자 부위 사진을 포함하여 최소 3장 이상 실제 촬영한 사진 등록을 권장합니다.' },
            { category: 'trade', q: '끌어올리기(끌올) 규칙이 있나요?', a: '게시물당 24시간에 한 번 가능하며, 상단 노출을 통해 판매 확률을 높이는 도구로 활용합니다.' },
            { category: 'trade', q: '나눔 상품은 어떻게 등록하나요?', a: '가격을 0원으로 설정할 경우 나눔으로 표시되며, 따뜻한 동네 문화를 위해 적극 권장됩니다.' },
            { category: 'trade', q: '예약 중 상태는 어떻게 설정하나요?', a: '거래 약속이 잡힌 경우 상품 상태를 예약 중으로 변경하여 다른 사용자의 문의를 방지합니다.' },
            { category: 'trade', q: '중복 게시물 등록이 제한되나요?', a: '동일한 상품을 짧은 시간 내에 여러 번 올리는 도배 행위는 검색 품질 저하 방지를 위해 제한됩니다.' },
            { category: 'trade', q: '다른 플랫폼 결제를 유도받았어요.', a: 'Baton 내에서 타 플랫폼 결제를 유도하거나 홍보하는 행위는 운영 정책에 따라 게시글 삭제 대상입니다.' },
            { category: 'delivery', q: '반값택배 이용 시 주의사항이 있나요?', a: '편의점에서 편의점으로 배송하는 반값/알뜰 택배 이용 시 정확한 지점명을 미리 확인해야 합니다.' },
            { category: 'delivery', q: '운송장 번호는 언제까지 입력해야 하나요?', a: '택배 발송 후 24시간 이내에 앱에 송장 번호를 등록해야 하며, 미등록 시 구매자가 결제를 취소할 수 있습니다.' },
            { category: 'delivery', q: '직거래 장소는 어디서 만나야 하나요?', a: '가급적 낮 시간대에 사람이 많은 공공장소(지하철역, 편의점 앞 등)에서 만나 거래하는 것을 원칙으로 합니다.' },
            { category: 'delivery', q: '배송이 지연되고 있어요.', a: '판매자는 결제 완료 후 3일 이내에 물건을 발송해야 하며, 지연 시 구매자에게 미리 양해를 구해야 합니다.' },
            { category: 'delivery', q: '운송장 조회가 안 돼요.', a: '송장 등록 직후에는 배송 추적이 안 될 수 있으며, 택배사 수거 후 야간부터 정상 조회가 가능합니다.' },
            { category: 'delivery', q: '배송 중 물건이 파손됐어요.', a: '택배사 과실로 파손된 경우 외관 박스 파손 사진과 함께 해당 택배사에 보상을 청구할 수 있습니다.' },
            { category: 'delivery', q: '착불 배송비는 어떻게 되나요?', a: '착불 거래 시 수령인이 배송비를 직접 지불하며, 거리에 따라 추가 운임이 발생할 수 있음을 사전에 합의해두세요.' },
            { category: 'delivery', q: '문 앞 거래 시 주의할 점이 있나요?', a: '동네 이웃 간 문 앞 보관 거래 시, 사진 촬영을 통해 물품 위치를 공유하도록 권장합니다.' },
            { category: 'delivery', q: '퀵 서비스 이용 시 비용은 누가 내나요?', a: '급한 거래의 경우 퀵 서비스를 이용할 수 있으나, 비용 부담 주체를 채팅으로 명확히 합의해야 합니다.' },
            { category: 'dispute', q: '단순 변심으로 환불을 요청받았어요.', a: '개인 간 거래 특성상 단순 변심에 의한 환불 의무는 없으나, 판매글에 미리 반품 불가 규정을 명시하는 것이 좋습니다.' },
            { category: 'dispute', q: '설명에 없던 하자가 발견됐어요.', a: '게시글 설명에 없던 중대한 하자가 발견된 경우, 구매자는 구매확정 전 반품을 요청할 권리가 있습니다.' },
            { category: 'dispute', q: '반품 배송비는 누가 부담하나요?', a: '판매자 귀책 시 판매자가, 구매자 변심(합의 하에) 시 구매자가 반품 배송비를 부담하는 것이 원칙입니다.' },
            { category: 'dispute', q: '구매확정 후 문제가 생겼어요.', a: '구매확정 완료 후에는 대금이 이미 정산되므로, Baton 시스템을 통한 환불이 불가하며 당사자 간 합의가 필요합니다.' },
            { category: 'dispute', q: '사기 피해를 당한 것 같아요.', a: '사기가 의심될 경우 상대방의 정보를 캡처하여 경찰에 신고하고 사건번호를 Baton에 공유해주세요.' },
            { category: 'dispute', q: '근거 없는 비매너 평가를 받았어요.', a: '근거 없는 비매너 평가를 받은 경우 고객센터를 통해 소명 절차를 밟을 수 있습니다.' },
            { category: 'dispute', q: '분쟁 조정은 어떻게 하나요?', a: '당사자 간 합의가 어려울 경우 Baton 분쟁 조정센터에 개입을 요청하고 안내에 따라 증거를 제출하세요.' },
            { category: 'dispute', q: '미성년자 거래는 어떻게 되나요?', a: '법정대리인의 동의 없는 미성년자 거래는 민법에 따라 취소 사유가 될 수 있습니다.' },
            { category: 'community', q: '커뮤니티에 올릴 수 없는 게시글이 있나요?', a: '비방·욕설, 허위 정보, 음란물, 개인정보 노출, 광고 등은 즉시 삭제됩니다.' },
            { category: 'community', q: '커뮤니티 게시글은 어디에 노출되나요?', a: '게시글은 작성자의 동네 인증 지역을 기반으로 노출되며, 인근 이웃에게만 공개됩니다.' },
            { category: 'community', q: '커뮤니티 투표 기능은 어떻게 사용하나요?', a: '게시글 작성 시 투표를 추가하여 이웃의 의견을 수집할 수 있습니다. 항목은 최대 10개까지 가능합니다.' },
            { category: 'community', q: '분실물·실종 게시글 작성 팁이 있나요?', a: '정확한 위치와 특징을 기재하면 이웃의 도움을 받을 가능성이 높아집니다.' },
            { category: 'community', q: '게시글을 신고하는 방법은?', a: '문제 게시글 우측 상단의 신고 아이콘을 눌러 제출하면 관리자가 검토 후 조치합니다.' },
            { category: 'account', q: '탈퇴 신청 방법은 어떻게 되나요?', a: '마이페이지 > 설정 > 회원탈퇴에서 신청할 수 있습니다. 관리자 검토를 거쳐 최종 처리됩니다.' },
            { category: 'account', q: '탈퇴 신청 후 계정은 어떻게 되나요?', a: '탈퇴 신청 시 즉시 비활성화되어 로그인이 불가능하며, 승인 후 데이터가 삭제됩니다.' },
            { category: 'account', q: '탈퇴 처리는 얼마나 걸리나요?', a: '탈퇴 신청 후 관리자 검토까지 영업일 기준 최대 3~5일이 소요될 수 있습니다.' },
            { category: 'account', q: '탈퇴할 수 없는 경우가 있나요?', a: '진행 중인 에스크로 거래나 처리되지 않은 신고 내역이 있는 경우 탈퇴가 제한됩니다.' },
            { category: 'account', q: '탈퇴 시 바통 포인트는 어떻게 되나요?', a: '잔여 포인트는 탈퇴 전에 사용하거나 환불해야 합니다. 탈퇴 후에는 복구가 불가능합니다.' },
            { category: 'account', q: '탈퇴 후 재가입이 가능한가요?', a: '탈퇴 완료 후 재가입이 가능하지만 이전 거래 내역 및 포인트 등 기존 데이터는 복구되지 않습니다.' },
            { category: 'account', q: '탈퇴 신청을 취소하고 싶어요.', a: '관리자 승인 전이라면 고객센터를 통해 취소를 요청할 수 있습니다.' }
        ]);

        const categories = ref([
            { key: 'all', name: '전체', icon: 'ri-apps-line', color: 'linear-gradient(135deg,#6b7280,#4b5563)' },
            { key: 'payment', name: '결제 · 포인트', icon: 'ri-secure-payment-line', color: 'linear-gradient(135deg,#4f8ef7,#6c63ff)' },
            { key: 'trade', name: '거래 · 상품등록', icon: 'ri-store-2-line', color: 'linear-gradient(135deg,#f7974f,#f7564f)' },
            { key: 'delivery', name: '배송 · 직거래', icon: 'ri-truck-line', color: 'linear-gradient(135deg,#4fcf70,#2bb5a0)' },
            { key: 'dispute', name: '분쟁 · 신고', icon: 'ri-shield-check-line', color: 'linear-gradient(135deg,#f76fad,#c84b8f)' },
            { key: 'community', name: '커뮤니티', icon: 'ri-discuss-line', color: 'linear-gradient(135deg,#fbc741,#f7974f)' },
            { key: 'account', name: '계정 · 탈퇴', icon: 'ri-user-settings-line', color: 'linear-gradient(135deg,#a78bfa,#6c63ff)' }
        ]);

        const badgeMap = {
            payment: { label: '결제', color: 'linear-gradient(135deg,#4f8ef7,#6c63ff)' },
            trade: { label: '거래', color: 'linear-gradient(135deg,#f7974f,#f7564f)' },
            delivery: { label: '배송', color: 'linear-gradient(135deg,#4fcf70,#2bb5a0)' },
            dispute: { label: '분쟁', color: 'linear-gradient(135deg,#f76fad,#c84b8f)' },
            community: { label: '커뮤니티', color: 'linear-gradient(135deg,#fbc741,#f7974f)' },
            account: { label: '계정', color: 'linear-gradient(135deg,#a78bfa,#6c63ff)' }
        };

        const quickTags = ['안전결제', '환불', '배송', '금지품목', '탈퇴', '사기신고', '포인트'];
        const searchQuery = ref('');
        const searchFocused = ref(false);
        const selectedCat = ref('all');
        const openIdx = ref(null);
        const searchResults = ref([]);
        const selectedFaq = ref(null);

        const filteredFaqs = computed(() => {
            if (selectedCat.value === 'all') return faqs.value;
            return faqs.value.filter(f => f.category === selectedCat.value);
        });

        const catTitle = computed(() => {
            const c = categories.value.find(c => c.key === selectedCat.value);
            return c ? (c.key === 'all' ? '전체 FAQ' : c.name) : 'FAQ';
        });

        const getFaqCount = (key) => key === 'all' ? faqs.value.length : faqs.value.filter(f => f.category === key).length;

        function onSearch() {
            const kw = searchQuery.value.toLowerCase().trim();
            if (!kw) { searchResults.value = []; return; }
            searchResults.value = faqs.value.filter(f => f.q.toLowerCase().includes(kw) || f.a.toLowerCase().includes(kw)).slice(0, 5);
        }

        function clearSearch() { searchQuery.value = ''; searchResults.value = []; }

        function highlightText(text) {
            if (!searchQuery.value) return text;
            const regex = new RegExp('(' + searchQuery.value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + ')', 'gi');
            return text.replace(regex, '<mark>$1</mark>');
        }

		function clickSearchResult(item) {
			searchFocused.value = false;
		    selectedCat.value = item.category;

		    const targetIdx = faqs.value
		        .filter(f => f.category === item.category)
		        .findIndex(f => f.q === item.q);
		    
		    openIdx.value = targetIdx;
		    searchQuery.value = '';
		    searchResults.value = [];

		    setTimeout(() => {
		        const faqItems = document.querySelectorAll('.faq-item');
		        if (faqItems[targetIdx]) {
		            faqItems[targetIdx].scrollIntoView({ behavior: 'smooth', block: 'center' });
		        }
		    }, 100);
		}

        function setQuickTag(tag) {
            searchQuery.value = tag;
            onSearch();
        }

        function selectCat(key) {
            selectedCat.value = key;
            openIdx.value = null;
            setTimeout(() => {
                document.querySelector('.support-faq')?.scrollIntoView({ behavior: 'smooth' });
            }, 50);
        }

        function toggleFaq(idx) {
            openIdx.value = openIdx.value === idx ? null : idx;
        }

        function openChatbot() {
            if (window.openBatonChatbot) window.openBatonChatbot();
            else window.location.href = '/chatbot/slidePanel';
        }

        return {
            faqs, categories, badgeMap, quickTags, searchQuery, searchFocused, selectedCat, openIdx,
            searchResults, selectedFaq, filteredFaqs, catTitle, getFaqCount, onSearch, clearSearch,
            highlightText, clickSearchResult, setQuickTag, selectCat, toggleFaq, openChatbot
        };
    }
}).mount('#support-app');