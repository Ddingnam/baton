(function () {
    'use strict';

    var currentUserIdx = null;
    var currentUserId  = null;

    function filterByStatus(status) {
        var url = new URL(location.href);
        url.searchParams.set('status', status);
        url.searchParams.set('page', 1);
        location.href = url.toString();
    }
    window.filterByStatus = filterByStatus;

    function openDetail(userIdx) {
        currentUserIdx = userIdx;
        fetch(CTX + '/admin/member/detail/' + userIdx)
            .then(function (r) { return r.json(); })
            .then(function (m) {
                currentUserId = m.userId;

                var initial = m.nickname ? m.nickname.charAt(0) : '?';
                document.getElementById('dAvt').textContent       = initial;
                document.getElementById('dName').textContent      = m.nickname    || '-';
                document.getElementById('dId').textContent        = '@' + (m.userId || '-');
                document.getElementById('dEmail').textContent     = m.email       || '-';
                document.getElementById('dTel').textContent       = m.tel         || '-';
                document.getElementById('dBirth').textContent     = m.birth       || '-';
                document.getElementById('dCreated').textContent   = m.createdDate  ? m.createdDate.substring(0, 10)   : '-';
                document.getElementById('dLastLogin').textContent = m.lastLoginDate ? m.lastLoginDate.substring(0, 10) : '-';
                document.getElementById('dLevel').textContent     = 'Lv.' + (m.userLevel || 1);
                document.getElementById('dScore').textContent     = (m.score      || 0) + '°';
                document.getElementById('dPoint').textContent     = ((m.batonpoint || 0)).toLocaleString();
                document.getElementById('dAuthority').value       = m.authority   || 'USER';

                var badge = document.getElementById('dStatusBadge');
                var btnS  = document.getElementById('btnSuspend');
                var btnA  = document.getElementById('btnActivate');

                if (m.status == 1) {
                    badge.textContent = '정상';  badge.className = 'detail-status-badge status-ok';
                    btnS.style.display = ''; btnA.style.display = 'none';
                } else if (m.status == 2) {
                    badge.textContent = '제재중'; badge.className = 'detail-status-badge status-ban';
                    btnS.style.display = 'none'; btnA.style.display = '';
                } else {
                    badge.textContent = '탈퇴';  badge.className = 'detail-status-badge status-out';
                    btnS.style.display = 'none'; btnA.style.display = 'none';
                }

                switchPane('paneInfo');
                document.getElementById('detailOverlay').classList.add('show');
            });
    }
    window.openDetail = openDetail;

    document.getElementById('detailClose').addEventListener('click', function () {
        document.getElementById('detailOverlay').classList.remove('show');
    });
    document.getElementById('detailOverlay').addEventListener('click', function (e) {
        if (e.target === this) this.classList.remove('show');
    });

    document.getElementById('btnSuspend').addEventListener('click', function () {
        switchPane('paneSanction');
    });
    document.getElementById('btnActivate').addEventListener('click', function () {
        if (!confirm('제재를 해제하고 정상 상태로 변경하시겠습니까?')) return;
        fetch(CTX + '/admin/member/status', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userIdx: currentUserIdx, status: 1 })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) { alert('정상화되었습니다.'); location.reload(); }
            else           { alert('오류: ' + d.msg); }
        });
    });

    document.querySelectorAll('.detail-tab-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            switchPane(this.dataset.pane);
        });
    });

    function switchPane(paneId) {
        document.querySelectorAll('.detail-pane').forEach(function (p) { p.classList.remove('active'); });
        document.querySelectorAll('.detail-tab-btn').forEach(function (b) { b.classList.remove('active'); });
        var pane = document.getElementById(paneId);
        if (pane) pane.classList.add('active');
        var btn  = document.querySelector('[data-pane="' + paneId + '"]');
        if (btn)  btn.classList.add('active');
    }
    window.switchPane = switchPane;

    document.getElementById('sanctionType').addEventListener('change', function () {
        document.getElementById('daysField').style.display = this.value === 'PERMANENT' ? 'none' : 'block';
    });

    function submitSanction() {
        var type   = document.getElementById('sanctionType').value;
        var days   = document.getElementById('sanctionDays').value;
        var reason = document.getElementById('sanctionReason').value.trim();
        if (!reason) { alert('제재 사유를 입력하세요.'); return; }

        fetch(CTX + '/admin/member/sanction/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userIdx: currentUserIdx, sanctionType: type, days: days, reason: reason })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) { alert('제재가 적용되었습니다.'); location.reload(); }
            else           { alert('오류: ' + d.msg); }
        });
    }
    window.submitSanction = submitSanction;

    function saveAuthority() {
        var auth = document.getElementById('dAuthority').value;
        fetch(CTX + '/admin/member/authority', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId: currentUserId, authority: auth })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) alert('권한이 변경되었습니다.');
            else           alert('오류: ' + d.msg);
        });
    }
    window.saveAuthority = saveAuthority;

})();