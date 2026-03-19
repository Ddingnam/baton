function openReportModal(domainType, targetIdx, reportedUserIdx) {
    document.getElementById('reportDomainType').value  = domainType;
    document.getElementById('reportTargetIdx').value   = targetIdx;
    document.getElementById('reportedUserIdx').value   = reportedUserIdx;

    document.querySelectorAll('input[name="reportType"]').forEach(r => r.checked = false);
    document.getElementById('reportContent').value = '';
    document.getElementById('reportContentCount').textContent = '0';

    const overlay = document.getElementById('reportModal');
    overlay.style.display = 'flex';
    overlay.onclick = function(e) {
        if (e.target === overlay) closeReportModal();
    };
}

function closeReportModal() {
    document.getElementById('reportModal').style.display = 'none';
}

document.addEventListener('DOMContentLoaded', function() {
    const textarea = document.getElementById('reportContent');
    if (textarea) {
        textarea.addEventListener('input', function() {
            document.getElementById('reportContentCount').textContent = this.value.length;
        });
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeReportModal();
    });
});

function submitReport() {
    const domainType      = document.getElementById('reportDomainType').value;
    const targetIdx       = document.getElementById('reportTargetIdx').value;
    const reportedUserIdx = document.getElementById('reportedUserIdx').value;
    const reportContent   = document.getElementById('reportContent').value.trim();
    const checkedType     = document.querySelector('input[name="reportType"]:checked');

    if (!checkedType) {
        alert('신고 사유를 선택해주세요.');
        return;
    }

    const btn = document.querySelector('.report-btn-submit');
    btn.disabled = true;
    btn.textContent = '접수 중...';

    fetch(window.contextPath + '/report/submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
            domainType:      domainType,
            targetIdx:       targetIdx,
            reportedUserIdx: reportedUserIdx,
            reportType:      checkedType.value,
            reportContent:   reportContent
        })
    })
    .then(res => res.json())
    .then(data => {
        closeReportModal();
        if (data.state === 'success') {
            showBatonToast('신고가 접수되었습니다.');
        } else if (data.state === 'duplicate') {
            showBatonToast('이미 신고한 게시물입니다.');
        } else if (data.state === 'selfReport') {
            showBatonToast('본인을 신고할 수 없습니다.');
        } else if (data.state === 'unauthorized') {
            alert('로그인이 필요합니다.');
        } else {
            showBatonToast('신고 접수 중 오류가 발생했습니다.');
        }
    })
    .catch(() => {
        closeReportModal();
        showBatonToast('네트워크 오류가 발생했습니다.');
    })
    .finally(() => {
        btn.disabled = false;
        btn.textContent = '신고 접수';
    });
}
