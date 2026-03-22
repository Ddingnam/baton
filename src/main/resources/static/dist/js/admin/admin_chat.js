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
        clearUnreadBadges();
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
        clearUnreadBadges();
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
            content: content,
            msgType: 1
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
    }

    const avatarClasses = ['jy','hn','mn','hs','op','cs'];
    const avatarMap     = {};
    let   avatarIdx     = 0;

    function getAvatarClass(userIdx) {
        if (userIdx === CHAT_MY_IDX) return 'me';
        if (!avatarMap[userIdx]) {
            avatarMap[userIdx] = avatarClasses[avatarIdx++ % avatarClasses.length];
        }
        return avatarMap[userIdx];
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

        const isMe    = (Number(msg.userIdx) === CHAT_MY_IDX);
        const name    = isMe ? CHAT_MY_NAME : (msg.nickname || '?');
        const initial = name.substring(0, 2);
        const safe    = escHtml(String(msg.content)).replace(/\n/g, '<br>');
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
              +   '<div class="chat-bubble mine">' + safe + '</div>'
              + '</div>'
              + '<div class="chat-avt me ' + avatarCls + '">' + initial + '</div>';
        } else {
            wrapper.innerHTML =
                '<div class="chat-avt ' + avatarCls + '">' + initial + '</div>'
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
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
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
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
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
        if (CHAT_MY_LEVEL >= 99) {
            var btn = document.createElement('button');
            btn.className = 'channel-manage-btn';
            btn.dataset.roomidx  = roomIdx;
            btn.dataset.roomname = roomName;
            btn.title = '채널 관리';
            btn.innerHTML = '<i class="ri-settings-3-line"></i>';
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                if (typeof openManageModal === 'function') openManageModal(Number(this.dataset.roomidx), this.dataset.roomname);
            });
            div.appendChild(btn);
        }
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

    window.addEventListener('beforeunload', function () {
        isLeaving = true; stopTypingSignal();
    });

    
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
        }
        connect();
        scrollToBottom();
    });
})();

(function() {
    if (typeof CHAT_MY_LEVEL === 'undefined' || CHAT_MY_LEVEL < 99) return;

    var manageRoomIdx  = null;
    var manageRoomName = null;

    function openManageModal(roomIdx, roomName) {
        manageRoomIdx  = roomIdx;
        manageRoomName = roomName;
        document.getElementById('manageChannelName').textContent = '# ' + roomName;
        document.getElementById('renameChannelInput').value = roomName;
        switchManageTab('members');
        document.getElementById('channelManageOverlay').style.display = 'flex';
        loadChannelMembers(roomIdx);
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
    }

    function loadChannelMembers(roomIdx) {
        fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/members', { credentials: 'same-origin' })
            .then(function(r) { return r.json(); })
            .then(function(d) {
                if (!d.success) return;
                renderCurrentMembers(d.members, roomIdx);
                renderNonMembers(d.nonMembers, roomIdx);
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
        el.innerHTML = members.map(function(m) {
            var isSuper = m.userLevel >= 99;
            return '<div class="manage-member-row">'
                + avt(m.nickname)
                + '<span class="manage-member-name">' + esc(m.nickname) + '</span>'
                + (isSuper ? '<span class="manage-member-lv99">SUPER</span>' : '')
                + '<span class="manage-member-role">' + esc(m.authority || '') + '</span>'
                + (!isSuper
                    ? '<button class="manage-member-action remove" onclick="removeMember(' + roomIdx + ',' + m.userIdx + ')" title="제거"><i class="ri-close-line"></i></button>'
                    : '')
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

    window.addMember = function(roomIdx, userIdx) {
        fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/member/add', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'userIdx=' + userIdx
        }).then(function(r) { return r.json(); }).then(function(d) {
            if (d.success) loadChannelMembers(roomIdx);
        });
    };

    window.removeMember = function(roomIdx, userIdx) {
        if (!confirm('이 멤버를 채널에서 제거하시겠습니까?')) return;
        fetch(CHAT_CTX + '/admin/chat/channel/' + roomIdx + '/member/remove', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'userIdx=' + userIdx
        }).then(function(r) { return r.json(); }).then(function(d) {
            if (d.success) loadChannelMembers(roomIdx);
        });
    };

    window.doRenameChannel = function() {
        if (!manageRoomIdx) return;
        var newName = document.getElementById('renameChannelInput').value.trim();
        if (!newName) return;
        fetch(CHAT_CTX + '/admin/chat/channel/' + manageRoomIdx + '/rename', {
            method: 'POST', credentials: 'same-origin',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
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
        if (!confirm('채널 "' + manageRoomName + '"을 삭제하시겠습니까?\n모든 메시지가 영구 삭제됩니다.')) return;
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
    };

    
    document.querySelectorAll('.channel-manage-btn').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            openManageModal(Number(this.dataset.roomidx), this.dataset.roomname);
        });
    });

    
    document.querySelectorAll('.channel-manage-tab').forEach(function(btn) {
        btn.addEventListener('click', function() { switchManageTab(this.dataset.tab); });
    });

    
    document.getElementById('channelManageClose').addEventListener('click', closeManageModal);
    document.getElementById('channelManageOverlay').addEventListener('click', function(e) {
        if (e.target === this) closeManageModal();
    });
})();