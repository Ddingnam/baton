// 전역 뮤트 상태 - 두 IIFE 모두 접근 가능
var _isMutedForNotif = false;

// 전역 토스트 알림
function showToast(msg, type) {
    var colors = { success: '#22c55e', error: '#ef4444', info: '#7c3aed', warning: '#f97316' };
    var el = document.createElement('div');
    el.textContent = msg;
    el.style.cssText = [
        'position:fixed;bottom:80px;right:24px;z-index:999999',
        'background:' + (colors[type] || colors.info),
        'color:#fff;padding:12px 20px;border-radius:12px',
        'font-size:13px;font-weight:700;box-shadow:0 4px 20px rgba(0,0,0,0.2)',
        'transition:opacity .3s;pointer-events:none'
    ].join(';');
    document.body.appendChild(el);
    setTimeout(function() { el.style.opacity = '0'; }, 2500);
    setTimeout(function() { el.remove(); }, 2800);
}

(function () {
    'use strict';
    let stompClient        = null;
    let typingSubscription = null;
    let currentDateStr     = '';
    let typingTimer        = null;
    let isTyping           = false;
    let pendingFile        = null;
    let reconnectCount     = 0;
    let isLeaving          = false;
    const chatArea        = document.getElementById('chatArea');
    const chatInput       = document.getElementById('chatInput');
    const charCounter     = document.getElementById('charCounter');
    const typingIndicator = document.getElementById('typingIndicator');
    const typingLabel     = document.getElementById('typingLabel');
    const fileInput       = document.getElementById('fileInput');
    const imageInput      = document.getElementById('imageInput');
    const attachToggleBtn = document.getElementById('attachToggleBtn');
    const attachMenu      = document.getElementById('attachMenu');
    const filePreviewBar  = document.getElementById('filePreviewBar');
    const filePreviewName = document.getElementById('filePreviewName');
    const emojiPicker     = document.getElementById('emojiPicker');
    function formatBadgeCount(count) { return count > 99 ? '99+' : String(count); }
    function updateStudioUnreadBadge() {
        var badge = document.getElementById('studioChatBadge');
        if (!badge) return;
        fetch(CHAT_CTX + '/admin/chat/unread', { credentials: 'same-origin' })
            .then(function(r) { return r.json(); })
            .then(function(d) {
                var count = Number(d.count || 0);
                if (count > 0) {
                    badge.textContent = formatBadgeCount(count);
                    badge.style.display = '';
                } else {
                    badge.style.display = 'none';
                }
            }).catch(function() {});
    }
    function connect() {
        if (CHAT_ROOM_IDX < 0) return;
        const socket = new SockJS(CHAT_CTX + '/ws/chat');
        stompClient  = Stomp.over(socket);
        stompClient.debug = null;
        stompClient.connect({}, onConnected, onDisconnected);
    }
    function onConnected() {
        reconnectCount = 0;
        setConnStatus(true);
        stompClient.subscribe('/topic/room/' + CHAT_ROOM_IDX, function (frame) {
            handleIncoming(JSON.parse(frame.body));
        });
        typingSubscription = stompClient.subscribe('/topic/typing/' + CHAT_ROOM_IDX, function (frame) {
            const data = JSON.parse(frame.body);
            if (Number(data.userIdx) !== CHAT_MY_IDX) showTyping(data.nickname, data.typing);
        });
        stompClient.subscribe('/topic/presence', function (frame) {
            var data = JSON.parse(frame.body);
            updatePresence(Number(data.userIdx), Number(data.status));
        });
        if (window.ADMIN_USER_IDX) {
            stompClient.subscribe('/topic/alarms/' + window.ADMIN_USER_IDX, function (frame) {
                var raw = frame.body;
                if (!raw || raw === 'read_chat' || raw.startsWith('room_deleted:')) return;
                try {
                    var data = JSON.parse(raw);
                    if (!data || data.type !== 'CHAT' || !data.roomIdx) return;
                    var roomIdx = Number(data.roomIdx);
                    if (roomIdx === CHAT_ROOM_IDX) return;
                    var item = document.querySelector('.chat-room-item[data-roomidx="' + roomIdx + '"]');
                    if (!item) return;
                    var badge = document.getElementById('badge-' + roomIdx);
                    if (!badge) {
                        badge = document.createElement('span');
                        badge.className = 'chat-room-badge';
                        badge.id = 'badge-' + roomIdx;
                        badge.textContent = formatBadgeCount(1);
                        // channel-item-actions 앞에 삽입, 없으면 그냥 append
                        var actions = item.querySelector('.channel-item-actions');
                        if (actions) item.insertBefore(badge, actions);
                        else item.appendChild(badge);
                    } else {
                        var nextCount = Math.min((parseInt(badge.textContent) || 0) + 1, 9999);
                        badge.textContent = formatBadgeCount(nextCount);
                    }
                    var preview = document.getElementById('preview-' + roomIdx);
                    if (data.content) {
                        var previewText = (data.sender ? data.sender + ': ' : '') + data.content;
                        previewText = previewText.length > 20 ? previewText.substring(0, 20) + '…' : previewText;
                        if (preview) {
                            preview.textContent = previewText;
                        } else {
                            var infoDiv = item.querySelector('.chat-room-info');
                            if (infoDiv) {
                                var newPreview = document.createElement('span');
                                newPreview.className = 'chat-room-preview';
                                newPreview.id = 'preview-' + roomIdx;
                                newPreview.textContent = previewText;
                                infoDiv.appendChild(newPreview);
                            }
                        }
                    }
                    // 다른 방 메시지도 인앱 팝업 표시
                    var notifSender = data.sender || '새 메시지';
                    var notifBody   = data.content || '';
                    showInAppNotif(notifSender, notifBody);
                    updateStudioUnreadBadge();
                } catch(e) {}
            });
        }
        clearUnreadBadges();
        sendReadEvent();
        scrollToBottom();
        normalizeExistingTheme();
        setTimeout(function() {
            fetch(CHAT_CTX + '/api/presence/all', { credentials: 'same-origin' })
                .then(function(r) { return r.json(); })
                .then(function(list) {
                    list.forEach(function(item) {
                        updatePresence(Number(item.userIdx), Number(item.status));
                    });
                }).catch(function() {});
        }, 1500);
    }
    function updatePresence(userIdx, status) {
        var cls = status === 1 ? 'online' : status === 2 ? 'away' : '';
        var avt = document.getElementById('avt-' + userIdx);
        if (avt) {
            avt.classList.remove('online', 'away');
            if (cls) avt.classList.add(cls);
        }
		
        var avtDm = document.getElementById('avt-dm-' + userIdx);
        if (avtDm) {
            avtDm.classList.remove('online', 'away');
            if (cls) avtDm.classList.add(cls);
        }

        var dot = document.getElementById('status-' + userIdx);
        if (dot) {
            dot.classList.remove('online', 'away');
            if (cls) dot.classList.add(cls);
        }
    }
    function onDisconnected() {
        if (isLeaving) return;
        setConnStatus(false);
        const delay = Math.min(3000 * Math.pow(1.5, reconnectCount++), 30000);
        setTimeout(connect, delay);
    }
    // ── 인앱 알림 팝업 (카톡 스타일) ──────────────────────
    // _isMutedForNotif는 전역으로 선언 (두 IIFE 모두 접근)
    function escN(s) { return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
    function showInAppNotif(sender, body) {
        if (_isMutedForNotif) return;
        var el = document.getElementById('batonChatNotif');
        if (!el) {
            el = document.createElement('div');
            el.id = 'batonChatNotif';
            el.style.cssText = [
                'position:fixed;bottom:24px;right:24px;z-index:99999',
                'background:var(--card-bg,#fff)',
                'border:1.5px solid var(--border-color,#e5e7eb)',
                'border-radius:16px;padding:14px 18px 14px 14px',
                'box-shadow:0 8px 32px rgba(0,0,0,0.15)',
                'min-width:260px;max-width:320px',
                'display:flex;align-items:flex-start;gap:12px',
                'cursor:pointer;transition:opacity .25s,transform .25s',
                'transform:translateY(0)'
            ].join(';');
            el.addEventListener('click', function() {
                el.style.opacity = '0';
                el.style.transform = 'translateY(12px)';
                setTimeout(function(){ el.style.display='none'; el.style.transform=''; }, 250);
            });
            document.body.appendChild(el);
        }
        el.innerHTML = '<div style="width:36px;height:36px;border-radius:50%;background:var(--grad-primary,#7C3AED);display:flex;align-items:center;justify-content:center;flex-shrink:0;">'
            + '<i class="ri-message-3-fill" style="color:#fff;font-size:16px;"></i></div>'
            + '<div style="flex:1;min-width:0;">'
            + '<div style="font-size:12px;font-weight:800;color:var(--color-purple,#7C3AED);margin-bottom:2px;">💬 새 메시지</div>'
            + '<div style="font-size:13px;font-weight:700;color:var(--text-main,#111);margin-bottom:2px;">' + escN(sender) + '</div>'
            + '<div style="font-size:12px;color:var(--text-sub,#666);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">'
            + escN(body.length > 40 ? body.substring(0,40)+'…' : body) + '</div>'
            + '</div>';
        el.style.display = 'flex';
        el.style.opacity = '1';
        el.style.transform = 'translateY(0)';
        clearTimeout(el._t);
        el._t = setTimeout(function(){
            el.style.opacity = '0';
            el.style.transform = 'translateY(12px)';
            setTimeout(function(){ el.style.display='none'; el.style.transform=''; }, 250);
        }, 4500);
    }
    // ─────────────────────────────────────────────────────

    function handleIncoming(msg) {
        if (msg.msgType === 4) {
            if (Number(msg.userIdx) !== CHAT_MY_IDX) clearUnreadBadges();
            return;
        }
        appendMessage(msg);
        clearUnreadBadges();
        sendReadEvent();
        // 내가 보낸 메시지가 아니면 인앱 팝업 알림
        if (Number(msg.userIdx) !== CHAT_MY_IDX) {
            var sender = msg.nickname || '새 메시지';
            var body   = msg.content  || '';
            if (body.indexOf('__IMG__') === 0) body = '📷 사진';
            else if (body.indexOf('__FILE__') === 0) body = '📎 파일';
            showInAppNotif(sender, body);
        }
    }
    function sendMessage() {
        const text = chatInput.value.trim();
        if ((!text && !pendingFile) || !stompClient || !stompClient.connected) return;
        if (pendingFile) {
            var _file = pendingFile;
            uploadFile(_file, function (url) {
                doSend(url);
                clearFilePreview();
            });
            return;
        }
        doSend(text);
    }
	
	function getCurrentTheme() {
        return document.documentElement.getAttribute('data-theme')
            || window.CHAT_MY_THEME
            || 'purple';
    }

	function doSend(content) {
	    content = content.trim();
	    if (!content) return;

	    stompClient.send('/app/chat/send', {}, JSON.stringify({
	        roomIdx: CHAT_ROOM_IDX,
	        userIdx: CHAT_MY_IDX,
	        nickname: CHAT_MY_NAME,
	        content: content,
	        msgType: 1,
	        theme: getCurrentTheme()
	    }));

	    chatInput.value = '';
	    charCounter.style.display = 'none';
	    chatInput.focus();
	    stopTypingSignal();
	}
	
    function sendReadEvent() {
        if (!stompClient || !stompClient.connected) return;
        stompClient.send('/app/chat/read', {}, JSON.stringify({
            roomIdx: CHAT_ROOM_IDX,
            userIdx: CHAT_MY_IDX,
            msgType: 4
        }));
    }
    function sendTypingSignal(typing) {
        if (!stompClient || !stompClient.connected) return;
        stompClient.send('/app/chat/typing', {}, JSON.stringify({
            roomIdx: CHAT_ROOM_IDX,
            userIdx: CHAT_MY_IDX,
            nickname: CHAT_MY_NAME,
            typing: typing
        }));
    }
    function stopTypingSignal() {
        if (isTyping) { isTyping = false; sendTypingSignal(false); }
        clearTimeout(typingTimer);
    }
    function showTyping(name, typing) {
        if (!typingIndicator || !typingLabel) return;
        typingIndicator.style.display = typing ? 'flex' : 'none';
        typingLabel.textContent = typing ? name + ' 님이 입력 중...' : '';
        if (typing) scrollToBottom();
    }
    function clearUnreadBadges() {
        const badge = document.getElementById('badge-' + CHAT_ROOM_IDX);
        if (badge) badge.remove();
        fetch(CHAT_CTX + '/admin/chat/read/' + CHAT_ROOM_IDX, {
            method: 'POST',
            credentials: 'same-origin'
        }).catch(function() {});
        updateStudioUnreadBadge();
    }
    const avatarClasses = ['jy','hn','mn','hs','op','cs'];
    const avatarMap     = {};
    let   avatarIdx     = 0;
	
    if (typeof CHAT_MEMBER_ORDER !== 'undefined') {
        CHAT_MEMBER_ORDER.forEach(function(uid) {
            if (Number(uid) !== CHAT_MY_IDX) {
                avatarMap[Number(uid)] = avatarClasses[avatarIdx++ % avatarClasses.length];
            }
        });
    }
    function getAvatarClass(userIdx) {
        if (userIdx === CHAT_MY_IDX) return 'me';
        if (!avatarMap[userIdx]) {
            avatarMap[userIdx] = avatarClasses[avatarIdx++ % avatarClasses.length];
        }
        return avatarMap[userIdx];
    }

    var themeNames = ['purple','blue','emerald','sunset','rose','slate'];

    function clearThemeClasses(el) {
        if (!el) return;
        themeNames.forEach(function(theme) {
            el.classList.remove('theme-' + theme);
            el.classList.remove('theme-recv-' + theme);
        });
    }

    function applyCurrentThemeToElement(el, prefix) {
        if (!el) return;
        clearThemeClasses(el);
        el.classList.add((prefix || 'theme-') + getCurrentTheme());
    }

    function normalizeExistingTheme() {
        var currentTheme = getCurrentTheme();

        document.querySelectorAll('.chat-msg-group .chat-avt[data-uid]').forEach(function(el) {
            avatarClasses.forEach(function(cls) { el.classList.remove(cls); });
            clearThemeClasses(el);
            el.classList.add('theme-recv-' + currentTheme);
        });

        document.querySelectorAll('.chat-msg-group .chat-bubble').forEach(function(el) {
            clearThemeClasses(el);
            el.classList.add('theme-' + currentTheme);
        });

        document.querySelectorAll('.chat-head-dm-avt, .chat-welcome-dm-avt').forEach(function(el) {
            clearThemeClasses(el);
            el.classList.add('theme-recv-' + currentTheme);
        });
    }
    function buildAvtHtml(photo, initial, cls) {
        if (photo) {
            return '<div class="chat-avt ' + cls + '"><img src="' + CHAT_CTX + '/uploads/profile/' + escHtml(photo) + '" style="width:100%;height:100%;object-fit:cover;border-radius:50%;" onerror="this.parentNode.textContent=\''+initial+'\'"></div>';
        }
        return '<div class="chat-avt ' + cls + '">' + initial + '</div>';
    }
    function appendMessage(msg) {
        const now     = new Date();
        const dateStr = toDateStr(now);
        const timeStr = toTimeStr(now);
        if (dateStr !== currentDateStr) {
            const div = document.createElement('div');
            div.className = 'chat-date-divider';
            div.innerHTML = '<span>' + dateStr + '</span>';
            chatArea.insertBefore(div, typingIndicator);
            currentDateStr = dateStr;
        }
        const isMe    = (Number(msg.userIdx) === Number(CHAT_MY_IDX));
        const name    = msg.nickname || (isMe ? CHAT_MY_NAME : '?');
        const initial = name.substring(0, 2);
        const photo   = msg.profilePhoto || null;
        var rawContent = String(msg.content || '');
        var safe;
        if (rawContent.indexOf('__IMG__') === 0) {
            var imgUrl = escHtml(rawContent.slice(7));
            safe = '<img src="' + imgUrl + '" style="max-width:220px;max-height:200px;border-radius:8px;cursor:pointer;display:block;" onclick="window.open(this.src)" onerror="this.style.display=\'none\'">';
        } else if (rawContent.indexOf('__FILE__') === 0) {
            var fileUrl  = escHtml(rawContent.slice(8));
            var fileName = fileUrl.split('/').pop().split('?')[0];
            try { fileName = decodeURIComponent(fileName); } catch(e) {}
            safe = '<a href="' + fileUrl + '" target="_blank" download="' + escHtml(fileName) + '" style="display:inline-flex;align-items:center;gap:8px;padding:10px 14px;background:rgba(255,255,255,0.18);border:1px solid rgba(255,255,255,0.25);border-radius:10px;color:inherit;text-decoration:none;font-size:13px;font-weight:600;max-width:220px;"><i class="ri-file-download-line" style="font-size:18px;flex-shrink:0;"></i><span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">' + escHtml(fileName) + '</span><i class="ri-download-2-line" style="font-size:14px;flex-shrink:0;opacity:0.7;"></i></a>';
        } else {
            safe = escHtml(rawContent).replace(/\n/g, '<br>');
        }
        const currentTheme = getCurrentTheme();
        const avatarCls = getAvatarClass(Number(msg.userIdx));
        const wrapper = document.createElement('div');
        wrapper.className = 'chat-msg-group' + (isMe ? ' mine' : '');
        if (isMe) {
            wrapper.innerHTML =
                '<div class="chat-msg-body">'
              +   '<div class="chat-msg-meta right">'
              +     '<span class="chat-msg-time">' + timeStr + '</span>'
              +     '<span class="chat-msg-name">' + escHtml(name) + '</span>'
              +   '</div>'
              +   '<div class="chat-bubble mine theme-' + currentTheme + '">' + safe + '</div>'
              + '</div>'
              + buildAvtHtml(photo, initial, 'me ' + avatarCls);
        } else {
            wrapper.innerHTML =
                buildAvtHtml(photo, initial, 'theme-recv-' + currentTheme)
              + '<div class="chat-msg-body">'
              +   '<div class="chat-msg-meta">'
              +     '<span class="chat-msg-name">' + escHtml(name) + '</span>'
              +     '<span class="chat-msg-time">' + timeStr + '</span>'
              +   '</div>'
              +   '<div class="chat-bubble theme-' + currentTheme + '">' + safe + '</div>'
              + '</div>';
        }
        chatArea.insertBefore(wrapper, typingIndicator);
        scrollToBottom();
        const preview = document.getElementById('preview-' + CHAT_ROOM_IDX);
        if (preview) {
            var previewContent = msg.content;
            if (String(previewContent || '').indexOf('__IMG__') === 0) previewContent = '사진';
            else if (String(previewContent || '').indexOf('__FILE__') === 0) previewContent = '파일';
            const t = (isMe ? '나: ' : name + ': ') + previewContent;
            preview.textContent = t.length > 20 ? t.substring(0, 20) + '…' : t;
        }
    }
    window.switchRoom = function (roomIdx, roomName, roomType) {
        if (roomIdx === CHAT_ROOM_IDX) return;
        var targetBadge = document.getElementById('badge-' + roomIdx);
        if (targetBadge) targetBadge.remove();
        isLeaving = true;
        stopTypingSignal();
        if (typingSubscription) typingSubscription.unsubscribe();
        const url = CHAT_CTX + '/admin/chat?roomIdx=' + roomIdx;
        if (stompClient && stompClient.connected) {
            stompClient.disconnect(function () { location.href = url; });
        } else {
            location.href = url;
        }
    };
    function startDM(targetUserIdx) {
        fetch(CHAT_CTX + '/admin/chat/dm', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
            body: 'targetUserIdx=' + targetUserIdx
        }).then(function (r) { return r.json(); })
          .then(function (d) {
            if (d.success) {
                closeDmModal();
                window.switchRoom(d.roomIdx, '', 'dm');
            }
        }).catch(function () {});
    }
    var selectedInviteIdxs = [];
    function openChannelModal() {
        selectedInviteIdxs = [];
        document.getElementById('addChannelOverlay').style.display = 'flex';
        document.getElementById('channelStep1').style.display = '';
        document.getElementById('channelStep2').style.display = 'none';
        document.getElementById('channelModalTitle').textContent = '채널 만들기';
        document.getElementById('channelStepIndicator').textContent = '1 / 2';
        document.getElementById('channelStepBack').style.display = 'none';
        document.querySelectorAll('.ch-member-pick-row').forEach(function(r) { r.classList.remove('selected'); });
        updateInviteCount();
        setTimeout(function () { document.getElementById('newChannelName').focus(); }, 50);
    }
    function closeChannelModal() {
        document.getElementById('addChannelOverlay').style.display = 'none';
        document.getElementById('newChannelName').value = '';
        document.getElementById('channelMemberSearch').value = '';
        selectedInviteIdxs = [];
        document.querySelectorAll('.ch-member-pick-row').forEach(function(r) { r.classList.remove('selected'); });
    }
    function goToStep2() {
        var name = document.getElementById('newChannelName').value.trim();
        if (!name) { document.getElementById('newChannelName').focus(); return; }
        document.getElementById('channelStep1').style.display = 'none';
        document.getElementById('channelStep2').style.display = '';
        document.getElementById('channelModalTitle').textContent = '# ' + name;
        document.getElementById('channelStepIndicator').textContent = '2 / 2';
        document.getElementById('channelStepBack').style.display = 'flex';
    }
    function updateInviteCount() {
        var el = document.getElementById('channelInviteCount');
        if (el) el.textContent = selectedInviteIdxs.length + '명 선택';
    }
    function createChannel() {
        var name = document.getElementById('newChannelName').value.trim();
        if (!name) return;
        fetch(CHAT_CTX + '/admin/chat/channel', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
            body: 'roomName=' + encodeURIComponent(name) + '&inviteIdxs=' + selectedInviteIdxs.join(',')
        }).then(function(r) { return r.json(); })
          .then(function(d) {
            if (d.success) {
                closeChannelModal();
                addChannelItemToSidebar(d.roomIdx, d.roomName);
                window.switchRoom(d.roomIdx, d.roomName, 'channel');
            }
        }).catch(function() {});
    }
    function addChannelItemToSidebar(roomIdx, roomName) {
        var list = document.getElementById('channelList');
        if (!list) return;
        var div = document.createElement('div');
        div.className = 'chat-room-item channel-item';
        div.dataset.roomidx  = roomIdx;
        div.dataset.roomname = roomName;
        div.dataset.type     = 'channel';
        div.innerHTML = '<span class="chat-room-hash"><i class="ri-hashtag"></i></span>'
            + '<span class="chat-room-name">' + roomName + '</span>';
        div.addEventListener('click', function() {
            window.switchRoom(Number(this.dataset.roomidx), this.dataset.roomname, 'channel');
        });
        var btn = document.createElement('button');
        btn.className = 'channel-manage-btn';
        btn.dataset.roomidx  = roomIdx;
        btn.dataset.roomname = roomName;
        btn.dataset.type     = 'channel';
        btn.dataset.muted    = '0';
        btn.title = '설정';
        btn.innerHTML = '<i class="ri-settings-3-line"></i>';
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            if (typeof openManageModal === 'function') {
                openManageModal(Number(this.dataset.roomidx), this.dataset.roomname, this.dataset.type || 'channel', this.dataset.muted);
            }
        });
        div.appendChild(btn);
        list.appendChild(div);
    }
    function openDmModal() {
        document.getElementById('newDmOverlay').style.display = 'flex';
    }
    function closeDmModal() {
        document.getElementById('newDmOverlay').style.display = 'none';
    }
    function toggleSection(bodyId, toggleBtn) {
        const body = document.getElementById(bodyId);
        const btn  = document.getElementById(toggleBtn);
        if (!body) return;
        const isOpen = body.style.display !== 'none';
        body.style.display = isOpen ? 'none' : '';
        if (btn) btn.classList.toggle('collapsed', isOpen);
    }
    document.getElementById('chatSend').addEventListener('click', sendMessage);
    chatInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
        }
    });
    chatInput.addEventListener('keyup', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            if (e.isComposing || e.keyCode === 229) return;
            sendMessage();
        }
    });
    chatInput.addEventListener('input', function () {
        const len = this.value.length;
        if (len > 0) {
            charCounter.style.display = 'inline';
            charCounter.textContent   = len + '/500';
            charCounter.className     = 'char-counter' + (len > 450 ? ' warn' : '');
        } else {
            charCounter.style.display = 'none';
        }
        if (!isTyping && this.value.trim()) {
            isTyping = true; sendTypingSignal(true);
        }
        clearTimeout(typingTimer);
        typingTimer = setTimeout(function () { isTyping = false; sendTypingSignal(false); }, 2000);
    });
    if (fileInput) {
        fileInput.addEventListener('change', function () {
            if (!this.files || !this.files[0]) return;
            pendingFile = this.files[0];
            filePreviewName.textContent = pendingFile.name;
            filePreviewBar.style.display = 'flex';
            if (attachMenu) attachMenu.style.display = 'none';
        });
    }
    if (imageInput) {
        imageInput.addEventListener('change', function () {
            if (!this.files || !this.files[0]) return;
            pendingFile = this.files[0];
            filePreviewName.textContent = pendingFile.name;
            filePreviewBar.style.display = 'flex';
            if (attachMenu) attachMenu.style.display = 'none';
        });
    }
    const filePreviewRemove = document.getElementById('filePreviewRemove');
    if (filePreviewRemove) filePreviewRemove.addEventListener('click', clearFilePreview);
    document.getElementById('emojiBtn').addEventListener('click', function (e) {
        e.stopPropagation();
        emojiPicker.style.display = (emojiPicker.style.display === 'none') ? 'flex' : 'none';
    });
    emojiPicker.querySelectorAll('span').forEach(function (span) {
        span.addEventListener('click', function () {
            chatInput.value += this.textContent;
            chatInput.focus();
            emojiPicker.style.display = 'none';
            chatInput.dispatchEvent(new Event('input'));
        });
    });
    document.addEventListener('click', function () { emojiPicker.style.display = 'none'; });
    document.getElementById('memberPanelToggle').addEventListener('click', function () {
        document.getElementById('memberPanel').classList.toggle('hidden');
        this.classList.toggle('active-head-btn');
    });
    document.getElementById('msgSearchBtn').addEventListener('click', function () {
        const bar = document.getElementById('msgSearchBar');
        bar.style.display = (bar.style.display === 'none') ? 'flex' : 'none';
        if (bar.style.display === 'flex') document.getElementById('msgSearchInput').focus();
    });
    document.getElementById('msgSearchClose').addEventListener('click', function () {
        document.getElementById('msgSearchBar').style.display = 'none';
        document.getElementById('msgSearchInput').value = '';
        document.querySelectorAll('.chat-bubble.highlight').forEach(function (el) { el.classList.remove('highlight'); });
    });
    document.getElementById('msgSearchInput').addEventListener('input', function () {
        const q = this.value.trim().toLowerCase();
        document.querySelectorAll('.chat-bubble').forEach(function (el) {
            el.classList.toggle('highlight', q.length > 0 && el.textContent.toLowerCase().includes(q));
        });
    });
    document.getElementById('roomSearch').addEventListener('input', function () {
        const q = this.value.trim().toLowerCase();
        document.querySelectorAll('.chat-room-item').forEach(function (el) {
            el.style.display = (!q || (el.dataset.roomname || '').toLowerCase().includes(q)) ? '' : 'none';
        });
    });
    const sidebarToggle = document.getElementById('chatSidebarToggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function () {
            const agencySidebar = document.querySelector('.agency-sidebar');
            if (agencySidebar) agencySidebar.classList.toggle('hidden');
            const panel = document.getElementById('chatRoomsPanel');
            if (panel) panel.classList.toggle('open');
        });
    }
    document.getElementById('channelToggle').addEventListener('click', function () { toggleSection('channelList', 'channelToggle'); });
    document.getElementById('dmToggle').addEventListener('click', function ()      { toggleSection('dmList', 'dmToggle'); });
    document.getElementById('addChannelBtn').addEventListener('click', openChannelModal);
    document.getElementById('addChannelClose').addEventListener('click', closeChannelModal);
    document.getElementById('addChannelCancel').addEventListener('click', closeChannelModal);
    document.getElementById('addChannelNext').addEventListener('click', goToStep2);
    document.getElementById('addChannelConfirm').addEventListener('click', createChannel);
    document.getElementById('addChannelSkip').addEventListener('click', createChannel);
    document.getElementById('channelStepBack').addEventListener('click', function() {
        document.getElementById('channelStep1').style.display = '';
        document.getElementById('channelStep2').style.display = 'none';
        document.getElementById('channelModalTitle').textContent = '채널 만들기';
        document.getElementById('channelStepIndicator').textContent = '1 / 2';
        this.style.display = 'none';
    });
    document.getElementById('newChannelName').addEventListener('keydown', function(e) {
        if (e.key === 'Enter') goToStep2();
    });
    document.getElementById('addChannelOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeChannelModal();
    });
    document.querySelectorAll('.ch-member-pick-row').forEach(function(row) {
        row.addEventListener('click', function() {
            var idx = Number(this.dataset.useridx);
            var pos = selectedInviteIdxs.indexOf(idx);
            if (pos === -1) {
                selectedInviteIdxs.push(idx);
                this.classList.add('selected');
            } else {
                selectedInviteIdxs.splice(pos, 1);
                this.classList.remove('selected');
            }
            updateInviteCount();
        });
    });
    document.getElementById('channelMemberSearch').addEventListener('input', function() {
        var q = this.value.trim().toLowerCase();
        document.querySelectorAll('.ch-member-pick-row').forEach(function(row) {
            row.style.display = (!q || row.dataset.nickname.toLowerCase().includes(q)) ? '' : 'none';
        });
    });
    var dmBtns = [document.getElementById('newDmBtn'), document.getElementById('newDmBtn2')];
    dmBtns.forEach(function (btn) { if (btn) btn.addEventListener('click', openDmModal); });
    document.getElementById('newDmClose').addEventListener('click', closeDmModal);
    document.getElementById('newDmOverlay').addEventListener('click', function (e) {
        if (e.target === this) closeDmModal();
    });
    document.querySelectorAll('.chat-dm-member-row').forEach(function (row) {
        row.addEventListener('click', function () {
            startDM(Number(this.dataset.useridx));
        });
    });
    document.querySelectorAll('.chat-dm-start-btn').forEach(function (btn) {
        btn.addEventListener('click', function (e) {
            e.stopPropagation();
            startDM(Number(this.dataset.useridx));
        });
    });
    document.querySelectorAll('.chat-room-item').forEach(function (item) {
        item.addEventListener('click', function () {
            window.switchRoom(Number(this.dataset.roomidx), this.dataset.roomname, this.dataset.type);
        });
    });
    if (attachToggleBtn && attachMenu) {
        attachToggleBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            attachMenu.style.display = attachMenu.style.display === 'none' || !attachMenu.style.display ? 'flex' : 'none';
        });
    }
    var attachImageBtn = document.getElementById('attachImageBtn');
    var attachFileBtn = document.getElementById('attachFileBtn');
    if (attachImageBtn && imageInput) attachImageBtn.addEventListener('click', function() { imageInput.click(); });
    if (attachFileBtn && fileInput) attachFileBtn.addEventListener('click', function() { fileInput.click(); });
    document.addEventListener('click', function(e) {
        if (!attachMenu) return;
        if (attachToggleBtn && attachToggleBtn.contains(e.target)) return;
        if (attachMenu.contains(e.target)) return;
        attachMenu.style.display = 'none';
    });

    window.addEventListener('beforeunload', function () {
        isLeaving = true; stopTypingSignal();
    });
    function uploadFile(file, callback) {
        const formData = new FormData();
        formData.append('file', file);
        formData.append('roomIdx', CHAT_ROOM_IDX);
        fetch(CHAT_CTX + '/chat/imageUpload', { method: 'POST', body: formData })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (!data || data.state !== 'true' || !data.saveFilename) { callback('(파일 업로드 실패)'); return; }
                var url = CHAT_CTX + '/uploads/chat/' + encodeURIComponent(data.saveFilename);
                var ext = data.saveFilename.split('.').pop().toLowerCase();
                var imgExts = ['jpg','jpeg','png','gif','webp','bmp','svg'];
                if (imgExts.indexOf(ext) !== -1) callback('__IMG__' + url);
                else callback('__FILE__' + url);
            })
            .catch(function () { callback('(파일 업로드 실패)'); });
    }
    function clearFilePreview() {
        pendingFile = null;
        if (filePreviewBar)  filePreviewBar.style.display = 'none';
        if (filePreviewName) filePreviewName.textContent  = '';
        if (fileInput)       fileInput.value = '';
        if (imageInput)      imageInput.value = '';
    }
    function setConnStatus(ok) {
        const dot   = document.getElementById('connDot');
        const label = document.getElementById('connLabel');
        if (dot)   dot.className     = 'conn-dot ' + (ok ? 'connected' : 'disconnected');
        if (label) label.textContent = ok ? '연결됨' : '재연결 중...';
    }
    function scrollToBottom() { chatArea.scrollTop = chatArea.scrollHeight; }
    function escHtml(str) { return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
    function toDateStr(d) { return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0'); }
    function toTimeStr(d) { return String(d.getHours()).padStart(2,'0') + ':' + String(d.getMinutes()).padStart(2,'0'); }
    window.addEventListener('load', function () {
        var dividers = document.querySelectorAll('.chat-date-divider span');
        if (dividers.length > 0) {
            currentDateStr = dividers[dividers.length - 1].textContent.trim();
        } else {
            currentDateStr = toDateStr(new Date());
        }
        connect();
        scrollToBottom();
        updateStudioUnreadBadge();
    });
})();
(function() {
    var manageRoomIdx    = null;
    var manageRoomName   = null;
    var manageCreatorIdx = null;
    function openManageModal(roomIdx, roomName, roomType, isMuted) {
        manageRoomIdx    = roomIdx;
        manageRoomName   = roomName;
        manageCreatorIdx = null;

        var isDm = (roomType === 'dm');

        /* ── 헤더 아이콘·제목 ── */
        var icon = document.getElementById('manageChannelIcon');
        if (icon) { icon.className = isDm ? 'ri-message-3-line' : 'ri-hashtag'; }
        document.getElementById('manageChannelName').textContent = (isDm ? '' : '# ') + roomName;

        /* ── 탭 행: DM이면 숨김 ── */
        var tabsRow = document.getElementById('manageTabsRow');
        if (tabsRow) tabsRow.style.display = isDm ? 'none' : '';

        /* ── 이름 변경 섹션: 기본 숨김, 방장 확인 후 표시 ── */
        var renameSection = document.getElementById('renameSection');
        if (renameSection) renameSection.style.display = 'none';
        if (!isDm && document.getElementById('renameChannelInput')) {
            document.getElementById('renameChannelInput').value = roomName;
        }

        /* ── 뮤트 버튼 초기 상태 ── */
        var muteBtn = document.getElementById('muteToggleBtn');
        if (muteBtn) {
            var muted = (isMuted === 1 || isMuted === '1' || isMuted === true);
            muteBtn.innerHTML = muted
                ? '<i class="ri-notification-off-line" style="font-size:16px;"></i> 알림 켜기'
                : '<i class="ri-notification-3-line" style="font-size:16px;"></i> 알림 끄기';
            muteBtn.style.color       = muted ? 'var(--color-orange)' : '';
            muteBtn.style.borderColor = muted ? 'var(--color-orange)' : '';
        }

        /* ── 탭 전환 ── */
        switchManageTab(isDm ? 'settings' : 'members');
        document.getElementById('channelManageOverlay').style.display = 'flex';
        if (!isDm) loadChannelMembers(roomIdx);
    }
    window.openManageModal = openManageModal;
    function closeManageModal() {
        document.getElementById('channelManageOverlay').style.display = 'none';
        manageRoomIdx = null;
    }
    function switchManageTab(tab) {
        document.querySelectorAll('.channel-manage-tab').forEach(function(btn) {
            var isActive = btn.dataset.tab === tab;
            btn.classList.toggle('active', isActive);
            btn.style.color       = isActive ? 'var(--color-purple)' : 'var(--text-sub)';
            btn.style.borderBottom = isActive ? '2px solid var(--color-purple)' : '2px solid transparent';
        });
        document.getElementById('manageTabMembers').style.display  = tab === 'members'  ? '' : 'none';
        document.getElementById('manageTabSettings').style.display = tab === 'settings' ? '' : 'none';
        if (tab === 'members' && manageRoomIdx) {
            loadChannelMembers(manageRoomIdx);
        }
    }
    function loadChannelMembers(roomIdx) {
        var url = CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/members';
        var currentEl = document.getElementById('currentMemberList');
        var nonEl     = document.getElementById('nonMemberList');
        var loadingHtml = '<p style="font-size:12px;color:var(--text-light);padding:8px 0;"><i class="ri-loader-4-line" style="display:inline-block;margin-right:4px;"></i>불러오는 중...</p>';
        if (currentEl) currentEl.innerHTML = loadingHtml;
        if (nonEl)     nonEl.innerHTML     = loadingHtml;
        fetch(url, { credentials: 'same-origin', headers: { 'Accept': 'application/json' } })
            .then(function(r) {
                if (!r.ok) throw new Error('HTTP ' + r.status);
                return r.json();
            })
            .then(function(d) {
                if (!d.success) {
                    if (currentEl) currentEl.innerHTML = '<p style="font-size:12px;color:var(--color-red);padding:8px 0;">멤버 목록을 불러오지 못했습니다.</p>';
                    if (nonEl)     nonEl.innerHTML     = '';
                    return;
                }
                manageCreatorIdx = d.creatorIdx != null ? Number(d.creatorIdx) : null;
                renderCurrentMembers(d.members, roomIdx);

                // 멤버 추가 섹션: 관리자(방장)만 표시
                var addLabelEls = document.querySelectorAll('#manageTabMembers p');
                var addLabel = addLabelEls.length > 1 ? addLabelEls[addLabelEls.length - 1] : null;
                var hasNonMembers = Array.isArray(d.nonMembers);
                if (addLabel) addLabel.style.display = hasNonMembers ? '' : 'none';
                if (nonEl)    nonEl.style.display    = hasNonMembers ? '' : 'none';
                if (hasNonMembers) renderNonMembers(d.nonMembers, roomIdx);

                /* 방장이면 채널 이름 변경 섹션 표시 */
                var amIOwner = (manageCreatorIdx !== null && Number(manageCreatorIdx) === Number(CHAT_MY_IDX));
                var renameSection = document.getElementById('renameSection');
                if (renameSection) renameSection.style.display = amIOwner ? '' : 'none';
            })
            .catch(function(err) {
                console.error('[채널멤버] 로드 실패:', err);
                if (currentEl) currentEl.innerHTML = '<p style="font-size:12px;color:var(--color-red);padding:8px 0;">멤버 목록을 불러오지 못했습니다.</p>';
                if (nonEl)     nonEl.innerHTML     = '';
            });
    }
    function avt(nickname) {
        return '<div class="manage-member-avt">' + (nickname || '?').substring(0, 2) + '</div>';
    }
    function renderCurrentMembers(members, roomIdx) {
        var el = document.getElementById('currentMemberList');
        if (!members || !members.length) {
            el.innerHTML = '<p style="font-size:12px;color:var(--text-light);padding:8px 0;">멤버가 없습니다</p>';
            return;
        }
        var amICreator = (manageCreatorIdx !== null && Number(manageCreatorIdx) === Number(CHAT_MY_IDX));
        el.innerHTML = members.map(function(m) {
            var isCreator = (manageCreatorIdx !== null && m.userIdx === manageCreatorIdx);
            var isMe      = (m.userIdx === CHAT_MY_IDX);
            var badge     = isCreator ? '<span class="manage-member-lv99">방장</span>' : (m.userLevel >= 99 ? '<span class="manage-member-lv99">ADMIN</span>' : '');
            var kickBtn   = (amICreator && !isCreator)
                ? '<button class="manage-member-action remove" onclick="removeMember(' + roomIdx + ',' + m.userIdx + ')" title="강퇴"><i class="ri-user-unfollow-line"></i></button>'
                : '';
            return '<div class="manage-member-row">'
                + avt(m.nickname)
                + '<span class="manage-member-name">' + esc(m.nickname) + (isMe ? ' <span style="font-size:10px;color:var(--text-light)">(나)</span>' : '') + '</span>'
                + badge
                + '<span class="manage-member-role">' + esc(m.authority || '') + '</span>'
                + kickBtn
                + '</div>';
        }).join('');
    }
    function renderNonMembers(nonMembers, roomIdx) {
        var el = document.getElementById('nonMemberList');
        if (!nonMembers || !nonMembers.length) {
            el.innerHTML = '<p style="font-size:12px;color:var(--text-light);padding:8px 0;">추가 가능한 멤버가 없습니다</p>';
            return;
        }
        el.innerHTML = nonMembers.map(function(m) {
            return '<div class="manage-member-row">'
                + avt(m.nickname)
                + '<span class="manage-member-name">' + esc(m.nickname) + '</span>'
                + '<span class="manage-member-role">' + esc(m.authority || '') + '</span>'
                + '<button class="manage-member-action add" onclick="addMember(' + roomIdx + ',' + m.userIdx + ')" title="추가"><i class="ri-add-line"></i></button>'
                + '</div>';
        }).join('');
    }
    function esc(s) { return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
    function customConfirm(opts, onOk) {
        var overlay = document.getElementById('customConfirmOverlay');
        var icon    = document.getElementById('confirmIcon');
        var title   = document.getElementById('confirmTitle');
        var desc    = document.getElementById('confirmDesc');
        var okBtn   = document.getElementById('confirmOkBtn');
        var cancel  = document.getElementById('confirmCancelBtn');
        if (!overlay) { if (onOk) onOk(); return; }
        icon.style.background  = opts.iconBg  || 'linear-gradient(135deg,#EF4444,#F97316)';
        icon.innerHTML         = opts.icon     || '<i class="ri-error-warning-fill" style="color:#fff;"></i>';
        title.textContent      = opts.title    || '확인';
        desc.textContent       = opts.desc     || '';
        okBtn.textContent      = opts.okLabel  || '확인';
        okBtn.style.background = opts.okBg     || '#EF4444';
        okBtn.style.color      = '#fff';
        overlay.style.display = 'flex';
        function close() { overlay.style.display = 'none'; }
        okBtn.onclick = function() { close(); if (onOk) onOk(); };
        cancel.onclick = close;
        overlay.onclick = function(e) { if (e.target === overlay) close(); };
    }
    window._batonConfirm = customConfirm; // leaveDM 전역 함수에서 사용
    window.addMember = function(roomIdx, userIdx) {
        fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/member/add', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
            body: 'userIdx=' + userIdx
        }).then(function(r) { return r.json(); }).then(function(d) {
            if (d.success) loadChannelMembers(roomIdx);
        });
    };
    window.removeMember = function(roomIdx, userIdx) {
        customConfirm({
            icon: '<i class="ri-user-unfollow-fill" style="color:#fff;"></i>',
            iconBg: 'linear-gradient(135deg,#F97316,#EF4444)',
            title: '멤버 강퇴',
            desc: '이 멤버를 채널에서 강퇴하시겠습니까?',
            okLabel: '강퇴',
            okBg: '#EF4444'
        }, function() {
            fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/member/remove', {
                method: 'POST', credentials: 'same-origin',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
                body: 'userIdx=' + userIdx
            }).then(function(r) { return r.json(); }).then(function(d) {
                if (d.success) {
                    loadChannelMembers(roomIdx);
                    if (typeof showToast === 'function') showToast('멤버를 강퇴했습니다.', 'success');
                } else {
                    if (typeof showToast === 'function') showToast(d.msg || '강퇴에 실패했습니다.', 'error');
                }
            });
        });
    };
    window.doLeaveChannel = function() {
        if (!manageRoomIdx) return;
        var roomIdx = manageRoomIdx;
        // 항상 서버에서 최신 방장 정보를 확인 (캐시 타이밍 문제 방지)
        fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/members', {
            credentials: 'same-origin', headers: { 'Accept': 'application/json' }
        }).then(function(r) { return r.json(); }).then(function(d) {
            if (!d.success) {
                if (typeof showToast === 'function') showToast('채널 정보를 불러오지 못했습니다.', 'error');
                return;
            }
            manageCreatorIdx = d.creatorIdx != null ? Number(d.creatorIdx) : null;
            if (d.members)    renderCurrentMembers(d.members, roomIdx);
            if (d.nonMembers) renderNonMembers(d.nonMembers, roomIdx);

            var isCreator = (manageCreatorIdx !== null && manageCreatorIdx === Number(CHAT_MY_IDX));
            if (isCreator) {
                openTransferModal(d.members || []);
                return;
            }
            customConfirm({
                icon: '<i class="ri-logout-box-r-line" style="color:#fff;"></i>',
                iconBg: 'linear-gradient(135deg,#64748B,#334155)',
                title: '채널 나가기',
                desc: '채널에서 나가면 다시 초대받아야 합니다.',
                okLabel: '나가기',
                okBg: '#475569'
            }, function() {
                fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/leave', {
                    method: 'POST', credentials: 'same-origin',
                    headers: { 'Accept': 'application/json' }
                }).then(function(r) { return r.json(); }).then(function(d) {
                    if (d.success) {
                        var item = document.querySelector('.channel-item[data-roomidx="' + roomIdx + '"]');
                        if (item) item.remove();
                        closeManageModal();
                        if (roomIdx === CHAT_ROOM_IDX) window.location.href = CHAT_CTX + '/admin/chat';
                    } else {
                        if (typeof showToast === 'function') showToast(d.msg || '나가기에 실패했습니다.', 'error');
                    }
                }).catch(function() {
                    if (typeof showToast === 'function') showToast('서버 오류가 발생했습니다.', 'error');
                });
            });
        }).catch(function() {
            if (typeof showToast === 'function') showToast('서버 오류가 발생했습니다.', 'error');
        });
    };
    // members 배열을 직접 받아서 DOM 파싱 의존 완전 제거
    function openTransferModal(members) {
        var overlay = document.getElementById('transferOwnerOverlay');
        var list    = document.getElementById('transferMemberList');
        if (!overlay || !list) return;
        var html = '';
        (members || []).forEach(function(m) {
            // 방장 본인, 현재 방장 제외
            if (m.userIdx === CHAT_MY_IDX) return;
            if (manageCreatorIdx !== null && m.userIdx === manageCreatorIdx) return;
            var name = m.nickname || '?';
            html += '<div class="transfer-member-row" onclick="selectTransferMember(' + m.userIdx + ', this)">'
                  + '<div class="manage-member-avt">' + name.substring(0,2) + '</div>'
                  + '<span style="font-size:13px;font-weight:600;color:var(--text-main);">' + esc(name) + '</span>'
                  + '<i class="ri-checkbox-blank-circle-line" style="margin-left:auto;font-size:18px;color:var(--text-light);"></i>'
                  + '</div>';
        });
        if (!html) {
            if (typeof showToast === 'function') showToast('위임할 다른 멤버가 없습니다. 채널을 삭제해 주세요.', 'error');
            return;
        }
        list.innerHTML = html;
        overlay.style.display = 'flex';
        window._selectedTransferUserIdx = null;
    }
    window.selectTransferMember = function(userIdx, rowEl) {
        document.querySelectorAll('.transfer-member-row').forEach(function(r) {
            r.classList.remove('selected');
            var ico = r.querySelector('i');
            if (ico) ico.className = 'ri-checkbox-blank-circle-line';
            ico.style.color = 'var(--text-light)';
        });
        rowEl.classList.add('selected');
        var ico = rowEl.querySelector('i');
        if (ico) { ico.className = 'ri-checkbox-circle-fill'; ico.style.color = 'var(--color-purple)'; }
        window._selectedTransferUserIdx = userIdx;
    };
    window.doTransferAndLeave = function() {
        var newOwner = window._selectedTransferUserIdx;
        if (!newOwner) {
            if (typeof showToast === 'function') showToast('위임할 멤버를 선택해 주세요.', 'error');
            return;
        }
        var roomIdx = manageRoomIdx;
        // transfer + leave를 서버에서 하나의 트랜잭션으로 처리
        fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/transfer-and-leave', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
            body: 'newOwnerIdx=' + newOwner
        })
        .then(function(r) { return r.json(); })
        .then(function(d) {
            if (d.success) {
                document.getElementById('transferOwnerOverlay').style.display = 'none';
                var item = document.querySelector('.channel-item[data-roomidx="' + roomIdx + '"]');
                if (item) item.remove();
                closeManageModal();
                if (roomIdx === CHAT_ROOM_IDX) {
                    window.location.href = CHAT_CTX + '/admin/chat';
                } else {
                    if (typeof showToast === 'function') showToast('방장을 위임하고 채널을 나갔습니다.', 'success');
                }
            } else {
                if (typeof showToast === 'function') showToast(d.msg || '위임에 실패했습니다.', 'error');
            }
        })
        .catch(function() {
            if (typeof showToast === 'function') showToast('서버 오류가 발생했습니다.', 'error');
        });
    };
    // ── 누락된 함수: 브라우저 팝업 알림 권한 요청 ──────────────────
    window.requestNotifPermission = function() {
        if (!('Notification' in window)) {
            if (typeof showToast === 'function') showToast('이 브라우저는 알림을 지원하지 않습니다.', 'error');
            return;
        }
        if (Notification.permission === 'granted') {
            if (typeof showToast === 'function') showToast('이미 팝업 알림이 허용되어 있습니다.', 'info');
            var btn = document.getElementById('notifPermBtn');
            if (btn) btn.innerHTML = '<i class="ri-notification-badge-line" style="font-size:16px;"></i> 팝업 알림 켜짐 ✓';
            return;
        }
        Notification.requestPermission().then(function(permission) {
            var btn = document.getElementById('notifPermBtn');
            if (permission === 'granted') {
                if (typeof showToast === 'function') showToast('팝업 알림이 허용되었습니다.', 'success');
                if (btn) btn.innerHTML = '<i class="ri-notification-badge-line" style="font-size:16px;"></i> 팝업 알림 켜짐 ✓';
                // 테스트 알림
                new Notification('BATON Studio', { body: '알림이 활성화되었습니다! 🎉', icon: '/favicon.ico' });
            } else {
                if (typeof showToast === 'function') showToast('알림 권한이 거부되었습니다. 브라우저 설정에서 허용해 주세요.', 'error');
            }
        });
    };
    // ── 누락된 함수: 내 화면 채팅 지우기 ──────────────────────────
    window.doClearMyMessages = function() {
        if (typeof window._batonConfirm === 'function') {
            window._batonConfirm({
                icon: '<i class="ri-eraser-fill" style="color:#fff;"></i>',
                iconBg: 'linear-gradient(135deg,#F97316,#FB923C)',
                title: '내 화면 채팅 지우기',
                desc: '채팅 내용을 내 화면에서만 지웁니다. 새로고침하면 다시 보입니다.',
                okLabel: '지우기',
                okBg: '#F97316'
            }, function() {
                var chatArea = document.getElementById('chatArea');
                if (!chatArea) return;
                var msgs = chatArea.querySelectorAll('.chat-msg-group, .chat-date-divider');
                msgs.forEach(function(el) { el.remove(); });
                if (typeof showToast === 'function') showToast('내 화면의 채팅을 지웠습니다.', 'success');
            });
        } else {
            if (confirm('채팅 내용을 내 화면에서만 지우시겠습니까?')) {
                var chatArea = document.getElementById('chatArea');
                if (chatArea) chatArea.querySelectorAll('.chat-msg-group, .chat-date-divider').forEach(function(el){ el.remove(); });
            }
        }
    };
    // ── 뮤트 초기 상태 로드 ───────────────────────────────────────
    if (typeof CHAT_ROOM_MUTED !== 'undefined') {
        _isMutedForNotif = CHAT_ROOM_MUTED === 1;
        /* 다른 페이지 팝업과 localStorage 동기화 */
        if (window.batonChatMuteStatus) {
            window.batonChatMuteStatus.setMuted(_isMutedForNotif);
        } else {
            try { localStorage.setItem('batonAdminChatMuted', _isMutedForNotif ? '1' : '0'); } catch(e) {}
        }
    }
    // ── 페이지 로드 시 뮤트된 채널 사이드바 시각화 ────────────────
    (function initMutedChannelIcons() {
        document.querySelectorAll('.channel-item[data-muted="1"]').forEach(function(roomItem) {
            roomItem.classList.add('muted');
            var nameEl = roomItem.querySelector('.chat-room-name');
            if (nameEl && !nameEl.querySelector('.mute-icon')) {
                var muteIcon = document.createElement('i');
                muteIcon.className = 'ri-notification-off-line mute-icon';
                muteIcon.title = '알림 꺼짐';
                nameEl.appendChild(muteIcon);
            }
        });
    })();
    // ─────────────────────────────────────────────────────────────
    window.doToggleMute = function() {
        if (!manageRoomIdx) return;
        fetch(CHAT_CTX + '/admin/chat/channel/' + manageRoomIdx + '/mute', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Accept': 'application/json' }
        }).then(function(r) { return r.json(); }).then(function(d) {
            if (d.success) {
                var isMuted = d.isMuted === 1;
                _isMutedForNotif = isMuted; // 알림 팝업 연동
                /* 다른 페이지 팝업 알림도 동기화 */
                if (window.batonChatMuteStatus) window.batonChatMuteStatus.setMuted(isMuted);
                var btn = document.getElementById('muteToggleBtn');
                if (btn) {
                    btn.innerHTML = (isMuted ? '<i class="ri-notification-off-line" style="font-size:16px;"></i> 알림 켜기' : '<i class="ri-notification-3-line" style="font-size:16px;"></i> 알림 끄기');
                    btn.style.color      = isMuted ? 'var(--color-orange)' : 'var(--text-sub)';
                    btn.style.borderColor = isMuted ? 'var(--color-orange)' : 'var(--border-color)';
                }
                /* 사이드바 설정 버튼 data-muted 갱신 + 채널 항목 시각적 표시 */
                var manageBtn = document.querySelector('.channel-manage-btn[data-roomidx="' + manageRoomIdx + '"]');
                if (manageBtn) manageBtn.dataset.muted = isMuted ? '1' : '0';
                var roomItem = document.querySelector('.channel-item[data-roomidx="' + manageRoomIdx + '"]');
                if (roomItem) {
                    roomItem.classList.toggle('muted', isMuted);
                    var existingIcon = roomItem.querySelector('.mute-icon');
                    if (isMuted && !existingIcon) {
                        var muteIcon = document.createElement('i');
                        muteIcon.className = 'ri-notification-off-line mute-icon';
                        muteIcon.title = '알림 꺼짐';
                        var nameEl = roomItem.querySelector('.chat-room-name');
                        if (nameEl) nameEl.appendChild(muteIcon);
                    } else if (!isMuted && existingIcon) {
                        existingIcon.remove();
                    }
                }
                if (typeof showToast === 'function') showToast(isMuted ? '알림이 꺼졌습니다.' : '알림이 켜졌습니다.', 'info');
            }
        });
    };
    window.toggleMuteInline = function(roomIdx, btnEl) {
        fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/mute', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Accept': 'application/json' }
        }).then(function(r) { return r.json(); }).then(function(d) {
            if (d.success) {
                var isMuted = d.isMuted === 1;
                btnEl.innerHTML = isMuted ? '<i class="ri-notification-off-line"></i>' : '<i class="ri-notification-3-line"></i>';
                btnEl.classList.toggle('muted', isMuted);
                // 현재 방이면 인앱 알림 상태도 동기화
                if (Number(roomIdx) === Number(CHAT_ROOM_IDX)) {
                    _isMutedForNotif = isMuted;
                    if (window.batonChatMuteStatus) window.batonChatMuteStatus.setMuted(isMuted);
                }
                showToast(isMuted ? '알림이 꺼졌습니다.' : '알림이 켜졌습니다.', 'info');
            }
        });
    };
    window.doRenameChannel = function() {
        if (!manageRoomIdx) return;
        var newName = document.getElementById('renameChannelInput').value.trim();
        if (!newName) return;
        fetch(CHAT_CTX + '/admin/chat/channel/' + manageRoomIdx + '/rename', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
            body: 'roomName=' + encodeURIComponent(newName)
        }).then(function(r) { return r.json(); }).then(function(d) {
            if (d.success) {
                var item = document.querySelector('.channel-item[data-roomidx="' + manageRoomIdx + '"]');
                if (item) {
                    item.dataset.roomname = newName;
                    var nameEl = item.querySelector('.chat-room-name');
                    if (nameEl) nameEl.textContent = newName;
                }
                document.getElementById('manageChannelName').textContent = '# ' + newName;
                manageRoomName = newName;
                if (typeof showToast === 'function') showToast('채널 이름이 변경되었습니다.', 'success');
            }
        });
    };
    window.doDeleteChannel = function() {
        if (!manageRoomIdx) return;
        customConfirm({
            icon: '<i class="ri-delete-bin-fill" style="color:#fff;"></i>',
            iconBg: 'linear-gradient(135deg,#EF4444,#DC2626)',
            title: '채널 삭제',
            desc: '"' + manageRoomName + '" 채널을 삭제하면 모든 메시지가 영구 삭제됩니다.',
            okLabel: '삭제',
            okBg: '#EF4444'
        }, function() {
            fetch(CHAT_CTX + '/admin/chat/channel/' + manageRoomIdx + '/delete', {
                method: 'POST', credentials: 'same-origin'
            }).then(function(r) { return r.json(); }).then(function(d) {
                if (d.success) {
                    var item = document.querySelector('.channel-item[data-roomidx="' + manageRoomIdx + '"]');
                    if (item) item.remove();
                    closeManageModal();
                    if (manageRoomIdx === CHAT_ROOM_IDX) {
                        window.location.href = CHAT_CTX + '/admin/chat';
                    }
                }
            });
        });
    };
    document.querySelectorAll('.channel-manage-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            openManageModal(
                Number(this.dataset.roomidx),
                this.dataset.roomname,
                this.dataset.type || 'channel',
                this.dataset.muted
            );
        });
    });
    document.querySelectorAll('.channel-manage-tab').forEach(function(btn) {
        btn.addEventListener('click', function() { switchManageTab(this.dataset.tab); });
    });
    document.getElementById('channelManageClose').addEventListener('click', closeManageModal);
    document.getElementById('channelManageOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeManageModal();
    });
	
    normalizeExistingTheme();

    var rootObserver = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'attributes' && mutation.attributeName === 'data-theme') {
                normalizeExistingTheme();
            }
        });
    });
    rootObserver.observe(document.documentElement, { attributes: true });

    window.addEventListener('load', normalizeExistingTheme);
})();

