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
        overlay.classList.add('show');
    }
    window.openLiftModal = openLiftModal;

    function closeModal() { overlay.classList.remove('show'); }

    liftClose.addEventListener('click',  closeModal);
    liftCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeModal(); });

    liftConfirm.addEventListener('click', function () {
        var reason = liftReason.value.trim();
        if (!reason) { alert('해제 사유를 입력하세요.'); return; }

        fetch(CTX + '/admin/member/sanction/lift', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sanctionIdx: pendingSanctionIdx, userIdx: pendingUserIdx, liftReason: reason })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) { alert('제재가 해제되었습니다.'); location.reload(); }
            else           { alert('오류: ' + d.msg); }
        });
    });

})();