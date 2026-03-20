/* ================================================================
   trade_list.js - 중고거래 관리 상세보기 & 삭제
   ================================================================ */
(function () {
    'use strict';

    var overlay  = document.getElementById('tradeDetailOverlay');
    var modalBox = document.getElementById('tdModalBox');
    var tdClose  = document.getElementById('tdClose');
    var tdCancel = document.getElementById('tdCancel');

    /* 현재 열린 게시글 추적 */
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

    tdClose.addEventListener('click',  closeDetail);
    tdCancel.addEventListener('click', closeDetail);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeDetail(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeDetail();
    });

    /* 모달 내 삭제 버튼 */
    var tdDeleteBtn = document.getElementById('tdDeleteBtn');
    if (tdDeleteBtn) {
        tdDeleteBtn.addEventListener('click', function () {
            if (!currentDetailId) return;
            closeDetail();
            setTimeout(function () { confirmDelete(currentDetailId, currentDetailTitle); }, 320);
        });
    }

    var STATUS_COLOR = {
        '\ud310\ub9e4\uc911'  : '#10B981',
        '\uc608\uc57d\uc911'  : '#3B82F6',
        '\ud310\ub9e4\uc644\ub8cc': '#94A3B8',
        '\uc228\uae30\uae30'  : '#EF4444'
    };
    var TYPE_COLOR = {
        '\uc9c1\uac70\ub798'  : '#6366F1',
        '\ud0dd\ubc30\uac70\ub798': '#F59E0B',
        '\ubaa8\ub450\uac00\ub2a5': '#8B5CF6'
    };

    function openDetail(id) {
        currentDetailId    = id;
        currentDetailTitle = '';
        setText('tdTitle', '\ubd88\ub7ec\uc624\ub294 \uc911...');
        setText('tdAvatar', '\xB7\xB7\xB7'); setText('tdWriter',''); setText('tdWriterSub','');
        setHTML('tdStatusChip',''); setHTML('tdTypeChip',''); setHTML('tdDongChip','');
        setHTML('tdViewStat',''); setHTML('tdLikeStat',''); setHTML('tdChatStat',''); setHTML('tdPriceBox','');
        setHTML('tdContent',
            '<div style="display:flex;align-items:center;gap:10px;color:#94A3B8;padding:20px 0;">'
            + '<i class="ri-loader-4-line" style="font-size:20px;animation:tdSpin 1s linear infinite;"></i>'
            + '<span style="font-size:14px;">\uac8c\uc2dc\uae00 \ubd88\ub7ec\uc624\ub294 \uc911...</span></div>');
        hide('tdImageWrap'); hide('tdTagWrap');
        setHTML('tdInfoGrid', '');
        document.getElementById('tdScrollBody').scrollTop = 0;
        openModal();

        fetch(CTX + '/admin/trade/detail?id=' + id)
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (!d.success) { setText('tdTitle', '\ubd88\ub7ec\uc624\uae30 \uc2e4\ud328'); return; }
                currentDetailTitle = d.trade ? (d.trade.title || '') : '';
                renderTrade(d.trade, d.images || [], d.tags || []);
            })
            .catch(function () {
                setText('tdTitle', '\uc624\ub958 \ubc1c\uc0dd');
                setHTML('tdContent', '<div style="color:#EF4444;padding:16px 0;font-size:14px;">\ub124\ud2b8\uc6cc\ud06c \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.</div>');
            });
    }
    window.openDetail = openDetail;

    function renderTrade(t, images, tags) {
        setText('tdTitle', t.title || '(\uc81c\ubaa9 \uc5c6\uc74c)');

        var sc = STATUS_COLOR[t.tradeStatus] || '#94A3B8';
        var tc = TYPE_COLOR[t.tradeType]     || '#94A3B8';
        setHTML('tdStatusChip', chip(t.tradeStatus || '-', sc, 'ri-checkbox-circle-line'));
        if (t.tradeType) setHTML('tdTypeChip', chip(t.tradeType, tc, 'ri-truck-line'));
        if (t.dong)      setHTML('tdDongChip', chip(t.dong, '#64748B', 'ri-map-pin-2-line'));

        setHTML('tdViewStat', '<i class="ri-eye-line" style="font-size:13px;"></i><span>' + (t.hitCount  || 0) + '</span>');
        setHTML('tdLikeStat', '<i class="ri-heart-line" style="font-size:13px;color:#F43F5E;"></i><span>' + (t.likeCount || 0) + '</span>');
        setHTML('tdChatStat', '<i class="ri-chat-3-line" style="font-size:13px;color:#A5B4FC;"></i><span>' + (t.chatCount || 0) + '</span>');

        var nick = t.nickName || '\uc54c \uc218 \uc5c6\uc74c';
        setText('tdAvatar', nick.charAt(0).toUpperCase());
        setText('tdWriter',    nick);
        var dateStr = t.createdDate ? String(t.createdDate).substring(0,10) : '-';
        setText('tdWriterSub', 'No.' + (t.productIdx || '-') + ' \xB7 ' + dateStr + ' \ub4f1\ub85d');

        var priceHtml;
        if (!t.price || t.price === 0) {
            priceHtml = '<span style="display:inline-flex;align-items:center;gap:5px;padding:6px 14px;border-radius:20px;background:#DCFCE7;color:#16A34A;font-size:14px;font-weight:800;"><i class="ri-gift-line"></i>\ubb34\ub8cc\ub098\ub214</span>';
        } else {
            priceHtml = '<span style="font-size:18px;font-weight:900;color:#312E81;">' + numFormat(t.price) + '<span style="font-size:13px;font-weight:600;">\uc6d0</span></span>';
            if (t.shippingFee && t.shippingFee > 0) {
                priceHtml += '<div style="font-size:11px;color:#94A3B8;text-align:right;margin-top:2px;">\ud0dd\ubc30\ube44 ' + numFormat(t.shippingFee) + '\uc6d0 \ubcc4\ub3c4</div>';
            }
        }
        setHTML('tdPriceBox', '<div style="text-align:right;">' + priceHtml + '</div>');

        var tmp = document.createElement('div');
        tmp.innerHTML = t.content || '';
        var plain = (tmp.textContent || tmp.innerText || '').trim();
        if (plain) {
            setHTML('tdContent', '<div style="font-size:14px;color:#334155;line-height:1.9;white-space:pre-wrap;word-break:break-word;">' + esc(plain) + '</div>');
        } else {
            setHTML('tdContent', '<div style="font-size:13px;color:#94A3B8;font-style:italic;">\ubcf8\ubb38 \ub0b4\uc6a9\uc774 \uc5c6\uc2b5\ub2c8\ub2e4.</div>');
        }

        if (images.length > 0) {
            setHTML('tdImages', images.map(function(img) {
                var url = CTX + (img.imgUrl || '');
                return '<div style="display:inline-block;"><img src="' + url + '" '
                    + 'style="width:110px;height:82px;object-fit:cover;border-radius:10px;border:1px solid #E2E8F0;cursor:pointer;transition:all .2s;display:block;" '
                    + 'onclick="window.open(this.src,\'_blank\')" '
                    + 'onmouseover="this.style.transform=\'scale(1.04)\';this.style.boxShadow=\'0 6px 20px rgba(0,0,0,.14)\'" '
                    + 'onmouseout="this.style.transform=\'scale(1)\';this.style.boxShadow=\'none\'" '
                    + 'onerror="this.closest(\'div\').remove()"></div>';
            }).join(''));
            show('tdImageWrap');
        }

        if (tags.length > 0) {
            setHTML('tdTags', tags.map(function(tag) {
                return '<span style="display:inline-flex;align-items:center;gap:3px;padding:4px 11px;border-radius:20px;font-size:12px;font-weight:700;background:#EDE9FE;color:#6D28D9;border:1px solid #DDD6FE;">'
                    + '<i class="ri-hashtag" style="font-size:10px;"></i>' + esc(tag) + '</span>';
            }).join(''));
            show('tdTagWrap');
        }

        var infoItems = [
            { icon:'ri-price-tag-3-line',  label:'\uc0c1\ud488 \uc0c1\ud0dc', val: t.productStatus  || '-' },
            { icon:'ri-exchange-line',      label:'\uac70\ub798 \uc720\ud615', val: t.tradeType      || '-' },
            { icon:'ri-map-pin-line',       label:'\uac70\ub798 \uc7a5\uc18c', val: t.tradePlace     || '-' },
            { icon:'ri-map-2-line',         label:'\ub3d9\ub124',               val: t.dong           || '-' },
            { icon:'ri-heart-line',         label:'\uad00\uc2ec',               val: (t.likeCount  || 0) + '\uba85' },
            { icon:'ri-chat-3-line',        label:'\ucc44\ud305',               val: (t.chatCount  || 0) + '\uac74' },
            { icon:'ri-calendar-line',      label:'\ub4f1\ub85d\uc77c',         val: dateStr },
            { icon:'ri-refresh-line',       label:'\ucd5c\uadfc \ub04c\uc62c',  val: t.lastUpDate ? String(t.lastUpDate).substring(0,10) : '-' }
        ];
        setHTML('tdInfoGrid', infoItems.map(function(item) {
            return '<div style="background:#F8FAFC;border:1px solid #E2E8F0;border-radius:12px;padding:12px 14px;display:flex;align-items:center;gap:10px;">'
                + '<div style="width:28px;height:28px;border-radius:8px;background:#EDE9FE;color:#7C3AED;display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0;">'
                + '<i class="' + item.icon + '"></i></div>'
                + '<div><div style="font-size:10px;color:#94A3B8;font-weight:700;text-transform:uppercase;letter-spacing:.06em;">' + item.label + '</div>'
                + '<div style="font-size:13px;font-weight:700;color:#1E293B;margin-top:2px;">' + esc(String(item.val)) + '</div></div>'
                + '</div>';
        }).join(''));
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

    if (!document.getElementById('tdSpinStyle')) {
        var s = document.createElement('style');
        s.id = 'tdSpinStyle';
        s.textContent = '@keyframes tdSpin{to{transform:rotate(360deg)}}';
        document.head.appendChild(s);
    }
})();

