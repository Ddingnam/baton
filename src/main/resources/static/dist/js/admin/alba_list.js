/* ================================================================
   alba_list.js - 알바구인 관리 상세보기 & 삭제
   ================================================================ */
(function () {
    'use strict';

    var overlay  = document.getElementById('albaDetailOverlay');
    var modalBox = document.getElementById('adModalBox');
    var adClose  = document.getElementById('adClose');
    var adCancel = document.getElementById('adCancel');

    /* 현재 열린 공고 추적 */
    var currentDetailId    = null;
    var currentDetailTitle = '';

    function openModal() {
        overlay.classList.add('show');
        requestAnimationFrame(function () {
            modalBox.style.opacity   = '1';
            modalBox.style.transform = 'translateY(0) scale(1)';
        });
    }
    function closeDetail() {
        modalBox.style.opacity   = '0';
        modalBox.style.transform = 'translateY(20px) scale(0.97)';
        setTimeout(function () { overlay.classList.remove('show'); }, 300);
    }

    adClose.addEventListener('click',  closeDetail);
    adCancel.addEventListener('click', closeDetail);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeDetail(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeDetail();
    });

    /* 모달 내 삭제 버튼 */
    var adDeleteBtn = document.getElementById('adDeleteBtn');
    if (adDeleteBtn) {
        adDeleteBtn.addEventListener('click', function () {
            if (!currentDetailId) return;
            closeDetail();
            setTimeout(function () { confirmDelete(currentDetailId, currentDetailTitle); }, 320);
        });
    }

    var CAT_COLOR = {
        '\ucae4\ud398/\uc74c\uc2dd\uc810': '#F59E0B',
        '\ud3b8\uc758\uc810'             : '#3B82F6',
        '\ub9c8\ud2b8/\ubb3c\ub958'      : '#8B5CF6',
        '\uc0ac\ubb34\uc9c1'             : '#06B6D4',
        '\uc11c\ube44\uc2a4'             : '#10B981',
        '\uae30\ud0c0'                   : '#94A3B8'
    };

    function openDetail(id) {
        currentDetailId    = id;
        currentDetailTitle = '';
        setText('adTitle',    '\ubd88\ub7ec\uc624\ub294 \uc911...');
        setText('adEmployer', '');
        setHTML('adCategoryChip', ''); setHTML('adPayChip', ''); setHTML('adDeadlineChip', ''); setHTML('adViewStat', '');
        setHTML('adCondGrid', '<div style="color:#94A3B8;font-size:13px;padding:8px 0;">\ubd88\ub7ec\uc624\ub294 \uc911...</div>');
        setHTML('adDescription', '');
        hide('adImageWrap'); hide('adLocationWrap');
        document.getElementById('adScrollBody').scrollTop = 0;
        openModal();

        fetch(CTX + '/admin/alba/detail?id=' + id)
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (!d.success) { setText('adTitle', '\ubd88\ub7ec\uc624\uae30 \uc2e4\ud328'); return; }
                currentDetailTitle = d.posting ? (d.posting.title || '') : '';
                renderPosting(d.posting, d.images || []);
            })
            .catch(function () {
                setText('adTitle', '\uc624\ub958 \ubc1c\uc0dd');
                setHTML('adCondGrid', '<div style="color:#EF4444;font-size:14px;">\ub124\ud2b8\uc6cc\ud06c \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.</div>');
            });
    }
    window.openDetail = openDetail;

    function renderPosting(p, images) {
        setText('adTitle',    p.title    || '(\uc81c\ubaa9 \uc5c6\uc74c)');
        setText('adEmployer', p.employer || '');

        var catColor = CAT_COLOR[p.category] || '#94A3B8';
        setHTML('adCategoryChip', chip(p.category || '\uae30\ud0c0', catColor, 'ri-briefcase-line'));

        if (p.pay && p.pay > 0) {
            setHTML('adPayChip', chip(((p.payType || '') + ' ' + numFormat(p.pay) + '\uc6d0').trim(), '#059669', 'ri-money-dollar-circle-line'));
        }

        var dlLabel = p.deadline ? p.deadline.substring(0,10) + ' \ub9c8\uac10' : '\uc0c1\uc2dc\uc544\uc774';
        setHTML('adDeadlineChip', chip(dlLabel, p.deadline ? '#EF4444' : '#10B981', 'ri-calendar-event-line'));
        setHTML('adViewStat', '<i class="ri-eye-line" style="font-size:13px;"></i><span>' + (p.hitCount || 0) + '</span>');

        /* 근무조건 - 퍼플 */
        var ci = [];
        if (p.workPeriod) ci.push({ icon:'ri-calendar-check-line', label:'\uadfc\ubb34\uae30\uac04', val:p.workPeriod });
        if (p.workDays)   ci.push({ icon:'ri-calendar-2-line',     label:'\uadfc\ubb34\uc694\uc77c', val:p.workDays });
        if (p.startTime && p.endTime) {
            ci.push({ icon:'ri-time-line', label:'\uadfc\ubb34\uc2dc\uac04',
                val: p.startTime + ' ~ ' + p.endTime + (p.timeNegotiable === 'Y' ? ' (\ud611\uc758\uac00\ub2a5)' : '') });
        }
        if (p.payType && p.pay) ci.push({ icon:'ri-money-dollar-circle-line', label:'\uae09\uc5ec', val: p.payType + ' ' + numFormat(p.pay) + '\uc6d0' });
        if (p.contact)  ci.push({ icon:'ri-phone-line', label:'\uc5f0\ub77d\uc815\ubcf4', val:p.contact });
        if (p.benefits) ci.push({ icon:'ri-gift-line',  label:'\ubcf5\ub9ac\ud6c4\uc0dd',  val:p.benefits });

        setHTML('adCondGrid', ci.length ? ci.map(function(item) {
            return '<div style="background:#F5F3FF;border:1px solid #DDD6FE;border-radius:12px;padding:12px 14px;display:flex;align-items:center;gap:10px;">'
                + '<div style="width:28px;height:28px;border-radius:8px;background:#EDE9FE;color:#7C3AED;display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0;">'
                + '<i class="' + item.icon + '"></i></div>'
                + '<div><div style="font-size:10px;color:#5B21B6;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">' + item.label + '</div>'
                + '<div style="font-size:13px;font-weight:700;color:#1E293B;margin-top:2px;">' + esc(String(item.val)) + '</div></div></div>';
        }).join('') : '<div style="color:#94A3B8;font-size:13px;">\uadfc\ubb34 \uc870\uac74 \uc815\ubcf4\uac00 \uc5c6\uc2b5\ub2c8\ub2e4.</div>');

        var desc = p.description ? String(p.description).trim() : '';
        if (desc) {
            var t = document.createElement('div'); t.innerHTML = desc;
            setText('adDescription', (t.textContent || t.innerText || '').trim() || desc);
        } else {
            setHTML('adDescription', '<span style="color:#94A3B8;font-style:italic;font-size:13px;">\ub0b4\uc6a9\uc774 \uc5c6\uc2b5\ub2c8\ub2e4.</span>');
        }

        if (images.length > 0) {
            setHTML('adImages', images.map(function(imgUrl) {
                var url = imgUrl.startsWith('/') ? CTX + imgUrl : CTX + '/uploads/job/' + imgUrl;
                return '<div style="display:inline-block;"><img src="' + url + '" '
                    + 'style="width:110px;height:82px;object-fit:cover;border-radius:10px;border:1px solid #E2E8F0;cursor:pointer;transition:all .2s;display:block;" '
                    + 'onclick="window.open(this.src,\'_blank\')" '
                    + 'onmouseover="this.style.transform=\'scale(1.04)\';this.style.boxShadow=\'0 6px 20px rgba(0,0,0,.14)\'" '
                    + 'onmouseout="this.style.transform=\'scale(1)\';this.style.boxShadow=\'none\'" '
                    + 'onerror="this.closest(\'div\').remove()"></div>';
            }).join(''));
            show('adImageWrap');
        }

        if (p.location) {
            setText('adLocation',       p.location);
            setText('adLocationDetail', p.locationDetail || '');
            setText('adSubway',         p.subwayInfo ? '\uD83D\uDE87 ' + p.subwayInfo : '');
            show('adLocationWrap');
        }
    }

    function chip(label, color, icon) {
        return '<span style="display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;background:' + color + '22;color:' + color + ';border:1px solid ' + color + '33;"><i class="' + icon + '" style="font-size:10px;"></i>' + esc(label) + '</span>';
    }
    function numFormat(n) { return String(n||0).replace(/\B(?=(\d{3})+(?!\d))/g,','); }
    function show(id)     { var el=document.getElementById(id); if(el) el.style.display=''; }
    function hide(id)     { var el=document.getElementById(id); if(el) el.style.display='none'; }
    function setText(id,val){ var el=document.getElementById(id); if(el) el.textContent=val; }
    function setHTML(id,val){ var el=document.getElementById(id); if(el) el.innerHTML=val; }
    function esc(str){ return String(str||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
})();

