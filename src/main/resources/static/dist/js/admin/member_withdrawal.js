(function () {
    'use strict';

    var pendingWithdrawIdx = null;
    var pendingUserIdx     = null;
    var pendingStatus      = null;

    var overlay      = document.getElementById('reviewOverlay');
    var reviewClose  = document.getElementById('reviewClose');
    var reviewCancel = document.getElementById('reviewCancel');

    function closeModal() {
        overlay.classList.remove('show');
        pendingWithdrawIdx = null;
        pendingUserIdx     = null;
        pendingStatus      = null;
    }

    reviewClose.addEventListener('click',  closeModal);
    reviewCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) {
        if (e.target === this) closeModal();
    });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeModal();
    });

    function openReviewModal(withdrawIdx, userIdx, nickname, userId, reason, status) {
        pendingWithdrawIdx = withdrawIdx;
        pendingUserIdx     = userIdx;
        pendingStatus      = status || 'PENDING';

        document.getElementById('rvAvt').textContent  = nickname ? nickname.charAt(0) : '?';
        document.getElementById('rvName').textContent = nickname || '-';
        document.getElementById('rvId').textContent   = '@' + (userId || '-');

        renderFooter(pendingStatus);

        document.getElementById('rvBody').innerHTML =
            '<div class="wd-loading"><i class="ri-loader-4-line"></i>정보를 불러오는 중...</div>';

        overlay.classList.add('show');

        fetch(CTX + '/admin/member/withdrawal/detail?userIdx=' + userIdx)
            .then(function (r) { return r.json(); })
            .then(function (d) { renderBody(d, reason); })
            .catch(function () {
                document.getElementById('rvBody').innerHTML =
                    '<div class="wd-loading"><i class="ri-error-warning-line"></i>정보를 불러오지 못했습니다.</div>';
            });
    }
    window.openReviewModal = openReviewModal;

    function renderFooter(status) {
        var foot = document.getElementById('rvFoot');
        var html = '<button class="btn-pill btn-light" id="footClose">닫기</button>';

        if (status === 'PENDING') {
            html += '<button class="btn-pill" style="background:var(--base-bg);color:var(--text-sub);border:1.5px solid var(--border-color);" id="btnReject">'
                  + '<i class="ri-close-circle-line"></i> 반려</button>';
            html += '<button class="btn-pill" style="background:var(--color-red);color:white;padding:12px 24px;" id="btnApprove">'
                  + '<i class="ri-check-line"></i> 탈퇴 승인</button>';
        }

        foot.innerHTML = html;
        document.getElementById('footClose').addEventListener('click', closeModal);

        if (status === 'PENDING') {
            document.getElementById('btnApprove').addEventListener('click', doApprove);
            document.getElementById('btnReject').addEventListener('click',  doReject);
        }
    }

    function doApprove() {
        var name = document.getElementById('rvName').textContent;
        showConfirm({
            type  : 'danger',
            title : '탈퇴 승인',
            desc  : name + ' 님의 탈퇴를 최종 승인합니다.\n이 작업은 되돌릴 수 없습니다.',
            okText: '탈퇴 승인',
            onOk  : function () {
                var targetWithdrawIdx = pendingWithdrawIdx;
                var targetUserIdx     = pendingUserIdx;
                closeModal();
                fetch(CTX + '/admin/member/withdrawal/approve', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify({ withdrawIdx: targetWithdrawIdx, userIdx: targetUserIdx })
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        showToast('탈퇴 처리가 완료되었습니다.', 'success');
                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + d.msg, 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    }

    function doReject() {
        var name = document.getElementById('rvName').textContent;
        showConfirm({
            type  : 'warning',
            title : '탈퇴 반려',
            desc  : name + ' 님의 탈퇴 요청을 반려합니다.\n계정 상태가 정상으로 복구됩니다.',
            okText: '반려',
            onOk  : function () {
                var targetWithdrawIdx = pendingWithdrawIdx;
                var targetUserIdx     = pendingUserIdx;
                closeModal();
                fetch(CTX + '/admin/member/withdrawal/reject', {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body:    JSON.stringify({ withdrawIdx: targetWithdrawIdx, userIdx: targetUserIdx })
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        showToast('탈퇴 요청이 반려되었습니다.', 'info');
                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + d.msg, 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    }

    function renderBody(data, reason) {
        var trades     = data.trades  || [];
        var reports    = data.reports || [];
        var batonpoint = data.batonpoint || 0;
        var html       = '';

        if (batonpoint > 0) {
            html += '<div style="margin-bottom:14px;background:#FFF7ED;border:1.5px solid #FED7AA;border-radius:14px;padding:14px 18px;display:flex;align-items:flex-start;gap:12px;">';
            html += '<div style="width:32px;height:32px;border-radius:10px;background:#FED7AA;color:#C2410C;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0;"><i class="ri-coins-line"></i></div>';
            html += '<div><div style="font-size:13px;font-weight:800;color:#C2410C;margin-bottom:3px;">⚠ 잔여 포인트 있음 — 탈퇴 불가</div>';
            html += '<div style="font-size:12px;color:#92400E;">잔여 바톤 포인트 <strong style="font-size:14px;">' + Number(batonpoint).toLocaleString() + ' P</strong> 가 남아 있습니다.<br>탈퇴 전 포인트를 사용하거나 환불 처리 후 승인해 주세요.</div>';
            html += '</div></div>';
        }

        html += '<div>';
        html += '<div class="wd-sec-title"><i class="ri-file-text-line"></i> 탈퇴 사유</div>';
        html += '<div class="wd-reason-box">'
              + (reason && reason.trim() ? esc(reason) : '<span style="color:var(--text-light);">입력된 사유 없음</span>')
              + '</div>';
        html += '</div>';

        html += '<div>';
        html += '<div class="wd-sec-title"><i class="ri-shopping-bag-2-line"></i> 진행 중인 거래'
              + '<span class="wd-cnt ' + (trades.length > 0 ? 'has' : 'none') + '">' + trades.length + '건</span></div>';

        if (trades.length === 0) {
            html += '<div class="wd-empty">진행 중인 거래가 없습니다.</div>';
        } else {
            trades.forEach(function (t) {
                var isBuyer = String(t.buyerIdx) === String(pendingUserIdx);
                var role    = isBuyer ? '구매자' : '판매자';
                var partner = isBuyer
                    ? (t.sellerNickname || t.sellerId || '-')
                    : (t.buyerNickname  || t.buyerId  || '-');

                html += '<div class="wd-trade-item">'
                      + '<div class="wd-trade-icon"><i class="ri-exchange-2-line"></i></div>'
                      + '<div style="flex:1;min-width:0;">'
                      + '<div class="wd-trade-title">' + esc(t.productTitle || '상품명 없음') + '</div>'
                      + '<div class="wd-trade-sub">' + role + ' · 상대방: ' + esc(partner)
                      + ' · ' + (t.tradeDate || '-') + '</div>'
                      + '</div>'
                      + '<span class="wd-trade-badge">' + esc(t.tradeStatus || '-') + '</span>'
                      + '</div>';
            });
        }
        html += '</div>';

        html += '<div>';
        html += '<div class="wd-sec-title"><i class="ri-alarm-warning-line"></i> 미처리 신고 내역'
              + '<span class="wd-cnt ' + (reports.length > 0 ? 'has' : 'none') + '">' + reports.length + '건</span></div>';

        if (reports.length === 0) {
            html += '<div class="wd-empty">처리되지 않은 신고가 없습니다.</div>';
        } else {
            reports.forEach(function (r) {
                html += '<div class="wd-report-item">'
                      + '<div class="wd-report-icon"><i class="ri-flag-2-line"></i></div>'
                      + '<div>'
                      + '<div class="wd-report-type">' + esc(r.reportType || '-') + ' · ' + esc(r.domainType || '-') + '</div>'
                      + '<div class="wd-report-content">' + esc(r.reportContent || '내용 없음') + '</div>'
                      + '<div class="wd-report-meta">신고자: ' + esc(r.reporterNickname || r.reporterId || '-') + ' · ' + (r.reportDate || '-') + '</div>'
                      + '</div>'
                      + '</div>';
            });
        }
        html += '</div>';

        document.getElementById('rvBody').innerHTML = html;

        var approveBtn = document.getElementById('btnApprove');
        if (approveBtn) {
            if (batonpoint > 0) {
                approveBtn.disabled = true;
                approveBtn.style.background = '#E2E8F0';
                approveBtn.style.color = '#94A3B8';
                approveBtn.style.cursor = 'not-allowed';
                approveBtn.style.boxShadow = 'none';
                approveBtn.title = '잔여 포인트 소진 후 승인 가능';
                approveBtn.removeEventListener('click', doApprove);
            }
        }
    }

    function esc(str) {
        return String(str)
            .replace(/&/g,  '&amp;')
            .replace(/</g,  '&lt;')
            .replace(/>/g,  '&gt;')
            .replace(/"/g, '&quot;');
    }

})();