/* ================================================================
   삭제 확인 모달
   ================================================================ */
(function () {
    'use strict';
    var pendingId     = null;
    var delOverlay    = document.getElementById('tradeDeleteOverlay');
    var deleteClose   = document.getElementById('tradeDeleteClose');
    var deleteCancel  = document.getElementById('tradeDeleteCancel');
    var deleteConfirm = document.getElementById('tradeDeleteConfirm');
    var targetTitle   = document.getElementById('tradeDeleteTargetTitle');

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
        fetch(CTX + '/admin/trade/delete', {
            method:'POST', headers:{'Content-Type':'application/json'},
            body: JSON.stringify({ id: pendingId })
        })
        .then(function(r){ return r.json(); })
        .then(function(d){
            if (d.success) {
                closeDeleteModal();
                showToast('\uac8c\uc2dc\uae00\uc774 \uc0ad\uc81c\ub418\uc5c8\uc2b5\ub2c8\ub2e4.', 'success');
                setTimeout(function(){ location.reload(); }, 1000);
            } else {
                showToast('\uc624\ub958: ' + (d.msg || '\uc0ad\uc81c\uc5d0 \uc2e4\ud328\ud588\uc2b5\ub2c8\ub2e4.'), 'error');
            }
        })
        .catch(function(){ showToast('\uc694\uccad \uc911 \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.', 'error'); });
    });
})();