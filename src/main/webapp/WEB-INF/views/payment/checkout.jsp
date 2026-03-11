<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>안전결제 | BATON</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<style>
    .checkout-container { max-width: 600px; margin: 50px auto; padding: 30px; background: #fff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
    .checkout-title { font-size: 24px; font-weight: 700; margin-bottom: 25px; color: #333; }
    
    .product-summary { display: flex; align-items: center; padding: 20px; background: #f8f9fa; border-radius: 12px; margin-bottom: 30px; }
    .product-summary img { width: 70px; height: 70px; border-radius: 8px; object-fit: cover; margin-right: 15px; }
    .product-info h4 { margin: 0 0 5px 0; font-size: 16px; color: #333; }
    .product-info p { margin: 0; font-weight: bold; font-size: 18px; color: #3182F6; }

    .form-group { margin-bottom: 20px; }
    .form-group label { display: block; font-size: 14px; font-weight: 600; color: #555; margin-bottom: 8px; }
    .form-group input { width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; }
    .form-group input:focus { border-color: #3182F6; outline: none; }

    .payment-summary { margin-top: 30px; border-top: 2px solid #eee; padding-top: 20px; }
    .summary-row { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 15px; color: #555; }
    .summary-row.total { font-size: 18px; font-weight: 700; color: #333; margin-top: 15px; padding-top: 15px; border-top: 1px dashed #ddd; }
    .summary-row.total .price { color: #3182F6; }

    .btn-pay { width: 100%; padding: 15px; background: #3182F6; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; margin-top: 20px; transition: 0.2s; }
    .btn-pay:hover { background: #1b64da; }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div class="checkout-container">
    <h2 class="checkout-title">안전결제</h2>

    <div class="product-summary">
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
            <h3>배송/결제 방식</h3>
            <div class="form-group" style="display: flex; gap: 20px;">
                <label style="display: flex; align-items: center; gap: 5px;">
                    <input type="radio" name="shippingType" value="prepaid" onchange="updateTotal()" checked>
                    선불 (배송비 포함 결제)
                </label>
                <label style="display: flex; align-items: center; gap: 5px;">
                    <input type="radio" name="shippingType" value="cod" onchange="updateTotal()">
                    착불 (배송비는 수령 시 지불)
                </label>
            </div>
        </c:if>

        <h3>배송지 정보</h3>
    
        <div class="form-group">
            <label>수령인 이름</label>
            <input type="text" name="recipientName" id="recipientName" placeholder="이름을 입력하세요">
        </div>
        
        <div class="form-group">
            <label>연락처</label>
            <input type="text" name="recipientPhone" id="recipientPhone" placeholder="010-0000-0000">
        </div>
    
        <div class="form-group">
            <label>배송지 주소</label>
            <input type="text" id="baseAddress" value="${userAddress}" readonly style="background-color: #f1f3f5; margin-bottom: 8px; color: #555; pointer-events: none;">
            <input type="text" id="detailAddress" placeholder="상세 주소를 입력하세요">
            <input type="hidden" name="shippingAddress" id="shippingAddress">
        </div>

        <div class="payment-summary">
		    <div class="summary-row">
		        <span>상품 금액</span>
		        <span><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</span>
		    </div>
		    <div class="summary-row">
		        <span>배송비</span>
		        <span id="displayShippingFee"><fmt:formatNumber value="${product.shippingFee}" pattern="#,###"/>원</span>
		    </div>
		    <div class="summary-row">
		        <span>안전결제 수수료</span>
		        <span style="color: #3182F6; font-weight: bold;">무료</span>
		    </div>
		    <div class="summary-row total">
		        <span>총 결제 포인트</span>
		        <span class="price" id="displayTotal"><fmt:formatNumber value="${product.price + product.shippingFee}" pattern="#,###"/> P</span>
		    </div>
		</div>

        <button type="button" class="btn-pay" onclick="requestEscrowPayment()">
            <fmt:formatNumber value="${product.price + product.shippingFee}" pattern="#,###"/>원 결제하기
        </button>
    </form>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<script>
    const productPrice = ${product.price};
    const shippingFee = ${product.shippingFee};

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
            payBtn.innerText = currentTotal.toLocaleString() + '원 결제하기';
        }
    }

    function requestEscrowPayment() {
        if(!document.getElementById('recipientName').value) {
            alert('수령인 이름을 입력해주세요.');
            return;
        }
        if(!document.getElementById('recipientPhone').value) {
            alert('연락처를 입력해주세요.');
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
                location.href = '${pageContext.request.contextPath}/'; 
            } else {
                alert(data.msg); 
                payBtn.disabled = false;
                
                let currentTotal = document.querySelector('input[name="totalUsedPoint"]').value;
                payBtn.innerText = parseInt(currentTotal).toLocaleString() + '원 결제하기';
                
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
            payBtn.innerText = parseInt(currentTotal).toLocaleString() + '원 결제하기';
        });
    }
</script>
</body>
</html>