(function () {
    'use strict';

    var pendingWithdrawIdx = null;
    var pendingUserIdx     = null;

    var overlay      = document.getElementById('approveOverlay');
    var approveClose  = document.getElementById('approveClose');
    var approveCancel = document.getElementById('approveCancel');
    var approveConfirm = document.getElementById('approveConfirm');

    function openApproveModal(withdrawIdx, userIdx, nickname) {
        pendingWithdrawIdx = withdrawIdx;
        pendingUserIdx     = userIdx;
        document.getElementById('approveTargetName').textContent = nickname;
        document.getElementById('approveAvt').textContent        = nickname.charAt(0);
        overlay.classList.add('show');
    }
    window.openApproveModal = openApproveModal;

    function closeModal() { overlay.classList.remove('show'); }

    approveClose.addEventListener('click',  closeModal);
    approveCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeModal(); });

    approveConfirm.addEventListener('click', function () {
        fetch(CTX + '/admin/member/withdrawal/approve', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ withdrawIdx: pendingWithdrawIdx, userIdx: pendingUserIdx })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) { alert('탈퇴 처리가 완료되었습니다.'); location.reload(); }
            else           { alert('오류: ' + d.msg); }
        });
    });

    function rejectWithdrawal(withdrawIdx, userIdx) {
        if (!confirm('탈퇴 요청을 반려하시겠습니까?')) return;
        fetch(CTX + '/admin/member/withdrawal/reject', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ withdrawIdx: withdrawIdx, userIdx: userIdx })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) { alert('반려되었습니다.'); location.reload(); }
            else           { alert('오류: ' + d.msg); }
        });
    }
    window.rejectWithdrawal = rejectWithdrawal;

})();