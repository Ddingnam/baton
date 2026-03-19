<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>BATON | 회원 탈퇴</title>
<meta name="_csrf"        content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
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

                <c:if test="${alreadyRequested}">
                    <div class="wd-already">
                        <i class="ri-time-line"></i>
                        <p>탈퇴 요청이 접수되었습니다.</p>
                        <small>관리자 검토 후 처리됩니다.<br>승인 전까지 로그인이 제한됩니다.</small>
                    </div>
                </c:if>

                <c:if test="${not alreadyRequested}">

                    <c:if test="${activeTrades > 0}">
                        <div class="wd-blocker">
                            <i class="ri-shopping-bag-2-line"></i>
                            <div class="wd-blocker-text">
                                <strong>진행 중인 거래가 있습니다.</strong>
                                현재 <b>${activeTrades}건</b>의 거래가 완료되지 않았습니다.
                                모든 거래를 완료하거나 취소한 후 탈퇴를 요청할 수 있습니다.
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${pendingReports > 0}">
                        <div class="wd-blocker">
                            <i class="ri-alarm-warning-line"></i>
                            <div class="wd-blocker-text">
                                <strong>처리되지 않은 신고 내역이 있습니다.</strong>
                                <b>${pendingReports}건</b>의 신고가 검토 중입니다.
                                모든 신고 처리가 완료된 후 탈퇴를 요청할 수 있습니다.
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
                <c:if test="${not alreadyRequested}">
                    <button type="button" class="wd-btn-submit" id="btnWithdrawSubmit"
                            ${activeTrades > 0 || pendingReports > 0 ? 'disabled' : ''}>
                        <i class="ri-logout-circle-r-line"></i> 탈퇴 요청하기
                    </button>
                </c:if>
            </div>

        </div>
    </div>

</div>

<div class="wd-toast" id="wdToast"></div>

<script>
var CTX         = '${pageContext.request.contextPath}';
var CSRF_TOKEN  = document.querySelector('meta[name="_csrf"]').content;
var CSRF_HEADER = document.querySelector('meta[name="_csrf_header"]').content;

function showToast(msg, type) {
    var t = document.getElementById('wdToast');
    t.textContent = msg;
    t.className   = 'wd-toast ' + (type || '');
    t.classList.add('show');
    setTimeout(function () { t.classList.remove('show'); }, 3000);
}

var btn = document.getElementById('btnWithdrawSubmit');
if (btn) {
    btn.addEventListener('click', function () {
        if (btn.disabled) return;
        if (!confirm('정말 탈퇴를 요청하시겠습니까?\n요청 후 관리자 승인 전까지 로그인이 제한됩니다.')) return;

        var reason = document.getElementById('withdrawReason').value.trim();
        btn.disabled = true;
        btn.innerHTML = '<i class="ri-loader-4-line"></i> 처리 중...';

        var headers = { 'Content-Type': 'application/json' };
        headers[CSRF_HEADER] = CSRF_TOKEN;

        fetch(CTX + '/mypage/withdraw/request', {
            method:  'POST',
            headers: headers,
            body:    JSON.stringify({ reason: reason })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) {
                showToast('탈퇴 요청이 접수되었습니다. 관리자 검토 후 처리됩니다.', 'success');
                setTimeout(function () {
                    window.location.href = CTX + '/member/logout';
                }, 2000);
            } else {
                showToast(d.msg || '오류가 발생했습니다.', 'error');
                btn.disabled = false;
                btn.innerHTML = '<i class="ri-logout-circle-r-line"></i> 탈퇴 요청하기';
            }
        })
        .catch(function () {
            showToast('요청 중 오류가 발생했습니다.', 'error');
            btn.disabled = false;
            btn.innerHTML = '<i class="ri-logout-circle-r-line"></i> 탈퇴 요청하기';
        });
    });
}
</script>

</body>
</html>