/* ================================================================
   삭제 확인 모달
   ================================================================ */
(function () {
    'use strict';
    var pendingId     = null;
    var delOverlay    = document.getElementById('albaDeleteOverlay');
    var deleteClose   = document.getElementById('albaDeleteClose');
    var deleteCancel  = document.getElementById('albaDeleteCancel');
    var deleteConfirm = document.getElementById('albaDeleteConfirm');
    var targetTitle   = document.getElementById('albaDeleteTargetTitle');

    function confirmDelete(id, title) {
        pendingId = id;
        if (targetTitle) targetTitle.textContent = title;
        delOverlay.classList.add('show');
    }
    window.confirmDelete = confirmDelete;

    function closeDeleteModal() { delOverlay.classList.remove('show'); pendingId = null; }

    deleteClose.addEventListener('click',  closeDeleteModal);
    deleteCancel.addEventListener('click', closeDeleteModal);
    delOverlay.addEventListener('click', function(e){ if(e.target===this) closeDeleteModal(); });
    document.addEventListener('keydown', function(e){
        if(e.key==='Escape' && delOverlay.classList.contains('show')) closeDeleteModal();
    });

    deleteConfirm.addEventListener('click', function () {
        if (!pendingId) return;
        fetch(CTX + '/admin/alba/delete', {
            method:'POST', headers:{'Content-Type':'application/json'},
            body: JSON.stringify({ id: pendingId })
        })
        .then(function(r){ return r.json(); })
        .then(function(d){
            if (d.success) {
                closeDeleteModal();
                showToast('\uacf5\uace0\uac00 \uc0ad\uc81c\ub418\uc5c8\uc2b5\ub2c8\ub2e4.', 'success');
                setTimeout(function(){ location.reload(); }, 1000);
            } else {
                showToast('\uc624\ub958: ' + (d.msg || '\uc0ad\uc81c\uc5d0 \uc2e4\ud328\ud588\uc2b5\ub2c8\ub2e4.'), 'error');
            }
        })
        .catch(function(){ showToast('\uc694\uccad \uc911 \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.', 'error'); });
    });
})();
(function () {
    'use strict';

    var overlay  = document.getElementById('albaAdminOverlay');
    var aaClose  = document.getElementById('aaClose');
    var aaCancel = document.getElementById('aaCancel');

    var currentId    = null;
    var currentTitle = '';

    function openAdminPanel(id) {
        currentId    = id;
        currentTitle = '';
        setText('aaTitle', '불러오는 중...');
        setHTML('aaInfoList', '<div style="padding:20px 0;text-align:center;color:#94A3B8;font-size:13px;">로딩 중...</div>');
        setHTML('aaContent', '');
        overlay.classList.add('show');

        fetch(CTX + '/admin/alba/detail?id=' + id)
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (!d.success) { setText('aaTitle', '불러오기 실패'); return; }
                currentTitle = d.posting ? (d.posting.title || '') : '';
                renderPanel(d.posting, d.images || []);
            })
            .catch(function () {
                setText('aaTitle', '오류 발생');
                setHTML('aaInfoList', '<div style="color:#EF4444;font-size:13px;padding:12px 0;">네트워크 오류가 발생했습니다.</div>');
            });
    }
    window.openAdminPanel = openAdminPanel;

    function closePanel() { overlay.classList.remove('show'); }

    aaClose.addEventListener('click',  closePanel);
    aaCancel.addEventListener('click', closePanel);
    overlay.addEventListener('click', function (e) { if (e.target === overlay) closePanel(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closePanel();
    });

    var aaDeleteBtn = document.getElementById('aaDeleteBtn');
    if (aaDeleteBtn) {
        aaDeleteBtn.addEventListener('click', function () {
            if (!currentId) return;
            closePanel();
            setTimeout(function () { confirmDelete(currentId, currentTitle); }, 250);
        });
    }

    function renderPanel(p, images) {
        setText('aaTitle', p.title || '(제목 없음)');

        var dlVal  = p.deadline ? p.deadline.substring(0, 10) + ' 마감' : '상시채용';
        var payVal = (p.payType && p.pay) ? (p.payType + ' ' + numFormat(p.pay) + '원') : '-';
        var timeVal = (p.startTime && p.endTime)
            ? p.startTime + ' ~ ' + p.endTime + (p.timeNegotiable === 'Y' ? ' (협의가능)' : '')
            : '-';

        var rows = [
            { label: '업체명',   val: p.employer  || '-' },
            { label: '카테고리', val: p.category  || '기타' },
            { label: '급여',     val: payVal },
            { label: '근무기간', val: p.workPeriod || '-' },
            { label: '근무요일', val: p.workDays   || '-' },
            { label: '근무시간', val: timeVal },
            { label: '근무지',   val: p.location  || '-' },
            { label: '마감일',   val: dlVal, color: p.deadline ? '#EF4444' : '#10B981' },
            { label: '복리후생', val: p.benefits  || '-' },
            { label: '연락처',   val: p.contact   || '-' },
            { label: '조회수',   val: (p.hitCount || 0) + '회' }
        ];

        setHTML('aaInfoList', rows.map(function (row, i) {
            var valHtml = row.color
                ? '<span style="font-weight:700;color:' + row.color + ';">' + esc(String(row.val)) + '</span>'
                : esc(String(row.val));
            return (i > 0 ? '<div style="height:1px;background:#F1F5F9;"></div>' : '')
                + '<div class="rpt-info-row"><span class="rpt-info-key">' + row.label + '</span>'
                + '<span class="rpt-info-val">' + valHtml + '</span></div>';
        }).join(''));

        var desc = p.description ? String(p.description).trim() : '';
        if (desc) {
            var tmp = document.createElement('div');
            tmp.innerHTML = desc;
            var plain = (tmp.textContent || tmp.innerText || '').trim() || desc;
            setHTML('aaContent', '<span style="white-space:pre-wrap;word-break:break-word;font-size:13px;color:#475569;line-height:1.8;">' + esc(plain) + '</span>');
        } else {
            setHTML('aaContent', '<span style="color:#CBD5E1;font-size:13px;font-style:italic;">공고 내용이 없습니다.</span>');
        }
    }

    function numFormat(n) { return String(n || 0).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
    function setText(id, val) { var el = document.getElementById(id); if (el) el.textContent = val; }
    function setHTML(id, val) { var el = document.getElementById(id); if (el) el.innerHTML = val; }
    function esc(str) { return String(str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
})();