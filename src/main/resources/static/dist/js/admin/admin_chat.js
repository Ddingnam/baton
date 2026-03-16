(function () {
    'use strict';

    let stompClient       = null;
    let typingSubscription = null;
    let currentDateStr    = '';
    let typingTimer       = null;
    let isTyping          = false;
    let pendingFile       = null;
    let reconnectCount    = 0;
    let isLeaving         = false;

    const chatArea        = document.getElementById('chatArea');
    const chatInput       = document.getElementById('chatInput');
    const charCounter     = document.getElementById('charCounter');
    const typingIndicator = document.getElementById('typingIndicator');
    const typingLabel     = document.getElementById('typingLabel');
    const fileInput       = document.getElementById('fileInput');
    const filePreviewBar  = document.getElementById('filePreviewBar');
    const filePreviewName = document.getElementById('filePreviewName');
    const emojiPicker     = document.getElementById('emojiPicker');

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

        sendReadEvent();
        scrollToBottom();
    }

    function onDisconnected() {
        if (isLeaving) return;
        setConnStatus(false);
        const delay = Math.min(3000 * Math.pow(1.5, reconnectCount++), 30000);
        setTimeout(connect, delay);
    }

    function handleIncoming(msg) {
        if (msg.msgType === 4) {
            if (Number(msg.userIdx) !== CHAT_MY_IDX) clearUnreadBadges();
            return;
        }
        appendMessage(msg);
        sendReadEvent();
    }

    function sendMessage() {
        const text = chatInput.value.trim();
        if ((!text && !pendingFile) || !stompClient || !stompClient.connected) return;

        if (pendingFile) {
            uploadFile(pendingFile, function (url) {
                doSend('[파일] ' + pendingFile.name + ' | ' + url);
                clearFilePreview();
            });
            return;
        }
        doSend(text);
    }

    function doSend(content) {
        stompClient.send('/app/chat/send', {}, JSON.stringify({
            roomIdx: CHAT_ROOM_IDX,
            userIdx: CHAT_MY_IDX,
            nickname: CHAT_MY_NAME,
            content:  content,
            msgType:  1
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
            roomIdx:  CHAT_ROOM_IDX,
            userIdx:  CHAT_MY_IDX,
            nickname: CHAT_MY_NAME,
            typing:   typing
        }));
    }

    function stopTypingSignal() {
        if (isTyping) {
            isTyping = false;
            sendTypingSignal(false);
        }
        clearTimeout(typingTimer);
    }

    function showTyping(name, typing) {
        if (!typingIndicator || !typingLabel) return;
        typingIndicator.style.display = typing ? 'flex' : 'none';
        typingLabel.textContent = typing ? name + ' 님이 입력 중...' : '';
        if (typing) scrollToBottom();
    }

    function updateMemberStatus(userIdx, online) {
        const avt = document.getElementById('avt-' + userIdx);
        if (avt) avt.className = 'chat-dm-avt ' + (online ? 'online' : 'away');
    }

    function clearUnreadBadges() {
        document.querySelectorAll('.unread-badge').forEach(function (el) {
            el.textContent = '';
        });
        const badge = document.getElementById('badge-' + CHAT_ROOM_IDX);
        if (badge) badge.remove();
    }

    function appendMessage(msg) {
        const empty = document.getElementById('emptyState');
        if (empty) empty.style.display = 'none';

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

        const isMe        = (Number(msg.userIdx) === CHAT_MY_IDX);
        const name        = isMe ? CHAT_MY_NAME : (msg.nickname || '?');
        const initial     = name.substring(0, 2).toUpperCase();
        const safe        = escHtml(String(msg.content)).replace(/\n/g, '<br>');
        const avatarClass = getAvatarClass(Number(msg.userIdx));

        const wrapper = document.createElement('div');
        wrapper.className = 'chat-msg-group' + (isMe ? ' mine' : '');
        wrapper.style.animation = 'msgPop 0.25s var(--spring) both';

        if (isMe) {
            wrapper.innerHTML =
                '<div class="chat-msg-body">'
              +   '<div class="chat-msg-meta right">'
              +     '<span class="chat-msg-time">' + timeStr + '</span>'
              +     '<span class="chat-msg-name">' + escHtml(name) + '</span>'
              +   '</div>'
              +   '<div class="chat-bubble mine">' + safe + '</div>'
              + '</div>'
              + '<div class="chat-avt me ' + avatarClass + '">' + initial + '</div>';
        } else {
            wrapper.innerHTML =
                '<div class="chat-avt ' + avatarClass + '">' + initial + '</div>'
              + '<div class="chat-msg-body">'
              +   '<div class="chat-msg-meta">'
              +     '<span class="chat-msg-name">' + escHtml(name) + '</span>'
              +     '<span class="chat-msg-time">' + timeStr + '</span>'
              +   '</div>'
              +   '<div class="chat-bubble">' + safe + '</div>'
              + '</div>';
        }

        chatArea.insertBefore(wrapper, typingIndicator);
        scrollToBottom();

        const preview = document.getElementById('preview-' + CHAT_ROOM_IDX);
        if (preview) {
            const t = (isMe ? '나: ' : name + ': ') + msg.content;
            preview.textContent = t.length > 24 ? t.substring(0, 24) + '…' : t;
        }
    }

    const avatarClasses = ['jy', 'hn', 'mn', 'hs', 'op', 'cs'];
    const avatarMap     = {};
    let   avatarIdx     = 0;
    function getAvatarClass(userIdx) {
        if (userIdx === CHAT_MY_IDX) return 'me';
        if (!avatarMap[userIdx]) {
            avatarMap[userIdx] = avatarClasses[avatarIdx++ % avatarClasses.length];
        }
        return avatarMap[userIdx];
    }

    function uploadFile(file, callback) {
        const formData = new FormData();
        formData.append('file', file);
        formData.append('roomIdx', CHAT_ROOM_IDX);
        fetch(CHAT_CTX + '/chat/upload', { method: 'POST', body: formData })
            .then(function (r) { return r.json(); })
            .then(function (data) { callback(data.url || '(파일 업로드 완료)'); })
            .catch(function () { callback('(파일 업로드 실패)'); });
    }

    function clearFilePreview() {
        pendingFile = null;
        if (filePreviewBar)  filePreviewBar.style.display = 'none';
        if (filePreviewName) filePreviewName.textContent  = '';
        if (fileInput)       fileInput.value = '';
    }

    document.getElementById('chatSend').addEventListener('click', sendMessage);

    chatInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); }
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
            isTyping = true;
            sendTypingSignal(true);
        }
        clearTimeout(typingTimer);
        typingTimer = setTimeout(function () {
            isTyping = false;
            sendTypingSignal(false);
        }, 2000);
    });

    if (fileInput) {
        fileInput.addEventListener('change', function () {
            if (!this.files || !this.files[0]) return;
            pendingFile = this.files[0];
            filePreviewName.textContent = pendingFile.name;
            filePreviewBar.style.display = 'flex';
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
        document.querySelectorAll('.chat-bubble.highlight').forEach(function (el) {
            el.classList.remove('highlight');
        });
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
            const sidebar = document.querySelector('.agency-sidebar');
            if (sidebar) sidebar.classList.toggle('hidden');
        });
    }

    window.switchRoom = function (roomIdx, roomName) {
        if (roomIdx === CHAT_ROOM_IDX) return;
        isLeaving = true;
        stopTypingSignal();
        
        if (typingSubscription) typingSubscription.unsubscribe();

        const targetUrl = CHAT_CTX + '/admin/chat?roomIdx=' + roomIdx;

        if (stompClient && stompClient.connected) {
            stompClient.disconnect(function() {
                location.href = targetUrl;
            });
        } else {
            location.href = targetUrl;
        }
    };

    document.querySelectorAll('.chat-room-item').forEach(function(item) {
        item.addEventListener('click', function() {
            const roomIdx = Number(this.dataset.roomidx);
            const roomName = this.dataset.roomname;
            window.switchRoom(roomIdx, roomName);
        });
    });

    window.addEventListener('beforeunload', function () {
        isLeaving = true;
        stopTypingSignal();
    });

    function setConnStatus(ok) {
        const dot   = document.getElementById('connDot');
        const label = document.getElementById('connLabel');
        if (dot)   dot.className     = 'conn-dot ' + (ok ? 'connected' : 'disconnected');
        if (label) label.textContent = ok ? '연결됨' : '재연결 중...';
    }

    function scrollToBottom() { chatArea.scrollTop = chatArea.scrollHeight; }

    function escHtml(str) {
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    function toDateStr(d) {
        return d.getFullYear() + '-'
             + String(d.getMonth() + 1).padStart(2, '0') + '-'
             + String(d.getDate()).padStart(2, '0');
    }

    function toTimeStr(d) {
        return String(d.getHours()).padStart(2, '0') + ':'
             + String(d.getMinutes()).padStart(2, '0');
    }

    window.addEventListener('load', function () {
        connect();
        scrollToBottom();
    });

})();