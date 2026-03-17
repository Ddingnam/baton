(function () {
    'use strict';

    var pendingWithdrawIdx = null;
    var pendingUserIdx     = null;

    var overlay        = document.getElementById('approveOverlay');
    var approveClose   = document.getElementById('approveClose');
    var approveCancel  = document.getElementById('approveCancel');
    var approveConfirm = document.getElementById('approveConfirm');

    function openApproveModal(withdrawIdx, userIdx, nickname) {
        pendingWithdrawIdx = withdrawIdx;
        pendingUserIdx     = userIdx;
        document.getElementById('approveTargetName').textContent = nickname;
        document.getElementById('approveAvt').textContent        = nickname ? nickname.charAt(0) : '?';
        overlay.classList.add('show');
    }
    window.openApproveModal = openApproveModal;

    function closeModal() { overlay.classList.remove('show'); }

    approveClose.addEventListener('click',  closeModal);
    approveCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeModal(); });

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeModal();
    });

    approveConfirm.addEventListener('click', function () {
        var name = document.getElementById('approveTargetName').textContent;
        showConfirm({
            type  : 'danger',
            title : '탈퇴 승인',
            desc  : name + ' 님의 탈퇴를 최종 승인합니다.\n이 작업은 되돌릴 수 없습니다.',
            okText: '탈퇴 승인',
            onOk  : function () {
                closeModal();
                fetch(CTX + '/admin/member/withdrawal/approve', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ withdrawIdx: pendingWithdrawIdx, userIdx: pendingUserIdx })
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
    });

    function rejectWithdrawal(withdrawIdx, userIdx, nickname) {
        showConfirm({
            type  : 'warning',
            title : '탈퇴 반려',
            desc  : (nickname || '해당 회원') + ' 님의 탈퇴 요청을 반려합니다.',
            okText: '반려',
            onOk  : function () {
                fetch(CTX + '/admin/member/withdrawal/reject', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ withdrawIdx: withdrawIdx, userIdx: userIdx })
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
    window.rejectWithdrawal = rejectWithdrawal;

})();