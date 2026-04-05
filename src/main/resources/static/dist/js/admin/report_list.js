(function () {
    'use strict';

    var currentReportIdx     = null;
    var currentReportedUser  = '';

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

    var DOMAIN_LABEL = { TRADE: '중고거래', COMMUNITY: '커뮤니티', COMMUNITY_REPLY: '커뮤니티 댓글', CREW: '동네모임', ALBA: '알바구인', CHAT: '채팅', USER: '사용자' };
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

                currentReportedUser = (d.reportedUserName || '') + ' (' + (d.reportedUserId || '') + ')';

                dDomainType.innerHTML    = '<span class="tag ' + domainTagClass(d.domainType) + '">' + domainLabel + '</span>';
                var titleEl = document.getElementById('dModalTitle');
                if (titleEl) titleEl.textContent = domainLabel + ' 신고 상세';
                dReportType.textContent   = d.reportType || '-';
                dReporter.textContent     = (d.reporterName || '-') + ' (' + (d.reporterId || '-') + ')';
                dReportedUser.textContent = currentReportedUser;
                dReportDate.textContent   = d.reportDate ? d.reportDate.substring(0, 16) : '-';
                dProcessStatus.innerHTML  = '<span class="tag ' + statusClass + '">' + statusLabel + '</span>';
                dReportContent.textContent = d.reportContent || '내용 없음';
                dAdminMemo.value          = d.adminMemo || '';

                // 제재 옵션 초기화
                resetSanctionUI();

                var toggleRow = document.getElementById('sanctionToggleRow');
                if (d.processStatus == 0) {
                    detailFooter.style.display = '';
                    if (toggleRow) toggleRow.style.display = '';
                } else {
                    detailFooter.style.display = 'none';
                    if (toggleRow) toggleRow.style.display = 'none';
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

    // ── 제재 UI 초기화 ─────────────────────────────────────────────
    function resetSanctionUI() {
        var sanctionSection = document.getElementById('sanctionSection');
        if (sanctionSection) {
            sanctionSection.style.display = 'none';
        }
        var chk = document.getElementById('chkSanction');
        if (chk) chk.checked = false;

        var track = document.getElementById('sanctionToggleTrack');
        if (track) track.classList.remove('on');

        var typeSelect = document.getElementById('sanctionTypeSelect');
        if (typeSelect) typeSelect.value = 'TEMPORARY';

        var daysField = document.getElementById('daysField');
        if (daysField) daysField.style.display = '';

        var daysInput = document.getElementById('sanctionDays');
        if (daysInput) daysInput.value = '7';
    }

    // ── 제재 추가 체크박스 토글 ──────────────────────────────────────
    var chkSanction = document.getElementById('chkSanction');
    if (chkSanction) {
        chkSanction.addEventListener('change', function () {
            var sanctionSection = document.getElementById('sanctionSection');
            var track = document.getElementById('sanctionToggleTrack');
            if (sanctionSection) {
                sanctionSection.style.display = this.checked ? 'block' : 'none';
            }
            if (track) {
                this.checked ? track.classList.add('on') : track.classList.remove('on');
            }
        });
    }

    // ── 제재 유형 변경 시 기간 필드 토글 ─────────────────────────────
    var sanctionTypeSelect = document.getElementById('sanctionTypeSelect');
    if (sanctionTypeSelect) {
        sanctionTypeSelect.addEventListener('change', function () {
            var daysField = document.getElementById('daysField');
            if (daysField) {
                daysField.style.display = (this.value === 'TEMPORARY') ? '' : 'none';
            }
        });
    }

    // ── 처리 제출 ────────────────────────────────────────────────────
    function submitProcess(status) {
        if (!currentReportIdx) return;

        var statusText = status === 1 ? '처리 완료' : '반려';
        var memo       = dAdminMemo.value.trim();

        // 제재 옵션 수집
        var sanctionType = 'NONE';
        var sanctionDays = 7;
        var chk = document.getElementById('chkSanction');
        if (status === 1 && chk && chk.checked) {
            var typeEl = document.getElementById('sanctionTypeSelect');
            var daysEl = document.getElementById('sanctionDays');
            sanctionType = typeEl ? typeEl.value : 'TEMPORARY';
            sanctionDays = daysEl ? parseInt(daysEl.value) || 7 : 7;
        }

        // 확인 메시지 구성
        var confirmDesc = '이 신고를 [' + statusText + '] 처리하시겠습니까?';
        if (status === 1 && sanctionType !== 'NONE') {
            var sanctionLabel = sanctionType === 'PERMANENT'
                ? '영구정지'
                : sanctionDays + '일 기간정지';
            confirmDesc += '<br><span style="color:#EF4444;font-size:13px;margin-top:6px;display:block;">⚠️ ' + currentReportedUser + ' 에게 <strong>' + sanctionLabel + '</strong> 제재가 추가됩니다.</span>';
        }

        showConfirm({
            type  : status === 1 ? 'info' : 'warning',
            title : '신고 ' + statusText,
            desc  : confirmDesc,
            okText: '확인',
            onOk  : function () {
                var targetIdx = currentReportIdx;
                closeModal();

                var payload = {
                    reportIdx     : targetIdx,
                    processStatus : status,
                    adminMemo     : memo,
                    sanctionType  : sanctionType,
                    sanctionDays  : sanctionDays
                };

                fetch(CTX + '/admin/report/process', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        var toastMsg = '신고가 ' + statusText + ' 처리되었습니다.';
                        if (sanctionType !== 'NONE' && status === 1) {
                            toastMsg += ' 제재가 적용되었습니다.';
                        }
                        showToast(toastMsg, 'success');
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
        currentReportIdx    = null;
        currentReportedUser = '';
        resetSanctionUI();
        if (detailFooter) detailFooter.style.display = '';
        var toggleRow = document.getElementById('sanctionToggleRow');
        if (toggleRow) toggleRow.style.display = '';
    }

    detailClose.addEventListener('click',  closeModal);
    detailCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeModal(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeModal();
    });

})();