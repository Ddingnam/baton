(function () {
    'use strict';

    var pendingId    = null;
    var overlay      = document.getElementById('deleteOverlay');
    var deleteClose  = document.getElementById('deleteClose');
    var deleteCancel = document.getElementById('deleteCancel');
    var deleteConfirm = document.getElementById('deleteConfirm');
    var targetTitle  = document.getElementById('deleteTargetTitle');

    function confirmDelete(id, subject) {
        pendingId = id;
        targetTitle.textContent = subject;
        overlay.classList.add('show');
    }
    window.confirmDelete = confirmDelete;

    function closeModal() {
        overlay.classList.remove('show');
        pendingId = null;
    }

    deleteClose.addEventListener('click',  closeModal);
    deleteCancel.addEventListener('click', closeModal);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeModal(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeModal();
    });

    deleteConfirm.addEventListener('click', function () {
        if (!pendingId) return;

        fetch(CTX + '/admin/community/delete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: pendingId })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) {
                closeModal();
                showToast('게시글이 삭제되었습니다.', 'success');
                setTimeout(function () { location.reload(); }, 1000);
            } else {
                showToast('오류: ' + (d.msg || '삭제에 실패했습니다.'), 'error');
            }
        })
        .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
    });

})();