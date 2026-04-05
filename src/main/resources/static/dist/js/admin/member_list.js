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

    function loadStatCounts() {
        var n      = document.getElementById('countNormal');
        var b      = document.getElementById('countBan');
        var o      = document.getElementById('countOut');
        var normal = document.querySelector('[data-count-normal]');
        var ban    = document.querySelector('[data-count-ban]');
        var out    = document.querySelector('[data-count-out]');
        if (n && normal) n.textContent = normal.dataset.countNormal;
        if (b && ban)    b.textContent = ban.dataset.countBan;
        if (o && out)    o.textContent = out.dataset.countOut;
    }
    loadStatCounts();

    /* ── 탈퇴 회원 인터랙션 잠금 / 해제 ─────────────────────── */
    function lockWithdrawnControls() {
        /* 권한 드롭다운 버튼 */
        var ddBtn = document.querySelector('#dAuthorityDd .adm-dropdown-btn');
        if (ddBtn) {
            ddBtn.disabled          = true;
            ddBtn.style.opacity     = '0.38';
            ddBtn.style.cursor      = 'not-allowed';
            ddBtn.style.pointerEvents = 'none';
        }
        /* 저장 버튼 */
        var saveBtn = document.querySelector('[onclick="saveAuthority()"]');
        if (saveBtn) {
            saveBtn.disabled          = true;
            saveBtn.style.opacity     = '0.38';
            saveBtn.style.cursor      = 'not-allowed';
            saveBtn.style.pointerEvents = 'none';
        }
        /* 제재 처리 탭 */
        var sanctionTab = document.querySelector('[data-pane="paneSanction"]');
        if (sanctionTab) {
            sanctionTab.disabled          = true;
            sanctionTab.style.opacity     = '0.38';
            sanctionTab.style.cursor      = 'not-allowed';
            sanctionTab.style.pointerEvents = 'none';
        }
        /* 권한 설정 영역 전체에 dim 오버레이 표시 */
        var authSection = document.getElementById('authoritySection');
        if (authSection) authSection.setAttribute('data-locked', 'true');
    }

    function unlockControls() {
        var ddBtn = document.querySelector('#dAuthorityDd .adm-dropdown-btn');
        if (ddBtn) {
            ddBtn.disabled          = false;
            ddBtn.style.opacity     = '';
            ddBtn.style.cursor      = '';
            ddBtn.style.pointerEvents = '';
        }
        var saveBtn = document.querySelector('[onclick="saveAuthority()"]');
        if (saveBtn) {
            saveBtn.disabled          = false;
            saveBtn.style.opacity     = '';
            saveBtn.style.cursor      = '';
            saveBtn.style.pointerEvents = '';
        }
        var sanctionTab = document.querySelector('[data-pane="paneSanction"]');
        if (sanctionTab) {
            sanctionTab.disabled          = false;
            sanctionTab.style.opacity     = '';
            sanctionTab.style.cursor      = '';
            sanctionTab.style.pointerEvents = '';
        }
        var authSection = document.getElementById('authoritySection');
        if (authSection) authSection.removeAttribute('data-locked');
    }
    /* ─────────────────────────────────────────────────────────── */

    function oDt(id) {
        cIdx = id;

        fetch(CTX + '/admin/member/detail/' + id, {
            method: 'POST',
            headers: {}
        })
        .then(function (r) {
            if (!r.ok) throw new Error('서버 응답 오류 (' + r.status + ')');
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
            document.getElementById('dCreated').textContent   = fmtDate(m.createdDate);
            document.getElementById('dLastLogin').textContent = fmtDate(m.lastLoginDate);
            document.getElementById('dLevel').textContent     = 'Lv.' + (m.userLevel || 1);

            var dist     = m.batonDistance || 0;
            var barColor = dist >= 40 ? '#FFB300' : dist >= 30 ? '#3182F6' : dist >= 20 ? '#00B98D' : dist >= 10 ? '#9CA3AF' : '#8B4513';
            var pct      = Math.min(100, Math.max(0, (dist / 42.195) * 100));
            document.getElementById('dScoreText').textContent = parseFloat(dist).toFixed(1);
            var bar = document.getElementById('dScoreBar');
            if (bar) {
                bar.style.width      = '0%';
                bar.style.background = barColor;
                setTimeout(function () { bar.style.width = pct + '%'; }, 80);
            }

            document.getElementById('dPoint').textContent = (m.batonpoint || 0).toLocaleString();
            document.getElementById('dAuthority').value   = m.authority || 'USER';

            var authorityLabels = { USER: '일반 회원', EMP: '직원', ADMIN: '관리자' };
            document.getElementById('dAuthorityLabel').textContent = authorityLabels[m.authority] || '일반 회원';

            document.querySelectorAll('#dAuthorityDd .adm-dropdown-item').forEach(function (i) {
                i.classList.toggle('active', i.dataset.value === (m.authority || 'USER'));
            });

            var b  = document.getElementById('dStatusBadge');
            var bs = document.getElementById('btnSuspend');
            var ba = document.getElementById('btnActivate');
            var bd = document.getElementById('btnDeactivate');

            var isEmpOrAdmin = (m.authority === 'EMP' || m.authority === 'ADMIN');

            /* 매번 컨트롤을 초기화한 뒤 상태별 처리 */
            unlockControls();

            if (m.status == 1) {
                b.textContent = '정상';
                b.className   = 'detail-status-badge status-ok';
                bs.style.display = isEmpOrAdmin ? 'none' : 'inline-flex';
                ba.style.display = 'none';
                bd.style.display = isEmpOrAdmin ? 'inline-flex' : 'none';
            } else if (m.status == 2) {
                b.textContent = '제재중';
                b.className   = 'detail-status-badge status-ban';
                bs.style.display = 'none';
                ba.style.display = 'inline-flex';
                bd.style.display = 'none';
            } else if (m.status == 0) {
                b.textContent = '비활성';
                b.className   = 'detail-status-badge status-out';
                bs.style.display = 'none';
                ba.style.display = isEmpOrAdmin ? 'inline-flex' : 'none';
                bd.style.display = 'none';
            } else {
                /* ── 탈퇴 회원 (status == 9) ── */
                b.textContent = '탈퇴';
                b.className   = 'detail-status-badge status-out';
                bs.style.display = 'none';
                ba.style.display = 'none';
                bd.style.display = 'none';

                /* 권한 드롭다운 · 저장버튼 · 제재탭 완전 잠금 */
                lockWithdrawnControls();
            }

            swP('paneInfo');
            var box = document.getElementById('memberModalBox');
            if (box) { box.style.opacity='0'; box.style.transform='translateY(20px) scale(0.97)'; }
            document.getElementById('detailOverlay').classList.add('show');
            if (box) { requestAnimationFrame(function(){ box.style.opacity='1'; box.style.transform='translateY(0) scale(1)'; }); }
        })
        .catch(function (e) {
            console.error('상세 정보 조회 실패:', e);
            showToast('정보를 불러오지 못했습니다. (콘솔 확인)', 'error');
        });
    }
    window.openDetail = oDt;
    window.closeMemberModal = function() { document.getElementById('detailClose').click(); };

    function fmtDate(v) {
        if (!v) return '-';
        if (typeof v === 'string') return v.substring(0, 10);
        if (Array.isArray(v))      return v.slice(0, 3).join('-');
        return String(v).substring(0, 10);
    }

    document.getElementById('detailClose').addEventListener('click', function () {
        var box2 = document.getElementById('memberModalBox');
        if (box2) { box2.style.opacity='0'; box2.style.transform='translateY(20px) scale(0.97)'; }
        setTimeout(function(){ document.getElementById('detailOverlay').classList.remove('show'); }, 280);
    });
    document.getElementById('detailOverlay').addEventListener('click', function (e) {
        if (e.target === this) document.getElementById('detailClose').click();
    });
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && document.getElementById('detailOverlay').classList.contains('show')) {
            document.getElementById('detailClose').click();
        }
    });

    document.getElementById('btnSuspend').addEventListener('click', function () {
        swP('paneSanction');
    });

    document.getElementById('btnDeactivate').addEventListener('click', function () {
        showConfirm({
            type   : 'warning',
            title  : '계정 비활성화',
            desc   : '해당 직원/관리자 계정을 비활성화합니다. 로그인이 불가해지며 언제든 복구할 수 있습니다.',
            okText : '비활성화',
            onOk   : function () {
                fetch(CTX + '/admin/member/deactivate', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ userIdx: cIdx })
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        showToast('계정이 비활성화되었습니다.', 'success');
                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + d.msg, 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    });

    document.getElementById('btnActivate').addEventListener('click', function () {
        showConfirm({
            type   : 'info',
            title  : '제재 해제',
            desc   : '선택한 회원의 제재를 해제하고 정상 상태로 변경합니다.',
            okText : '정상화',
            onOk   : function () {
                fetch(CTX + '/admin/member/status', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ userIdx: cIdx, status: 1 })
                })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        showToast('정상화 처리 완료!', 'success');
                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + d.msg, 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    });

    document.querySelectorAll('.detail-tab-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            /* 탈퇴 회원이면 제재 탭 클릭 자체를 무시 */
            if (this.disabled) return;
            swP(this.dataset.pane);
        });
    });

    function swP(pid) {
        document.querySelectorAll('.detail-pane').forEach(function (p) { p.classList.remove('active'); });
        document.querySelectorAll('.detail-tab-btn').forEach(function (b) { b.classList.remove('active'); });
        var pn = document.getElementById(pid);
        if (pn) pn.classList.add('active');
        var bt = document.querySelector('[data-pane="' + pid + '"]');
        if (bt) bt.classList.add('active');
    }
    window.switchPane = swP;

    function sSan() {
        var t     = document.getElementById('sanctionType').value;
        var d     = document.getElementById('sanctionDays').value;
        var r     = document.getElementById('sanctionReason').value.trim();
        var errEl = document.getElementById('reasonError');

        if (!r) {
            errEl.style.display = 'flex';
            document.getElementById('sanctionReason').focus();
            return;
        }
        errEl.style.display = 'none';

        var typeLabel = t === 'PERMANENT' ? '영구 정지' : d + '일 기간 정지';
        showConfirm({
            type  : 'danger',
            title : '제재 적용',
            desc  : '해당 회원에게 [' + typeLabel + '] 제재를 적용합니다. 계속하시겠습니까?',
            okText: '제재 적용',
            onOk  : function () {
                fetch(CTX + '/admin/member/sanction/add', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ userIdx: cIdx, sanctionType: t, days: d, reason: r })
                })
                .then(function (rs) { return rs.json(); })
                .then(function (dt) {
                    if (dt.success) {
                        showToast('제재가 적용되었습니다.', 'success');
                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + dt.msg, 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    }
    window.submitSanction = sSan;

    function svAuth() {
        var a             = document.getElementById('dAuthority').value;
        var authorityLabels = { USER: '일반 회원', EMP: '직원', ADMIN: '관리자' };
        showConfirm({
            type  : 'warning',
            title : '권한 변경',
            desc  : '선택한 권한 [' + (authorityLabels[a] || a) + '] 으로 변경합니다.',
            okText: '변경',
            onOk  : function () {
                fetch(CTX + '/admin/member/authority', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ userId: cId, userIdx: cIdx, authority: a })
                })
                .then(function (rs) { return rs.json(); })
                .then(function (dt) {
                    if (dt.success) {
                        showToast('권한이 변경되었습니다.', 'success');

                        var badgeClassMap = { USER: 'user', EMP: 'emp', ADMIN: 'admin' };
                        var badgeLabelMap = { USER: '일반', EMP: '직원', ADMIN: '관리자' };
                        var badge = document.querySelector('tr[data-useridx="' + cIdx + '"] .auth-badge');
                        if (badge) {
                            badge.className   = 'auth-badge ' + (badgeClassMap[a] || 'user');
                            badge.textContent = badgeLabelMap[a] || '일반';
                        }

                        var levelMap = { USER: 1, EMP: 51, ADMIN: 99 };
                        var newLevel = levelMap[a] !== undefined ? levelMap[a] : 1;

                        var lvEl = document.getElementById('dLevel');
                        if (lvEl) lvEl.textContent = 'Lv.' + newLevel;

                        var row = document.querySelector('tr[data-useridx="' + cIdx + '"]');
                        if (row) {
                            var cells = row.querySelectorAll('td');
                            if (cells[4]) cells[4].textContent = 'Lv.' + newLevel;
                        }

                        setTimeout(function () { location.reload(); }, 1000);
                    } else {
                        showToast('오류: ' + dt.msg, 'error');
                    }
                })
                .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
            }
        });
    }
    window.saveAuthority = svAuth;

})();