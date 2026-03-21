(function () {
    'use strict';
    var overlay  = document.getElementById('communityDetailOverlay');
    var modalBox = document.getElementById('cdModalBox');
    var cdClose  = document.getElementById('cdClose');
    var cdCancel = document.getElementById('cdCancel');

    /* 현재 열린 게시글 추적 (모달 내 삭제버튼용) */
    var currentDetailId    = null;
    var currentDetailTitle = '';

    function openModal() {
        overlay.classList.add('show');
        requestAnimationFrame(function () {
            modalBox.style.opacity = '1';
            modalBox.style.transform = 'translateY(0) scale(1)';
        });
    }
    function closeDetail() {
        modalBox.style.opacity = '0';
        modalBox.style.transform = 'translateY(20px) scale(0.97)';
        setTimeout(function () { overlay.classList.remove('show'); }, 300);
    }
    cdClose.addEventListener('click', closeDetail);
    cdCancel.addEventListener('click', closeDetail);
    overlay.addEventListener('click', function (e) { if (e.target === this) closeDetail(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closeDetail();
    });

    /* 모달 내 삭제 버튼 */
    var cdDeleteBtn = document.getElementById('cdDeleteBtn');
    if (cdDeleteBtn) {
        cdDeleteBtn.addEventListener('click', function () {
            if (!currentDetailId) return;
            closeDetail();
            setTimeout(function () { confirmDelete(currentDetailId, currentDetailTitle); }, 320);
        });
    }

    var CAT = {
        '1':'\uc77c\uc0c1','\uc77c\uc0c1':'\uc77c\uc0c1','2':'\ub3d9\ub124\uc9c8\ub254','\ub3d9\ub124\uc9c8\ub254':'\ub3d9\ub144\uc9c8\ub254',
        '3':'\ub3d9\ub144\ub9db\uc9d1','\ub3d9\ub144\ub9db\uc9d1':'\ub3d9\ub144\ub9db\uc9d1','4':'\uac19\uc774\ud574\uc694','\uac19\uc774\ud574\uc694':'\uac19\uc774\ud574\uc694',
        '5':'\ubd84\uc2e4/\uc2e4\uc885','\ubd84\uc2e4/\uc2e4\uc885':'\ubd84\uc2e4/\uc2e4\uc885','6':'\ub3d9\ub144\uc0ac\uac74\uc0ac\uace0','\ub3d9\ub144\uc0ac\uac74\uc0ac\uace0':'\ub3d9\ub144\uc0ac\uac74\uc0ac\uace0',
        '7':'\uc0dd\ud65c\uc815\ubcf4','\uc0dd\ud65c\uc815\ubcf4':'\uc0dd\ud65c\uc815\ubcf4','8':'\ucde8\ubbf8\uc0dd\ud65c','\ucde8\ubbf8\uc0dd\ud65c':'\ucde8\ubbf8\uc0dd\ud65c'
    };
    var CAT_COLOR = {
        '\uc77c\uc0c1':'#3B82F6','\ub3d9\ub144\uc9c8\ub254':'#8B5CF6','\ub3d9\ub144\ub9db\uc9d1':'#F59E0B',
        '\uac19\uc774\ud574\uc694':'#10B981','\ubd84\uc2e4/\uc2e4\uc885':'#EF4444','\ub3d9\ub144\uc0ac\uac74\uc0ac\uace0':'#F97316',
        '\uc0dd\ud65c\uc815\ubcf4':'#06B6D4','\ucde8\ubbf8\uc0dd\ud65c':'#EC4899'
    };

    function openDetail(id) {
        currentDetailId    = id;
        currentDetailTitle = '';
        setText('cdTitle', '\ubd88\ub7ec\uc624\ub294 \uc911...');
        setText('cdAvatar', '\xB7\xB7\xB7');
        setText('cdWriter', ''); setText('cdWriterSub', '');
        setHTML('cdCategoryChip', ''); setHTML('cdDongChip', ''); setHTML('cdDateChip', '');
        setHTML('cdViewStat', ''); setHTML('cdLikeStat', '');
        setHTML('cdContent',
            '<div style="display:flex;align-items:center;gap:10px;color:#94A3B8;padding:20px 0;">'
            + '<i class="ri-loader-4-line" style="font-size:20px;animation:cdSpin 1s linear infinite;"></i>'
            + '<span style="font-size:14px;">\uac8c\uc2dc\uae00 \ubd88\ub7ec\uc624\ub294 \uc911...</span></div>');
        hide('cdPollWrap'); hide('cdImageWrap'); hide('cdAttachWrap');
        hide('cdTagWrap'); hide('cdPlaceWrap');
        setHTML('cdReplies', ''); setText('cdReplyCount', '0');
        document.getElementById('cdScrollBody').scrollTop = 0;
        openModal();
        fetch(CTX + '/admin/community/detail?id=' + id)
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (!d.success) { setText('cdTitle', '\ubd88\ub7ec\uc624\uae30 \uc2e4\ud328'); return; }
                currentDetailTitle = d.post ? (d.post.subject || '') : '';
                renderPost(d.post, d.replies || [], d.pollTotalVotes || 0, d.pollOptionStats || null);
            })
            .catch(function () {
                setText('cdTitle', '\uc624\ub958 \ubc1c\uc0dd');
                setHTML('cdContent', '<div style="color:#EF4444;padding:16px 0;font-size:14px;">\ub124\ud2b8\uc6cc\ud06c \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.</div>');
            });
    }
    window.openDetail = openDetail;

    function renderPost(post, replies, pollTotalVotes, optionStats) {
        setText('cdTitle', post.subject || '(\uc81c\ubaa9 \uc5c6\uc74c)');
        var cat = CAT[post.category] || post.category || '-';
        var cc  = CAT_COLOR[cat] || '#6366F1';
        setHTML('cdCategoryChip', chip(cat, cc, 'ri-hashtag'));
        if (post.dong || post.placeName) {
            setHTML('cdDongChip', chip(post.dong || post.placeName, '#64748B', 'ri-map-pin-2-line'));
        }
        var dateStr = post.regDate ? post.regDate.toString().substring(0, 16).replace('T', ' ') : '-';
        setHTML('cdDateChip', chip(dateStr, '#64748B', 'ri-calendar-2-line'));
        setHTML('cdViewStat', '<i class="ri-eye-line" style="font-size:13px;"></i><span>' + (post.hitCount || 0) + '</span>');
        setHTML('cdLikeStat', '<i class="ri-heart-line" style="font-size:13px;color:#F43F5E;"></i><span>' + (post.likeCount || 0) + '</span>');
        var nick = post.writerNickname || '\uc775\uba85';
        setText('cdAvatar', nick.charAt(0).toUpperCase());
        setText('cdWriter', nick);
        setText('cdWriterSub', 'No.' + (post.id || '-') + ' \xB7 ' + dateStr + ' \uc791\uc131');
        var tmp = document.createElement('div');
        tmp.innerHTML = post.content || '';
        var plainText = (tmp.textContent || tmp.innerText || '').trim();
        if (plainText) {
            setHTML('cdContent', '<div style="font-size:14px;color:#334155;line-height:1.9;white-space:pre-wrap;word-break:break-word;">' + esc(plainText) + '</div>');
        } else {
            setHTML('cdContent', '<div style="font-size:13px;color:#94A3B8;font-style:italic;">\ubcf8\ubb38 \ub0b4\uc6a9\uc774 \uc5c6\uc2b5\ub2c8\ub2e4.</div>');
        }
        if (post.pollTitle) { renderPoll(post, pollTotalVotes, optionStats); show('cdPollWrap'); }
        if (post.imageFiles && post.imageFiles.length > 0) {
            setHTML('cdImages', post.imageFiles.map(function (f) {
                return '<div style="position:relative;display:inline-block;">'
                    + '<img src="' + CTX + '/uploads/community/' + f + '" '
                    + 'style="width:110px;height:82px;object-fit:cover;border-radius:10px;border:1px solid #E2E8F0;cursor:pointer;transition:all 0.2s;display:block;" '
                    + 'onclick="window.open(this.src,\'_blank\')" '
                    + 'onmouseover="this.style.transform=\'scale(1.04)\';this.style.boxShadow=\'0 6px 20px rgba(0,0,0,0.14)\'" '
                    + 'onmouseout="this.style.transform=\'scale(1)\';this.style.boxShadow=\'none\'" '
                    + 'onerror="this.closest(\'div\').remove()"></div>';
            }).join(''));
            show('cdImageWrap');
        }
        if (post.attachFileInfos && post.attachFileInfos.length > 0) {
            setHTML('cdAttaches', post.attachFileInfos.map(function (af) {
                var sizeKB = af.fileSize ? Math.round(af.fileSize / 1024) + ' KB' : '';
                var ext = (af.originalFilename || '').split('.').pop().toUpperCase();
                return '<div style="display:flex;align-items:center;gap:10px;background:#F8FAFC;border:1px solid #E2E8F0;border-radius:10px;padding:10px 14px;">'
                    + '<div style="width:32px;height:32px;border-radius:8px;background:#DBEAFE;color:#3B82F6;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;flex-shrink:0;">' + esc(ext) + '</div>'
                    + '<div style="min-width:0;flex:1;"><div style="font-size:13px;font-weight:600;color:#1E293B;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">' + esc(af.originalFilename || '-') + '</div>'
                    + (sizeKB ? '<div style="font-size:11px;color:#94A3B8;">' + sizeKB + '</div>' : '') + '</div>'
                    + '<a href="' + CTX + '/uploads/community/' + esc(af.saveFilename || '') + '" download style="color:#3B82F6;font-size:18px;flex-shrink:0;" title="\ub2e4\uc6b4\ub85c\ub4dc"><i class="ri-download-line"></i></a></div>';
            }).join(''));
            show('cdAttachWrap');
        }
        if (post.tags && post.tags.length > 0) {
            setHTML('cdTags', post.tags.map(function (t) {
                return '<span style="display:inline-flex;align-items:center;gap:3px;padding:4px 11px;border-radius:20px;font-size:12px;font-weight:700;background:#F0FDF4;color:#16A34A;border:1px solid #BBF7D0;"><i class="ri-hashtag" style="font-size:10px;"></i>' + esc(t) + '</span>';
            }).join(''));
            show('cdTagWrap');
        }
        if (post.placeName) {
            setText('cdPlaceName', post.placeName);
            setText('cdPlaceAddr', post.address || '');
            var lat = post.latitude, lng = post.longitude;
            if (lat && lng) {
                document.getElementById('cdPlaceBox').onclick = function () {
                    window.open('https://map.kakao.com/link/map/' + encodeURIComponent(post.placeName) + ',' + lat + ',' + lng, '_blank');
                };
            } else {
                document.getElementById('cdPlaceBox').style.cursor = 'default';
                document.getElementById('cdPlaceBox').querySelector('.ri-external-link-line').style.display = 'none';
            }
            show('cdPlaceWrap');
        }
        renderReplies(replies);
    }
    function renderPoll(post, total) {
        setText('cdPollTitle', post.pollTitle || '');
        var meta = [];
        if (post.pollMultiple)  meta.push('\ubcf5\uc218\uc120\ud0dd');
        if (post.pollAnonymous) meta.push('\uc775\uba85');
        if (post.pollEndDate)   meta.push(post.pollEndDate.substring(0, 10) + ' \ub9c8\uac10');
        setHTML('cdPollMeta', meta.length ? meta.join(' \xB7 ') : '\ub2e8\uc77c\uc120\ud0dd');
        var opts = post.pollOptions || [];
        setHTML('cdPollOptions', opts.map(function (opt) {
            return '<div style="display:flex;align-items:center;gap:10px;background:rgba(255,255,255,0.7);border:1px solid #DDD6FE;border-radius:10px;padding:10px 14px;">'
                + '<i class="ri-checkbox-blank-circle-line" style="font-size:14px;color:#7C3AED;flex-shrink:0;"></i>'
                + '<span style="font-size:13px;font-weight:600;color:#4C1D95;">' + esc(opt) + '</span></div>';
        }).join(''));
        setHTML('cdPollFooter',
            '<i class="ri-bar-chart-horizontal-line" style="font-size:13px;"></i>'
            + '<span>\uc694 <strong>' + total + '\uba85</strong> \ucc38\uc5ec</span>'
            + (opts.length ? '<span style="opacity:0.6;">\xB7 \ud56d\ubaa9 ' + opts.length + '\uac1c</span>' : ''));
    }
    function renderReplies(replies) {
        setText('cdReplyCount', replies.length);
        if (replies.length === 0) {
            setHTML('cdReplies', '<div style="text-align:center;padding:32px 0;color:#CBD5E1;"><i class="ri-chat-3-line" style="font-size:32px;display:block;margin-bottom:8px;"></i><span style="font-size:13px;font-weight:600;">\ub313\uae00\uc774 \uc5c6\uc2b5\ub2c8\ub2e4.</span></div>');
            return;
        }
        setHTML('cdReplies', replies.map(function (r) {
            var nick    = r.writerNickname || '\uc775\uba85';
            var dateStr = r.regDate ? r.regDate.toString().substring(0, 16).replace('T', ' ') : '-';
            var isReply = r.depth > 0;
            var isDel   = r.deleted;
            return '<div style="' + (isReply ? 'padding-left:32px;' : '') + '">'
                + '<div style="background:' + (isDel ? '#F8FAFC' : '#fff') + ';border:1px solid ' + (isReply ? '#EDE9FE' : '#E2E8F0') + ';border-radius:14px;padding:12px 16px;' + (isReply ? 'border-left:3px solid #A5B4FC;' : '') + 'transition:box-shadow 0.15s;" onmouseover="this.style.boxShadow=\'0 4px 16px rgba(0,0,0,0.07)\'" onmouseout="this.style.boxShadow=\'none\'">'
                + '<div style="display:flex;align-items:center;gap:8px;margin-bottom:' + (isDel ? '0' : '8px') + ';">'
                + (isReply ? '<span style="font-size:10px;font-weight:700;color:#7C3AED;background:#EDE9FE;padding:2px 8px;border-radius:10px;margin-right:2px;">\u21b3 \ub2f5\uae00</span>' : '')
                + '<div style="width:28px;height:28px;border-radius:50%;background:' + (isDel ? '#CBD5E1' : (isReply ? 'linear-gradient(135deg,#8B5CF6,#7C3AED)' : 'linear-gradient(135deg,#7C3AED,#6D28D9)')) + ';color:#fff;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;flex-shrink:0;">' + esc(nick.charAt(0).toUpperCase()) + '</div>'
                + '<span style="font-size:13px;font-weight:700;color:' + (isDel ? '#94A3B8' : '#1E293B') + ';">' + esc(nick) + '</span>'
                + '<span style="font-size:11px;color:#CBD5E1;margin-left:auto;">' + dateStr + '</span>'
                + '</div>'
                + (isDel ? '<p style="font-size:13px;color:#94A3B8;font-style:italic;margin:0;display:flex;align-items:center;gap:5px;"><i class="ri-delete-bin-5-line" style="font-size:12px;"></i>\uc0ad\uc81c\ub41c \ub313\uae00\uc785\ub2c8\ub2e4.</p>' : '<p style="font-size:13px;color:#475569;line-height:1.7;margin:0;white-space:pre-wrap;word-break:break-word;">' + esc(r.content || '') + '</p>')
                + '</div></div>';
        }).join(''));
    }
    function chip(label, color, icon) {
        return '<span style="display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:20px;font-size:11px;font-weight:700;background:' + color + '22;color:' + color + ';border:1px solid ' + color + '33;"><i class="' + icon + '" style="font-size:10px;"></i>' + esc(label) + '</span>';
    }
    function show(id) { var el = document.getElementById(id); if (el) el.style.display = ''; }
    function hide(id) { var el = document.getElementById(id); if (el) el.style.display = 'none'; }
    function setText(id, val) { var el = document.getElementById(id); if (el) el.textContent = val; }
    function setHTML(id, val) { var el = document.getElementById(id); if (el) el.innerHTML = val; }
    function esc(str) { return String(str || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
    if (!document.getElementById('cdSpinStyle')) {
        var s = document.createElement('style');
        s.id = 'cdSpinStyle';
        s.textContent = '@keyframes cdSpin{to{transform:rotate(360deg)}} #communityDetailOverlay .rpt-modal{display:none}';
        document.head.appendChild(s);
    }
})();

(function () {
    'use strict';
    var pendingId     = null;
    var delOverlay    = document.getElementById('deleteOverlay');
    var deleteClose   = document.getElementById('deleteClose');
    var deleteCancel  = document.getElementById('deleteCancel');
    var deleteConfirm = document.getElementById('deleteConfirm');
    var targetTitle   = document.getElementById('deleteTargetTitle');
    function confirmDelete(id, subject) {
        pendingId = id;
        if (targetTitle) targetTitle.textContent = subject;
        delOverlay.classList.add('show');
    }
    window.confirmDelete = confirmDelete;
    function closeDeleteModal() { delOverlay.classList.remove('show'); pendingId = null; }
    deleteClose.addEventListener('click', closeDeleteModal);
    deleteCancel.addEventListener('click', closeDeleteModal);
    delOverlay.addEventListener('click', function (e) { if (e.target === this) closeDeleteModal(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && delOverlay.classList.contains('show')) closeDeleteModal();
    });
    deleteConfirm.addEventListener('click', function () {
        if (!pendingId) return;
        fetch(CTX + '/admin/community/delete', {
            method:'POST', headers:{'Content-Type':'application/json'},
            body: JSON.stringify({ id: pendingId })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) {
                closeDeleteModal();
                showToast('\uac8c\uc2dc\uae00\uc774 \uc0ad\uc81c\ub418\uc5c8\uc2b5\ub2c8\ub2e4.', 'success');
                setTimeout(function () { location.reload(); }, 1000);
            } else {
                showToast('\uc624\ub958: ' + (d.msg || '\uc0ad\uc81c\uc5d0 \uc2e4\ud328\ud588\uc2b5\ub2c8\ub2e4.'), 'error');
            }
        })
        .catch(function () { showToast('\uc694\uccad \uc911 \uc624\ub958\uac00 \ubc1c\uc0dd\ud588\uc2b5\ub2c8\ub2e4.', 'error'); });
    });
})();
(function () {
    'use strict';

    var overlay  = document.getElementById('communityAdminOverlay');
    var caClose  = document.getElementById('caClose');
    var caCancel = document.getElementById('caCancel');

    var currentId    = null;
    var currentTitle = '';

    var CAT = {
        '1': '일상', '일상': '일상', '2': '동네질문', '동네질문': '동네질문',
        '3': '동네맛집', '동네맛집': '동네맛집', '4': '같이해요', '같이해요': '같이해요',
        '5': '분실/실종', '분실/실종': '분실/실종', '6': '동네사건사고', '동네사건사고': '동네사건사고',
        '7': '생활정보', '생활정보': '생활정보', '8': '취미생활', '취미생활': '취미생활'
    };

    function openAdminPanel(id) {
        currentId    = id;
        currentTitle = '';
        setText('caTitle', '불러오는 중...');
        setHTML('caInfoList', '<div style="padding:20px 0;text-align:center;color:#94A3B8;font-size:13px;">로딩 중...</div>');
        setHTML('caContent', '');
        var sec = document.getElementById('caReplySection');
        if (sec) sec.style.display = 'none';
        overlay.classList.add('show');

        fetch(CTX + '/admin/community/detail?id=' + id)
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (!d.success) { setText('caTitle', '불러오기 실패'); return; }
                currentTitle = d.post ? (d.post.subject || '') : '';
                renderPanel(d.post, d.replies || []);
            })
            .catch(function () {
                setText('caTitle', '오류 발생');
                setHTML('caInfoList', '<div style="color:#EF4444;font-size:13px;padding:12px 0;">네트워크 오류가 발생했습니다.</div>');
            });
    }
    window.openAdminPanel = openAdminPanel;

    function closePanel() { overlay.classList.remove('show'); }

    caClose.addEventListener('click',  closePanel);
    caCancel.addEventListener('click', closePanel);
    overlay.addEventListener('click', function (e) { if (e.target === overlay) closePanel(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && overlay.classList.contains('show')) closePanel();
    });

    var caDeleteBtn = document.getElementById('caDeleteBtn');
    if (caDeleteBtn) {
        caDeleteBtn.addEventListener('click', function () {
            if (!currentId) return;
            closePanel();
            setTimeout(function () { confirmDelete(currentId, currentTitle); }, 250);
        });
    }

    function renderPanel(post, replies) {
        setText('caTitle', post.subject || '(제목 없음)');

        var cat     = CAT[post.category] || post.category || '-';
        var dateStr = post.regDate ? post.regDate.toString().substring(0, 10) : '-';
        var place   = post.dong || post.placeName || '-';

        var rows = [
            { label: '작성자',   val: post.writerNickname || '익명' },
            { label: '카테고리', val: cat },
            { label: '동네',     val: place },
            { label: '조회수',   val: (post.hitCount  || 0) + '회' },
            { label: '좋아요',   val: (post.likeCount || 0) + '개' },
            { label: '댓글',     val: replies.length + '건' },
            { label: '작성일',   val: dateStr }
        ];
        if (post.tags && post.tags.length > 0) {
            rows.push({ label: '태그', val: post.tags.join(', ') });
        }

        setHTML('caInfoList', rows.map(function (row, i) {
            return (i > 0 ? '<div style="height:1px;background:#F1F5F9;"></div>' : '')
                + '<div class="rpt-info-row"><span class="rpt-info-key">' + row.label + '</span>'
                + '<span class="rpt-info-val">' + esc(String(row.val)) + '</span></div>';
        }).join(''));

        var tmp = document.createElement('div');
        tmp.innerHTML = post.content || '';
        var plain = (tmp.textContent || tmp.innerText || '').trim();
        setHTML('caContent', plain
            ? '<span style="white-space:pre-wrap;word-break:break-word;font-size:13px;color:#475569;line-height:1.8;">' + esc(plain) + '</span>'
            : '<span style="color:#CBD5E1;font-size:13px;font-style:italic;">본문 내용이 없습니다.</span>');

        if (replies.length > 0) {
            setText('caReplyCount', replies.length);
            setHTML('caReplies', replies.map(function (r) {
                var nick  = r.writerNickname || '익명';
                var rDate = r.regDate ? r.regDate.toString().substring(0, 10) : '-';
                var isChild = r.depth > 0;
                return '<div style="' + (isChild ? 'padding-left:20px;margin-top:4px;' : 'margin-top:6px;') + '">'
                    + '<div style="background:#F8FAFC;border:1px solid #E2E8F0;border-radius:10px;padding:10px 12px;' + (isChild ? 'border-left:2px solid #A5B4FC;' : '') + '">'
                    + '<div style="display:flex;align-items:center;gap:6px;margin-bottom:4px;">'
                    + (isChild ? '<span style="font-size:10px;color:#7C3AED;font-weight:700;">↳ 답글</span>' : '')
                    + '<span style="font-size:12px;font-weight:700;color:#1E293B;">' + esc(nick) + '</span>'
                    + '<span style="font-size:11px;color:#CBD5E1;margin-left:auto;">' + rDate + '</span>'
                    + '</div>'
                    + (r.deleted
                        ? '<p style="font-size:12px;color:#94A3B8;font-style:italic;margin:0;">삭제된 댓글입니다.</p>'
                        : '<p style="font-size:12px;color:#475569;margin:0;line-height:1.6;white-space:pre-wrap;word-break:break-word;">' + esc(r.content || '') + '</p>')
                    + '</div></div>';
            }).join(''));
            var sec = document.getElementById('caReplySection');
            if (sec) sec.style.display = '';
        }
    }

    function setText(id, val) { var el = document.getElementById(id); if (el) el.textContent = val; }
    function setHTML(id, val) { var el = document.getElementById(id); if (el) el.innerHTML = val; }
    function esc(str) { return String(str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }
})();