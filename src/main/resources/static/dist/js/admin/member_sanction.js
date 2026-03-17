(function () {
    'use strict';

    var pendingSanctionIdx = null;
    var pendingUserIdx     = null;

    var overlay     = document.getElementById('liftOverlay');
    var liftClose   = document.getElementById('liftClose');
    var liftCancel  = document.getElementById('liftCancel');
    var liftConfirm = document.getElementById('liftConfirm');
    var liftReason  = document.getElementById('liftReason');
    var targetName  = document.getElementById('liftTargetName');

    function openLiftModal(sanctionIdx, userIdx, nickname) {
        pendingSanctionIdx = sanctionIdx;
        pendingUserIdx     = userIdx;
        targetName.textContent = nickname;
        liftReason.value = '';
        var errEl = document.getElementById('liftReasonError');
        if (errEl) errEl.style.display = 'none';
        overlay.classList.add('show');
        setTimeout(function () { liftReason.focus(); }, 200);
    }
    window.openLiftModal = openLiftModal;

    function closeModal() { overlay.classList.remove('show'); }

    liftClose.addEventListener('click',  closeModal);
    liftCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeModal(); });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeModal();
    });

    liftConfirm.addEventListener('click', function () {
        var reason = liftReason.value.trim();
        var errEl  = document.getElementById('liftReasonError');

        if (!reason) {
            if (errEl) errEl.style.display = 'flex';
            liftReason.focus();
            return;
        }
        if (errEl) errEl.style.display = 'none';

        showConfirm({
            type  : 'warning',
            title : '제재 해제',
            desc  : targetName.textContent + ' 님의 제재를 해제합니다.',
            okText: '해제 확정',
            onOk  : function () {
                closeModal();
                fetch(CTX + '/admin/member/sanction/lift', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        sanctionIdx: pendingSanctionIdx,
                        userIdx    : pendingUserIdx,
                        liftReason : reason
                    })
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        showToast('제재가 해제되었습니다.', 'success');
                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + d.msg, 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    });

})();