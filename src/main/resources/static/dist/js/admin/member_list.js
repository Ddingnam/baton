(function () {
    'use strict';

    var cIdx = null;
    var cId  = null;

    function fSt(s) {
        var u = new URL(location.href);
        u.searchParams.set('status', s);
        u.searchParams.set('page', 1);
        location.href = u.toString();
    }
    window.filterByStatus = fSt;

    function oDt(id) {
        cIdx = id;
        fetch(CTX + '/admin/member/detail/' + id)
            .then(function (r) {
                if (!r.ok) {
                    throw new Error('서버 응답 오류 (' + r.status + ')');
                }
                return r.json(); 
            })
            .then(function (m) {
                cId = m.userId;

                var i = m.nickname ? m.nickname.charAt(0) : '?';
                var a = document.getElementById('dAvt');
                
                a.style.animation = 'none';
                void a.offsetWidth;
                a.style.animation = null;

                a.textContent = i;
                document.getElementById('dName').textContent      = m.nickname    || '-';
                document.getElementById('dId').textContent        = '@' + (m.userId || '-');
                document.getElementById('dEmail').textContent     = m.email       || '-';
                document.getElementById('dTel').textContent       = m.tel         || '-';
                document.getElementById('dBirth').textContent     = m.birth       || '-';
                document.getElementById('dCreated').textContent   = m.createdDate  ? m.createdDate.substring(0, 10)   : '-';
                document.getElementById('dLastLogin').textContent = m.lastLoginDate ? m.lastLoginDate.substring(0, 10) : '-';
                document.getElementById('dLevel').textContent     = 'Lv.' + (m.userLevel || 1);
                document.getElementById('dScoreText').textContent = (m.score      || 0) + '°';
                document.getElementById('dPoint').textContent     = ((m.batonpoint || 0)).toLocaleString();
                document.getElementById('dAuthority').value       = m.authority   || 'USER';

                var b = document.getElementById('dStatusBadge');
                var bs = document.getElementById('btnSuspend');
                var ba = document.getElementById('btnActivate');

                if (m.status == 1) {
                    b.textContent = '정상';  
                    b.className = 'detail-status-badge status-ok';
                    bs.style.display = ''; 
                    ba.style.display = 'none';
                } else if (m.status == 2) {
                    b.textContent = '제재중'; 
                    b.className = 'detail-status-badge status-ban';
                    bs.style.display = 'none'; 
                    ba.style.display = '';
                } else {
                    b.textContent = '탈퇴';  
                    b.className = 'detail-status-badge status-out';
                    bs.style.display = 'none'; 
                    ba.style.display = 'none';
                }

                swP('paneInfo');
                document.getElementById('detailOverlay').classList.add('show');
            })
            .catch(function(e) {
                console.error("상세 정보 조회 실패:", e);
                alert("정보를 불러오지 못했습니다. \n원인: " + e.message + "\n콘솔창(F12)을 확인해주세요.");
            });
    }
    window.openDetail = oDt;

    document.getElementById('detailClose').addEventListener('click', function () {
        document.getElementById('detailOverlay').classList.remove('show');
    });

    document.getElementById('detailOverlay').addEventListener('click', function (e) {
        if (e.target === this) this.classList.remove('show');
    });

    document.getElementById('btnSuspend').addEventListener('click', function () {
        swP('paneSanction');
    });

    document.getElementById('btnActivate').addEventListener('click', function () {
        if (!confirm('제재를 해제하고 정상 상태로 변경하시겠습니까?')) return;
        fetch(CTX + '/admin/member/status', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userIdx: cIdx, status: 1 })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) { 
                alert('정상화되었습니다.'); 
                location.reload(); 
            } else { 
                alert('오류: ' + d.msg); 
            }
        });
    });

    document.querySelectorAll('.detail-tab-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            swP(this.dataset.pane);
        });
    });

    function swP(pid) {
        document.querySelectorAll('.detail-pane').forEach(function (p) { p.classList.remove('active'); });
        document.querySelectorAll('.detail-tab-btn').forEach(function (b) { b.classList.remove('active'); });
        var pn = document.getElementById(pid);
        if (pn) pn.classList.add('active');
        var bt  = document.querySelector('[data-pane="' + pid + '"]');
        if (bt) bt.classList.add('active');
    }
    window.switchPane = swP;

    document.getElementById('sanctionType').addEventListener('change', function () {
        document.getElementById('daysField').style.display = this.value === 'PERMANENT' ? 'none' : 'block';
    });

    function sSan() {
        var t = document.getElementById('sanctionType').value;
        var d = document.getElementById('sanctionDays').value;
        var r = document.getElementById('sanctionReason').value.trim();
        
        if (!r) { 
            alert('제재 사유를 입력하세요.'); 
            return; 
        }

        fetch(CTX + '/admin/member/sanction/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userIdx: cIdx, sanctionType: t, days: d, reason: r })
        })
        .then(function (rs) { return rs.json(); })
        .then(function (dt) {
            if (dt.success) { 
                alert('제재가 적용되었습니다.'); 
                location.reload(); 
            } else { 
                alert('오류: ' + dt.msg); 
            }
        });
    }
    window.submitSanction = sSan;

    function svAuth() {
        var a = document.getElementById('dAuthority').value;
        fetch(CTX + '/admin/member/authority', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId: cId, authority: a })
        })
        .then(function (rs) { return rs.json(); })
        .then(function (dt) {
            if (dt.success) alert('권한이 변경되었습니다.');
            else alert('오류: ' + dt.msg);
        });
    }
    window.saveAuthority = svAuth;

})();