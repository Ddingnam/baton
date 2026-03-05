let stompClient = null;
let currentRoomIdx = 123;

function connect() {
    let socket = new SockJS('/ws/chat');
    stompClient = Stomp.over(socket);
    
    stompClient.connect({}, function (frame) {
        stompClient.subscribe('/topic/room/' + currentRoomIdx, function (chat) {
            let message = JSON.parse(chat.body);
            
            if(message.msgType === 4) {
                updateUnreadCounts();
            } else {
                appendMessage(message);
                sendReadEvent(); 
            }
        });
        
        sendReadEvent();
    });
}

function sendMessage() {
    let content = document.getElementById("chatInput").value;
    let messageModel = {
        roomIdx: currentRoomIdx,
        userIdx: myUserIdx,      
        content: content,
        msgType: 1
    };
    
    stompClient.send("/app/chat/send", {}, JSON.stringify(messageModel));
}

function sendReadEvent() {
    let readEvent = {
        roomIdx: currentRoomIdx,
        userIdx: myUserIdx,     
        msgType: 4
    };
    
    stompClient.send("/app/chat/read", {}, JSON.stringify(readEvent));
}