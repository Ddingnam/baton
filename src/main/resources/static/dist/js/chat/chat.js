let stompClient = null;
let currentRoomIdx = 123;

function connect() {
    let socket = new SockJS(window.contextPath + '/ws/chat');
    stompClient = Stomp.over(socket);
    stompClient.debug = null; 
    
    stompClient.connect({}, function (frame) {
        stompClient.subscribe('/topic/room/' + currentRoomIdx, function (chat) {
            let message = JSON.parse(chat.body);
            if(message.msgType === 4) {
                if(message.userIdx !== myUserIdx) removeUnreadCounts();
            } else {
                appendMessage(message);
                sendReadEvent();
            }
        });
        sendReadEvent();
        scrollToBottom();
    });
}

function handleEnter(e) {
    if(e.keyCode === 13 && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
    }
}

function sendMessage() {
    let input = document.getElementById("chatInput");
    let content = input.value.trim();
    if(!content) return;

    const urlParams = new URLSearchParams(window.location.search);
    const tradeIdx = urlParams.get('tradeIdx');

    let messageModel = { 
        roomIdx: currentRoomIdx, 
        userIdx: myUserIdx, 
        content: content, 
        msgType: 1, 
        tradeIdx: tradeIdx
    };
    
    stompClient.send("/app/chat/send", {}, JSON.stringify(messageModel));
    input.value = '';
    input.focus();
}

function uploadChatImage() {
    let fileInput = document.getElementById("chatImageFile");
    if(fileInput.files.length === 0) return;
    
    let file = fileInput.files[0];
    let formData = new FormData();
    formData.append("file", file);
    
    const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
    let headers = {};
    if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;
    
    fetch(window.contextPath + '/chat/imageUpload', {
        method: 'POST',
        headers: headers,
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if(data.state === 'true') {
            sendImageMessage(data.saveFilename);
        } else {
            alert('이미지 업로드에 실패했습니다.');
        }
        fileInput.value = ''; 
    })
    .catch(err => {
        console.error(err);
        alert('업로드 중 오류가 발생했습니다.');
        fileInput.value = '';
    });
}

function sendImageMessage(filename) {
    const urlParams = new URLSearchParams(window.location.search);
    const tradeIdx = urlParams.get('tradeIdx');
    
    let messageModel = {
        roomIdx: currentRoomIdx,
        userIdx: myUserIdx,      
        content: filename,
        msgType: 5, 
        tradeIdx: tradeIdx
    };
    
    stompClient.send("/app/chat/send", {}, JSON.stringify(messageModel));
}

function sendReadEvent() {
    let readEvent = { roomIdx: currentRoomIdx, userIdx: myUserIdx, msgType: 4 };
    stompClient.send("/app/chat/read", {}, JSON.stringify(readEvent));
}

function appendMessage(message) {
    let chatArea = document.getElementById("chatArea");
    let isMe = (message.userIdx === myUserIdx);
    
    let now = new Date();
    let dateStr = now.getFullYear() + "-" + String(now.getMonth()+1).padStart(2,'0') + "-" + String(now.getDate()).padStart(2,'0');
    let timeStr = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0');
    
    if(currentDisplayDate !== dateStr) {
        let dateHtml = '<div class="date-divider"><span>' + dateStr + '</span></div>';
        chatArea.insertAdjacentHTML('beforeend', dateHtml);
        currentDisplayDate = dateStr;
    }

    let html = '<div class="msg-row ' + (isMe ? 'msg-me' : 'msg-other') + '">';
    if(!isMe) {
        let photoPath = message.profilePhoto ? 
            window.contextPath + '/uploads/profile/' + message.profilePhoto : window.contextPath + '/dist/images/person.png';
        html += '<img src="' + photoPath + '" class="profile-img" onerror="this.src=\'' + window.contextPath + '/dist/images/person.png\'">';
        html += '<div><div class="nickname">' + counterpartName + '</div>';
    } else {
        html += '<div>';
    }
    
    html += '<div style="display: flex; align-items: flex-end;">';
    if(isMe) html += '<div class="msg-info"><span class="unread-count">1</span><span class="msg-time">' + timeStr + '</span></div>';

    if(message.msgType === 5) {
        html += '<div class="msg-bubble" style="background:transparent; padding:0;">';
        html += '<img src="' + window.contextPath + '/uploads/chat/' + message.content + '" style="max-width: 200px; border-radius: 14px; border: 1px solid #eee;">';
        html += '</div>';
    } else {
        html += '<div class="msg-bubble">' + message.content.replace(/\n/g, '<br>') + '</div>';
    }
    
    if(!isMe) html += '<div class="msg-info"><span class="msg-time">' + timeStr + '</span></div>';
    html += '</div></div></div>';
    
    chatArea.insertAdjacentHTML('beforeend', html);
    scrollToBottom();
}

function removeUnreadCounts() {
    let unreadElements = document.querySelectorAll('.unread-count');
    unreadElements.forEach(el => el.innerText = '');
}

function scrollToBottom() {
    let chatArea = document.getElementById("chatArea");
    chatArea.scrollTop = chatArea.scrollHeight;
}