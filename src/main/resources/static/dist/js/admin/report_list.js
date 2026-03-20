(function () {
    'use strict';

    var currentReportIdx = null;

    var overlay      = document.getElementById('detailOverlay');
    var detailClose  = document.getElementById('detailClose');
    var detailCancel = document.getElementById('detailCancel');

    var dDomainType     = document.getElementById('dDomainType');
    var dReportType     = document.getElementById('dReportType');
    var dReporter       = document.getElementById('dReporter');
    var dReportedUser   = document.getElementById('dReportedUser');
    var dReportDate     = document.getElementById('dReportDate');
    var dProcessStatus  = document.getElementById('dProcessStatus');
    var dReportContent  = document.getElementById('dReportContent');
    var dAdminMemo      = document.getElementById('dAdminMemo');
    var detailFooter    = document.getElementById('detailFooter');

    var DOMAIN_LABEL = { TRADE: '중고거래', COMMUNITY: '커뮤니티', COMMUNITY_REPLY: '커뮤니티 댓글', ALBA: '알바구인', CHAT: '채팅', USER: '사용자' };
    var STATUS_LABEL = { 0: '미처리', 1: '처리완료', 2: '반려' };
    var STATUS_CLASS = { 0: 'tag-red', 1: 'tag-green', 2: 'tag-gray' };

    function openDetail(reportIdx) {
        currentReportIdx = reportIdx;

        fetch(CTX + '/admin/report/detail?reportIdx=' + reportIdx)
            .then(function (r) { return r.json(); })
            .then(function (d) {
                var domainLabel = DOMAIN_LABEL[d.domainType] || d.domainType;
                var statusLabel = STATUS_LABEL[d.processStatus] || '-';
                var statusClass = STATUS_CLASS[d.processStatus] || 'tag-gray';

                dDomainType.innerHTML    = '<span class="tag ' + domainTagClass(d.domainType) + '">' + domainLabel + '</span>';
                var titleEl = document.getElementById('dModalTitle');
                if (titleEl) titleEl.textContent = domainLabel + ' 신고 상세';
                dReportType.textContent  = d.reportType || '-';
                dReporter.textContent    = (d.reporterName || '-') + ' (' + (d.reporterId || '-') + ')';
                dReportedUser.textContent = (d.reportedUserName || '-') + ' (' + (d.reportedUserId || '-') + ')';
                dReportDate.textContent  = d.reportDate ? d.reportDate.substring(0, 16) : '-';
                dProcessStatus.innerHTML = '<span class="tag ' + statusClass + '">' + statusLabel + '</span>';
                dReportContent.textContent = d.reportContent || '내용 없음';
                dAdminMemo.value         = d.adminMemo || '';

                if (d.processStatus == 0) {
                    detailFooter.style.display = '';
                } else {
                    detailFooter.style.display = 'none';
                }

                overlay.classList.add('show');
            })
            .catch(function () {
                showToast('상세 정보를 불러오는데 실패했습니다.', 'error');
            });
    }
    window.openDetail = openDetail;

    function domainTagClass(type) {
        if (type === 'TRADE')            return 'tag-blue';
        if (type === 'COMMUNITY')        return 'tag-purple';
        if (type === 'COMMUNITY_REPLY')  return 'tag-purple';
        if (type === 'ALBA')             return 'tag-green';
        if (type === 'CHAT')             return 'tag-blue';
        return 'tag-gray';
    }

    function submitProcess(status) {
        if (!currentReportIdx) return;

        var statusText = status === 1 ? '처리 완료' : '반려';
        var memo = dAdminMemo.value.trim();

        showConfirm({
            type  : status === 1 ? 'info' : 'warning',
            title : '신고 ' + statusText,
            desc  : '이 신고를 [' + statusText + '] 처리하시겠습니까?',
            okText: '확인',
            onOk  : function () {
                var targetIdx = currentReportIdx;
                closeModal();
                fetch(CTX + '/admin/report/process', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        reportIdx     : targetIdx,
                        processStatus : status,
                        adminMemo     : memo
                    })
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        showToast('신고가 ' + statusText + ' 처리되었습니다.', 'success');
                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + (d.msg || '처리에 실패했습니다.'), 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    }
    window.submitProcess = submitProcess;

    function closeModal() {
        overlay.classList.remove('show');
        currentReportIdx = null;
        if (detailFooter) detailFooter.style.display = '';
        var btnProcess = document.getElementById('btnProcess');
        var btnReject  = document.getElementById('btnReject');
        if (btnProcess) btnProcess.style.display = '';
        if (btnReject)  btnReject.style.display  = '';
    }

    detailClose.addEventListener('click',  closeModal);
    detailCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeModal(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeModal();
    });

})();