function leaveDM(roomIdx) {
    function doLeave() {
        fetch((window.CHAT_CTX || window.CTX || '') + '/admin/chat/dm/' + roomIdx + '/leave', {
            method: 'POST',
            credentials: 'same-origin',
            headers: { 'Content-Type': 'application/json' }
        })
        .then(function(r) { return r.json(); })
        .then(function(d) {
            if (d.success) {
                var item = document.querySelector('.chat-room-item[data-roomidx="' + roomIdx + '"]');
                if (item) item.remove();
                if (typeof CHAT_ROOM_IDX !== 'undefined' && Number(CHAT_ROOM_IDX) === Number(roomIdx)) {
                    window.location.href = (window.CHAT_CTX || window.CTX || '') + '/admin/chat';
                }
            } else {
                if (typeof showToast === 'function') showToast(d.msg || 'DM 나가기에 실패했습니다.', 'error');
            }
        })
        .catch(function() {
            if (typeof showToast === 'function') showToast('오류가 발생했습니다.', 'error');
        });
    }

    var overlay = document.getElementById('customConfirmOverlay');
    if (overlay) {
        document.getElementById('confirmIcon').style.background  = 'var(--grad-primary)';
        document.getElementById('confirmIcon').innerHTML         = '<i class="ri-logout-box-r-line" style="color:#fff;"></i>';
        document.getElementById('confirmTitle').textContent      = '대화방 나가기';
        document.getElementById('confirmDesc').textContent       = '이 대화를 나가시겠어요? 대화 내용은 삭제되지 않습니다.';
        document.getElementById('confirmOkBtn').textContent      = '나가기';
        document.getElementById('confirmOkBtn').style.background = 'var(--grad-primary)';
        document.getElementById('confirmOkBtn').style.color      = '#fff';
        overlay.style.display = 'flex';
        function closeOverlay() { overlay.style.display = 'none'; }
        document.getElementById('confirmOkBtn').onclick     = function() { closeOverlay(); doLeave(); };
        document.getElementById('confirmCancelBtn').onclick = closeOverlay;
        overlay.onclick = function(e) { if (e.target === overlay) closeOverlay(); };
    } else {
        if (confirm('이 대화를 나가시겠어요?')) doLeave();
    }
}