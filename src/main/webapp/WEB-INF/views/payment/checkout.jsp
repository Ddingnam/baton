<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>안전결제 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css" rel="stylesheet">
<style>
    body { background-color: #F7FCFA; } /* 바톤터치 중고거래 전용 배경색 */
    
    .checkout-wrapper {
        max-width: 540px;
        /* 헤더 겹침 완벽 해결: 상단 마진을 120px로 넉넉하게! */
        margin: 120px auto 80px; 
        background: #fff;
        border-radius: 20px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.04);
        padding: 40px;
    }
    
    .page-title { font-size: 22px; font-weight: 800; color: #333; margin-bottom: 30px; text-align: center; }
    .section-title { font-size: 16px; font-weight: 700; color: #333; margin: 30px 0 15px 0; }
    
    /* 상품 요약 박스 */
    .product-box { display: flex; align-items: center; padding: 15px; background: #F2FAF8; border-radius: 12px; margin-bottom: 20px; border: 1px solid #E6F8F3; }
    .product-box img { width: 64px; height: 64px; border-radius: 10px; object-fit: cover; margin-right: 15px; border: 1px solid #eaeaea; background: #fff; }
    .product-info { flex: 1; overflow: hidden; }
    .product-info h4 { margin: 0 0 6px 0; font-size: 15px; font-weight: 600; color: #333; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .product-info p { margin: 0; font-size: 16px; font-weight: 700; color: #00B98D; }
    
    /* 배송/결제 방식 (라디오 버튼) */
    .radio-group { display: flex; gap: 15px; }
    .radio-label { flex: 1; display: flex; align-items: center; justify-content: center; padding: 12px; border: 1px solid #ddd; border-radius: 10px; cursor: pointer; transition: 0.2s; font-size: 14px; font-weight: 500; color: #555; }
    .radio-label:has(input:checked) { border-color: #00B98D; background: #F2FAF8; color: #00B98D; font-weight: 700; }
    .radio-label input { display: none; }
    
    /* 폼 입력칸 */
    .form-group { margin-bottom: 15px; }
    .form-label { display: block; font-size: 13px; font-weight: 600; color: #666; margin-bottom: 8px; }
    .form-control { width: 100%; padding: 14px 15px; border: 1px solid #ddd; border-radius: 10px; font-size: 14px; transition: 0.2s; box-sizing: border-box; }
    .form-control:focus { border-color: #00B98D; outline: none; box-shadow: 0 0 0 3px rgba(0, 185, 141, 0.1); }
    .form-control[readonly] { background: #f8f9fa; color: #777; pointer-events: none; }
    
    /* 결제 금액 요약 */
    .summary-box { border-top: 2px dashed #eee; padding-top: 25px; margin-top: 30px; }
    .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px; color: #666; }
    .summary-row.free .val { color: #3182F6; font-weight: 600; }
    .summary-row.total { font-size: 18px; font-weight: 700; color: #333; margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; align-items: center; }
    .summary-row.total .val { color: #00B98D; font-size: 24px; }
    
    /* 결제 버튼 */
    .btn-pay { width: 100%; padding: 16px; background: #00B98D; color: #fff; border: none; border-radius: 12px; font-size: 16px; font-weight: 700; cursor: pointer; transition: 0.3s; margin-top: 30px; box-shadow: 0 4px 12px rgba(0, 185, 141, 0.2); }
    .btn-pay:hover { background: #00A37A; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(0, 185, 141, 0.3); }
    .btn-pay:active { transform: translateY(0); }
    .btn-pay:disabled { background: #ccc; cursor: not-allowed; transform: none; box-shadow: none; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="checkout-wrapper">
    <h2 class="page-title">안전결제</h2>

    <div class="product-box">
        <img src="${pageContext.request.contextPath}${product.imgUrl}" onerror="this.src='${pageContext.request.contextPath}/dist/images/noimage.png'">
        <div class="product-info">
            <h4>${product.title}</h4>
            <p><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</p>
        </div>
    </div>

    <form id="escrowForm">
        <input type="hidden" name="productIdx" value="${product.productIdx}">
        <input type="hidden" name="sellerIdx" value="${product.userIdx}">
        <input type="hidden" name="tradePrice" value="${product.price}">
        <input type="hidden" name="safetyFee" value="${safetyFee}">
        <input type="hidden" name="totalUsedPoint" value="${product.price + product.shippingFee}">

        <c:if test="${product.shippingFee > 0}">
            <h3 class="section-title">배송/결제 방식</h3>
            <div class="radio-group">
                <label class="radio-label">
                    <input type="radio" name="shippingType" value="prepaid" onchange="updateTotal()" checked>
                    <span>선불 (배송비 포함)</span>
                </label>
                <label class="radio-label">
                    <input type="radio" name="shippingType" value="cod" onchange="updateTotal()">
                    <span>착불 (수령 시 지불)</span>
                </label>
            </div>
        </c:if>

        <h3 class="section-title">배송지 정보</h3>
        <div class="form-group">
            <label class="form-label">수령인 이름</label>
            <input type="text" name="recipientName" id="recipientName" class="form-control" placeholder="이름을 입력하세요">
        </div>
        
        <div class="form-group">
            <label class="form-label">연락처</label>
            <input type="text" name="recipientPhone" id="recipientPhone" class="form-control" placeholder="010-0000-0000">
        </div>
    
        <div class="form-group">
            <label class="form-label">배송지 주소</label>
            <input type="text" id="baseAddress" class="form-control" value="${userAddress}" readonly style="margin-bottom: 8px;">
            <input type="text" id="detailAddress" class="form-control" placeholder="상세 주소를 입력하세요">
            <input type="hidden" name="shippingAddress" id="shippingAddress">
        </div>

        <div class="summary-box">
		    <div class="summary-row">
		        <span>상품 금액</span>
		        <span><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</span>
		    </div>
		    <div class="summary-row">
		        <span>배송비</span>
		        <span id="displayShippingFee"><fmt:formatNumber value="${product.shippingFee}" pattern="#,###"/>원</span>
		    </div>
		    <div class="summary-row free">
		        <span>안전결제 수수료</span>
		        <span class="val">무료</span>
		    </div>
		    <div class="summary-row total">
		        <span>총 결제 포인트</span>
		        <span class="val" id="displayTotal"><fmt:formatNumber value="${product.price + product.shippingFee}" pattern="#,###"/> P</span>
		    </div>
		</div>

        <button type="button" class="btn-pay" onclick="requestEscrowPayment()">
            <span id="btnPriceDisplay"><fmt:formatNumber value="${product.price + product.shippingFee}" pattern="#,###"/></span>원 결제하기
        </button>
    </form>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const productPrice = ${product.price};
    const shippingFee = ${empty product.shippingFee ? 0 : product.shippingFee};

    function updateTotal() {
        let currentShipping = shippingFee;
        let currentTotal = productPrice + shippingFee;

        const shippingTypeElement = document.querySelector('input[name="shippingType"]:checked');
        if (shippingTypeElement && shippingTypeElement.value === 'cod') {
            currentShipping = 0;
            currentTotal = productPrice;
        }

        document.getElementById('displayShippingFee').innerText = currentShipping.toLocaleString() + '원';
        document.getElementById('displayTotal').innerText = currentTotal.toLocaleString() + ' P';
        
        document.querySelector('input[name="totalUsedPoint"]').value = currentTotal;

        const payBtn = document.querySelector('.btn-pay');
        if (!payBtn.disabled) {
            document.getElementById('btnPriceDisplay').innerText = currentTotal.toLocaleString();
        }
    }

    function requestEscrowPayment() {
        if(!document.getElementById('recipientName').value.trim()) {
            alert('수령인 이름을 입력해주세요.');
            document.getElementById('recipientName').focus();
            return;
        }
        if(!document.getElementById('recipientPhone').value.trim()) {
            alert('연락처를 입력해주세요.');
            document.getElementById('recipientPhone').focus();
            return;
        }
        if(!document.getElementById('detailAddress').value.trim()) {
            alert('상세 주소를 입력해주세요.');
            document.getElementById('detailAddress').focus();
            return;
        }

        document.getElementById('shippingAddress').value = document.getElementById('baseAddress').value + " " + document.getElementById('detailAddress').value.trim();
        
        const form = document.getElementById('escrowForm');
        const formData = new FormData(form);
        const params = new URLSearchParams(formData);

        const payBtn = document.querySelector('.btn-pay');
        payBtn.disabled = true;
        payBtn.innerText = '결제 진행 중...';
        
        fetch('${pageContext.request.contextPath}/escrow/pay', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        })
        .then(response => response.json())
        .then(data => {
            if (data.state === 'true') {
                alert(data.msg); 
                location.href = '${pageContext.request.contextPath}/trade/article?productIdx=${product.productIdx}'; 
            } else {
                alert(data.msg); 
                payBtn.disabled = false;
                
                let currentTotal = document.querySelector('input[name="totalUsedPoint"]').value;
                payBtn.innerHTML = `<span id="btnPriceDisplay">\${parseInt(currentTotal).toLocaleString()}</span>원 결제하기`;
                
                if (data.msg.includes("로그인")) {
                    location.href = '${pageContext.request.contextPath}/member/login';
                }
            }
        })
        .catch(error => {
            console.error('결제 오류:', error);
            alert('결제 처리 중 문제가 발생했습니다. 다시 시도해 주세요.');
            payBtn.disabled = false;
            let currentTotal = document.querySelector('input[name="totalUsedPoint"]').value;
            payBtn.innerHTML = `<span id="btnPriceDisplay">\${parseInt(currentTotal).toLocaleString()}</span>원 결제하기`;
        });
    }
</script>
</body>
</html>