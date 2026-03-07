<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/payment/payment_modal.css">

<input type="hidden" id="ctxPath" value="${pageContext.request.contextPath}">
<input type="hidden" id="userEmail" value="${sessionScope.member.email}">
<input type="hidden" id="userName" value="${sessionScope.member.name}">
<input type="hidden" id="userTel" value="">
<input type="hidden" id="userIdx" value="${sessionScope.member.userIdx}">

<div id="chargeModalOverlay" class="baton-modal-overlay">
    <div id="chargeStep1" class="baton-modal-content">
        <h3>포인트 충전</h3>
        <p>충전하실 금액을 입력해 주세요.</p>
        <div class="charge-input-wrap">
            <input type="number" id="customChargeInput" placeholder="최소 1000">
            <span class="unit">원</span>
            <div class="spinners">
                <button type="button" onclick="changeAmount(1000)"><i class="ri-arrow-up-s-fill"></i></button>
                <button type="button" onclick="changeAmount(-1000)"><i class="ri-arrow-down-s-fill"></i></button>
            </div>
        </div>
        <div class="modal-btn-wrap">
            <button class="btn-modal-cancel" onclick="closeChargeModal()">취소</button>
            <button class="btn-modal-next" onclick="openConfirmStep()">다음</button>
        </div>
    </div>

    <div id="chargeStep2" class="baton-modal-content" style="display:none;">
        <h3>결제 확인</h3>
        <p><strong id="confirmAmountText" style="color:#111; font-size:18px;">0</strong>원을 결제하시겠습니까?</p>
        <div class="fee-notice">
            결제 수수료 2%가 차감되어<br>
            <strong id="saveAmountText" class="theme-text">0</strong>P가 최종 적립됩니다.
        </div>
        <div class="modal-btn-wrap">
            <button class="btn-modal-cancel" onclick="openChargeModal()">뒤로</button>
            <button class="btn-modal-next" onclick="executeBatonPayment()">결제하기</button>
        </div>
    </div>

    <div id="chargeStepAlert" class="baton-modal-content" style="display:none;">
        <div id="alertIconBox" style="font-size: 48px; margin-bottom: 12px;"></div>
        <h3 id="alertTitle">알림</h3>
        <p id="alertMessage" style="margin-bottom: 24px; white-space: pre-wrap; line-height: 1.5; color: #444; font-size: 15px;"></p>
        <div class="modal-btn-wrap">
            <button class="btn-modal-next" id="alertConfirmBtn">확인</button>
        </div>
    </div>
</div>

<input type="hidden" id="chargeAmount" value="">