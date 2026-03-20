(function () {
    'use strict';
    var overlay  = document.getElementById('communityDetailOverlay');
    var modalBox = document.getElementById('cdModalBox');
    var cdClose  = document.getElementById('cdClose');
    var cdCancel = document.getElementById('cdCancel');
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
    var CAT = {
        '1':'일상','일상':'일상','2':'동네질문','동네질문':'동네질문',
        '3':'동네맛집','동네맛집':'동네맛집','4':'같이해요','같이해요':'같이해요',
        '5':'분실/실종','분실/실종':'분실/실종','6':'동네사건사고','동네사건사고':'동네사건사고',
        '7':'생활정보','생활정보':'생활정보','8':'취미생활','취미생활':'취미생활'
    };
    var CAT_COLOR = {
        '일상':'#3B82F6','동네질문':'#8B5CF6','동네맛집':'#F59E0B',
        '같이해요':'#10B981','분실/실종':'#EF4444','동네사건사고':'#F97316',
        '생활정보':'#06B6D4','취미생활':'#EC4899'
    };
    function openDetail(id) {
        setText('cdTitle', '불러오는 중...');
        setText('cdAvatar', '···');
        setText('cdWriter', '');
        setText('cdWriterSub', '');
        setHTML('cdCategoryChip', '');
        setHTML('cdDongChip', '');
        setHTML('cdDateChip', '');
        setHTML('cdViewStat', '');
        setHTML('cdLikeStat', '');
        setHTML('cdContent',
            '<div style="display:flex;align-items:center;gap:10px;color:#94A3B8;padding:20px 0;">'
            + '<i class="ri-loader-4-line" style="font-size:20px;animation:cdSpin 1s linear infinite;"></i>'
            + '<span style="font-size:14px;">게시글 불러오는 중...</span></div>');
        hide('cdPollWrap'); hide('cdImageWrap'); hide('cdAttachWrap');
        hide('cdTagWrap'); hide('cdPlaceWrap');
        setHTML('cdReplies', '');
        setText('cdReplyCount', '0');
        document.getElementById('cdScrollBody').scrollTop = 0;
        openModal();
        fetch(CTX + '/admin/community/detail?id=' + id)
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (!d.success) { setText('cdTitle', '불러오기 실패'); return; }
                renderPost(d.post, d.replies || [], d.pollTotalVotes || 0, d.pollOptionStats || null);
            })
            .catch(function () {
                setText('cdTitle', '오류 발생');
                setHTML('cdContent', '<div style="color:#EF4444;padding:16px 0;font-size:14px;">네트워크 오류가 발생했습니다.</div>');
            });
    }
    window.openDetail = openDetail;
    function renderPost(post, replies, pollTotalVotes, optionStats) {
        setText('cdTitle', post.subject || '(제목 없음)');
        var cat = CAT[post.category] || post.category || '-';
        var cc  = CAT_COLOR[cat] || '#6366F1';
        setHTML('cdCategoryChip', chip(cat, cc, 'ri-hashtag'));
        if (post.dong || post.placeName) {
            setHTML('cdDongChip', chip(post.dong || post.placeName, '#64748B', 'ri-map-pin-2-line'));
        }
        var dateStr = post.regDate ? post.regDate.toString().substring(0, 16).replace('T', ' ') : '-';
        setHTML('cdDateChip', chip(dateStr, '#64748B', 'ri-calendar-2-line'));
        setHTML('cdViewStat',
            '<i class="ri-eye-line" style="font-size:13px;"></i>'
            + '<span>' + (post.hitCount || 0) + '</span>');
        setHTML('cdLikeStat',
            '<i class="ri-heart-line" style="font-size:13px;color:#F43F5E;"></i>'
            + '<span>' + (post.likeCount || 0) + '</span>');
        var nick = post.writerNickname || '익명';
        setText('cdAvatar', nick.charAt(0).toUpperCase());
        setText('cdWriter', nick);
        setText('cdWriterSub', 'No.' + (post.id || '-') + ' · ' + dateStr + ' 작성');
        var tmp = document.createElement('div');
        tmp.innerHTML = post.content || '';
        var plainText = (tmp.textContent || tmp.innerText || '').trim();
        if (plainText) {
            setHTML('cdContent',
                '<div style="font-size:14px;color:#334155;line-height:1.9;white-space:pre-wrap;word-break:break-word;">'
                + esc(plainText) + '</div>');
        } else {
            setHTML('cdContent',
                '<div style="font-size:13px;color:#94A3B8;font-style:italic;">본문 내용이 없습니다.</div>');
        }
        if (post.pollTitle) {
            renderPoll(post, pollTotalVotes, optionStats);
            show('cdPollWrap');
        }
        if (post.imageFiles && post.imageFiles.length > 0) {
            setHTML('cdImages', post.imageFiles.map(function (f) {
                return '<div style="position:relative;display:inline-block;">'
                    + '<img src="' + CTX + '/uploads/community/' + f + '" '
                    + 'style="width:110px;height:82px;object-fit:cover;border-radius:10px;border:1px solid #E2E8F0;'
                    + 'cursor:pointer;transition:all 0.2s;display:block;" '
                    + 'onclick="window.open(this.src,\'_blank\')" '
                    + 'onmouseover="this.style.transform=\'scale(1.04)\';this.style.boxShadow=\'0 6px 20px rgba(0,0,0,0.14)\'" '
                    + 'onmouseout="this.style.transform=\'scale(1)\';this.style.boxShadow=\'none\'" '
                    + 'onerror="this.closest(\'div\').remove()">'
                    + '</div>';
            }).join(''));
            show('cdImageWrap');
        }
        if (post.attachFileInfos && post.attachFileInfos.length > 0) {
            setHTML('cdAttaches', post.attachFileInfos.map(function (af) {
                var sizeKB = af.fileSize ? Math.round(af.fileSize / 1024) + ' KB' : '';
                var ext = (af.originalFilename || '').split('.').pop().toUpperCase();
                return '<div style="display:flex;align-items:center;gap:10px;background:#F8FAFC;'
                    + 'border:1px solid #E2E8F0;border-radius:10px;padding:10px 14px;">'
                    + '<div style="width:32px;height:32px;border-radius:8px;background:#DBEAFE;color:#3B82F6;'
                    + 'display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;flex-shrink:0;">'
                    + esc(ext) + '</div>'
                    + '<div style="min-width:0;flex:1;">'
                    + '<div style="font-size:13px;font-weight:600;color:#1E293B;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'
                    + esc(af.originalFilename || '-') + '</div>'
                    + (sizeKB ? '<div style="font-size:11px;color:#94A3B8;">' + sizeKB + '</div>' : '')
                    + '</div>'
                    + '<a href="' + CTX + '/uploads/community/' + esc(af.saveFilename || '') + '" '
                    + 'download style="color:#3B82F6;font-size:18px;flex-shrink:0;" title="다운로드">'
                    + '<i class="ri-download-line"></i></a>'
                    + '</div>';
            }).join(''));
            show('cdAttachWrap');
        }
        if (post.tags && post.tags.length > 0) {
            setHTML('cdTags', post.tags.map(function (t) {
                return '<span style="display:inline-flex;align-items:center;gap:3px;padding:4px 11px;'
                    + 'border-radius:20px;font-size:12px;font-weight:700;'
                    + 'background:#F0FDF4;color:#16A34A;border:1px solid #BBF7D0;">'
                    + '<i class="ri-hashtag" style="font-size:10px;"></i>' + esc(t) + '</span>';
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
        if (post.pollMultiple) meta.push('복수선택');
        if (post.pollAnonymous) meta.push('익명');
        if (post.pollEndDate) meta.push(post.pollEndDate.substring(0, 10) + ' 마감');
        setHTML('cdPollMeta', meta.length ? meta.join(' · ') : '단일선택');
        var opts = post.pollOptions || [];
        var optHtml = opts.map(function (opt) {
            return '<div style="display:flex;align-items:center;gap:10px;background:rgba(255,255,255,0.7);'
                + 'border:1px solid #DDD6FE;border-radius:10px;padding:10px 14px;">'
                + '<i class="ri-checkbox-blank-circle-line" style="font-size:14px;color:#7C3AED;flex-shrink:0;"></i>'
                + '<span style="font-size:13px;font-weight:600;color:#4C1D95;">' + esc(opt) + '</span>'
                + '</div>';
        }).join('');
        setHTML('cdPollOptions', optHtml);
        setHTML('cdPollFooter',
            '<i class="ri-bar-chart-horizontal-line" style="font-size:13px;"></i>'
            + '<span>총 <strong>' + total + '명</strong> 참여</span>'
            + (opts.length ? '<span style="opacity:0.6;">· 항목 ' + opts.length + '개</span>' : ''));
    }
    function renderReplies(replies) {
        setText('cdReplyCount', replies.length);
        if (replies.length === 0) {
            setHTML('cdReplies',
                '<div style="text-align:center;padding:32px 0;color:#CBD5E1;">'
                + '<i class="ri-chat-3-line" style="font-size:32px;display:block;margin-bottom:8px;"></i>'
                + '<span style="font-size:13px;font-weight:600;">댓글이 없습니다.</span></div>');
            return;
        }
        var html = replies.map(function (r) {
            var nick     = r.writerNickname || '익명';
            var dateStr  = r.regDate ? r.regDate.toString().substring(0, 16).replace('T', ' ') : '-';
            var isReply  = r.depth > 0;
            var isDel    = r.deleted;
            return '<div style="' + (isReply ? 'padding-left:32px;' : '') + '">'
                + '<div style="background:' + (isDel ? '#F8FAFC' : '#fff') + ';'
                + 'border:1px solid ' + (isReply ? '#EDE9FE' : '#E2E8F0') + ';'
                + 'border-radius:14px;padding:12px 16px;'
                + (isReply ? 'border-left:3px solid #A5B4FC;' : '')
                + 'transition:box-shadow 0.15s;" '
                + 'onmouseover="this.style.boxShadow=\'0 4px 16px rgba(0,0,0,0.07)\'" '
                + 'onmouseout="this.style.boxShadow=\'none\'">'
                + '<div style="display:flex;align-items:center;gap:8px;margin-bottom:' + (isDel ? '0' : '8px') + ';">'
                + (isReply ? '<span style="font-size:10px;font-weight:700;color:#7C3AED;background:#EDE9FE;padding:2px 8px;border-radius:10px;margin-right:2px;">↳ 답글</span>' : '')
                + '<div style="width:28px;height:28px;border-radius:50%;'
                + 'background:' + (isDel ? '#CBD5E1' : (isReply ? 'linear-gradient(135deg,#8B5CF6,#7C3AED)' : 'linear-gradient(135deg,#7C3AED,#6D28D9)'))
                + ';color:#fff;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:800;flex-shrink:0;">'
                + esc(nick.charAt(0).toUpperCase()) + '</div>'
                + '<span style="font-size:13px;font-weight:700;color:' + (isDel ? '#94A3B8' : '#1E293B') + ';">' + esc(nick) + '</span>'
                + '<span style="font-size:11px;color:#CBD5E1;margin-left:auto;">' + dateStr + '</span>'
                + '</div>'
                + (isDel
                    ? '<p style="font-size:13px;color:#94A3B8;font-style:italic;margin:0;display:flex;align-items:center;gap:5px;">'
                      + '<i class="ri-delete-bin-5-line" style="font-size:12px;"></i>삭제된 댓글입니다.</p>'
                    : '<p style="font-size:13px;color:#475569;line-height:1.7;margin:0;white-space:pre-wrap;word-break:break-word;">'
                      + esc(r.content || '') + '</p>')
                + '</div></div>';
        }).join('');
        setHTML('cdReplies', html);
    }
    function chip(label, color, icon) {
        return '<span style="display:inline-flex;align-items:center;gap:4px;padding:4px 10px;border-radius:20px;'
            + 'font-size:11px;font-weight:700;background:' + color + '22;color:' + color + ';border:1px solid ' + color + '33;">'
            + '<i class="' + icon + '" style="font-size:10px;"></i>' + esc(label) + '</span>';
    }
    function show(id) { var el = document.getElementById(id); if (el) el.style.display = ''; }
    function hide(id) { var el = document.getElementById(id); if (el) el.style.display = 'none'; }
    function setText(id, val) { var el = document.getElementById(id); if (el) el.textContent = val; }
    function setHTML(id, val) { var el = document.getElementById(id); if (el) el.innerHTML = val; }
    function esc(str) {
        return String(str || '')
            .replace(/&/g,'&amp;').replace(/</g,'&lt;')
            .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }
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
    function closeDeleteModal() {
        delOverlay.classList.remove('show');
        pendingId = null;
    }
    deleteClose.addEventListener('click', closeDeleteModal);
    deleteCancel.addEventListener('click', closeDeleteModal);
    delOverlay.addEventListener('click', function (e) { if (e.target === this) closeDeleteModal(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && delOverlay.classList.contains('show')) closeDeleteModal();
    });
    deleteConfirm.addEventListener('click', function () {
        if (!pendingId) return;
        fetch(CTX + '/admin/community/delete', {
            method : 'POST',
            headers: { 'Content-Type': 'application/json' },
            body   : JSON.stringify({ id: pendingId })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) {
                closeDeleteModal();
                showToast('게시글이 삭제되었습니다.', 'success');
                setTimeout(function () { location.reload(); }, 1000);
            } else {
                showToast('오류: ' + (d.msg || '삭제에 실패했습니다.'), 'error');
            }
        })
        .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
    });
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
    function closeDeleteModal() {
        delOverlay.classList.remove('show');
        pendingId = null;
    }
    deleteClose.addEventListener('click', closeDeleteModal);
    deleteCancel.addEventListener('click', closeDeleteModal);
    delOverlay.addEventListener('click', function (e) { if (e.target === this) closeDeleteModal(); });
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape' && delOverlay.classList.contains('show')) closeDeleteModal();
    });
    deleteConfirm.addEventListener('click', function () {
        if (!pendingId) return;
        fetch(CTX + '/admin/community/delete', {
            method : 'POST',
            headers: { 'Content-Type': 'application/json' },
            body   : JSON.stringify({ id: pendingId })
        })
        .then(function (r) { return r.json(); })
        .then(function (d) {
            if (d.success) {
                closeDeleteModal();
                showToast('게시글이 삭제되었습니다.', 'success');
                setTimeout(function () { location.reload(); }, 1000);
            } else {
                showToast('오류: ' + (d.msg || '삭제에 실패했습니다.'), 'error');
            }
        })
        .catch(function () { showToast('요청 중 오류가 발생했습니다.', 'error'); });
    });
})();