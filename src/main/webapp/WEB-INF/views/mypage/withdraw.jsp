<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 회원 탈퇴</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
<link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main/main.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_left.css?v=final">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage/mypage_withdraw.css?v=final">
</head>
<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<div id="baton-layout-container" class="mypage-mode">

    <jsp:include page="/WEB-INF/views/mypage/left.jsp"/>

    <div class="mp-withdraw-wrapper">
        <div class="wd-card">

            <div class="wd-header">
                <div class="wd-header-icon"><i class="ri-logout-circle-r-line"></i></div>
                <div>
                    <div class="wd-header-title">회원 탈퇴 요청</div>
                    <div class="wd-header-desc">탈퇴 요청 후 관리자 승인이 완료되면 계정이 삭제됩니다.</div>
                </div>
            </div>

            <div class="wd-body">

                <c:if test="${blockedByRole}">
                    <div class="wd-role-blocked">
                        <i class="ri-shield-user-line"></i>
                        <p>탈퇴 요청이 불가한 계정입니다.</p>
                        <small>관리자·직원 계정은 자체 탈퇴 요청이 제한됩니다.<br>탈퇴가 필요한 경우 운영팀에 별도로 문의해주세요.</small>
                    </div>
                </c:if>

                <c:if test="${alreadyRequested}">
                    <div class="wd-already">
                        <i class="ri-time-line"></i>
                        <p>탈퇴 요청이 접수되었습니다.</p>
                        <small>관리자 검토 후 처리됩니다.<br>승인 전까지 로그인이 제한됩니다.</small>
                    </div>
                </c:if>

                <c:if test="${not blockedByRole and not alreadyRequested}">

                    <c:if test="${activeTrades > 0}">
                        <div class="wd-info">
                            <i class="ri-shopping-bag-2-line"></i>
                            <div class="wd-info-text">
                                <strong>진행 중인 거래가 ${activeTrades}건 있습니다.</strong>
                                탈퇴 요청은 가능하지만, 관리자 검토 시 거래 완료 후 승인될 수 있습니다.
                            </div>
                        </div>
                    </c:if>

                    <div class="wd-notice">
                        <div class="wd-notice-title">
                            <i class="ri-information-line"></i> 탈퇴 전 꼭 확인하세요
                        </div>
                        <ul>
                            <li>탈퇴 요청 후 관리자 승인이 완료되면 계정이 영구 삭제됩니다.</li>
                            <li>삭제된 계정과 모든 데이터는 복구할 수 없습니다.</li>
                            <li>보유 중인 포인트 및 바톤 점수는 모두 소멸됩니다.</li>
                            <li>탈퇴 요청 후 승인 전까지 로그인이 제한됩니다.</li>
                        </ul>
                    </div>

                    <div class="wd-field">
                        <label for="withdrawReason">탈퇴 사유 <span>(선택)</span></label>
                        <textarea id="withdrawReason" class="wd-textarea"
                                  placeholder="탈퇴 사유를 입력해주세요."></textarea>
                    </div>

                </c:if>

            </div>

            <div class="wd-footer">
                <a href="${pageContext.request.contextPath}/mypage/main" class="wd-btn-cancel">
                    <i class="ri-arrow-left-line"></i> 돌아가기
                </a>
                <c:if test="${not blockedByRole and not alreadyRequested}">
                    <button type="button" class="wd-btn-submit" id="btnWithdrawSubmit">
                        <i class="ri-logout-circle-r-line"></i> 탈퇴 요청하기
                    </button>
                </c:if>
            </div>

        </div>
    </div>

</div>

<div class="wd-confirm-backdrop" id="wdConfirmBackdrop">
    <div class="wd-confirm-box">
        <div class="wd-confirm-icon"><i class="ri-logout-circle-r-line"></i></div>
        <p class="wd-confirm-title">탈퇴 요청</p>
        <p class="wd-confirm-desc">정말 탈퇴를 요청하시겠습니까?&#10;요청 후 관리자 승인 전까지 로그인이 제한됩니다.</p>
        <div class="wd-confirm-btns">
            <button class="wd-confirm-cancel" id="wdConfirmCancel">취소</button>
            <button class="wd-confirm-ok"     id="wdConfirmOk">탈퇴 요청</button>
        </div>
    </div>
</div>

<script>
var CTX = '${pageContext.request.contextPath}';

var backdrop         = document.getElementById('wdConfirmBackdrop');
var confirmCancelBtn = document.getElementById('wdConfirmCancel');
var confirmOkBtn     = document.getElementById('wdConfirmOk');

function openConfirm(onOk) {
    backdrop.classList.add('show');
    confirmOkBtn.onclick = function () {
        closeConfirm();
        onOk();
    };
}

function closeConfirm() {
    backdrop.classList.remove('show');
}

if (confirmCancelBtn) {
    confirmCancelBtn.addEventListener('click', closeConfirm);
}
if (backdrop) {
    backdrop.addEventListener('click', function (e) {
        if (e.target === this) closeConfirm();
    });
}

var btn = document.getElementById('btnWithdrawSubmit');
if (btn) {
    btn.addEventListener('click', function () {
        openConfirm(function () {
            var reason = document.getElementById('withdrawReason').value.trim();
            btn.disabled = true;
            btn.innerHTML = '<i class="ri-loader-4-line"></i> 처리 중...';

            fetch(CTX + '/mypage/withdraw/request', {
                method:  'POST',
                headers: { 'Content-Type': 'application/json' },
                body:    JSON.stringify({ reason: reason })
            })
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (d.success) {
                    if (typeof showBatonToast === 'function') {
                        showBatonToast('탈퇴 요청이 접수되었습니다. 관리자 검토 후 처리됩니다.');
                    }
                    setTimeout(function () {
                        window.location.href = CTX + '/member/logout';
                    }, 2000);
                } else {
                    if (typeof showBatonToast === 'function') {
                        showBatonToast(d.msg || '오류가 발생했습니다.');
                    }
                    btn.disabled = false;
                    btn.innerHTML = '<i class="ri-logout-circle-r-line"></i> 탈퇴 요청하기';
                }
            })
            .catch(function () {
                if (typeof showBatonToast === 'function') {
                    showBatonToast('요청 중 오류가 발생했습니다.');
                }
                btn.disabled = false;
                btn.innerHTML = '<i class="ri-logout-circle-r-line"></i> 탈퇴 요청하기';
            });
        });
    });
}
</script>

</body>
</html>
