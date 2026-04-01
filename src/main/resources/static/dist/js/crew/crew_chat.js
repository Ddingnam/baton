const CrewChatComponent = {
    template: '#crew-chat-template',
    emits: ['close-chat'],
    
    // 컴포넌트가 마운트될 때 현재 로그인한 유저의 정보를 받아온다고 가정합니다.
    props: {
        currentUserIdx: {
            type: Number,
            required: true 
        }
    },
    
    data() {
        return {
            currentView: 'list',
            selectedRoomId: null,
            currentRoomName: '',
            rooms: [],        // 채팅방 목록
            messages: [],     // 현재 방의 메시지 목록
            chatInput: '',    // 입력 중인 메시지
            stompClient: null,
            currentSubscription: null
        }
    },
    
    mounted() {
        this.fetchRooms();
        this.connectWebSocket();
    },
    
    beforeUnmount() {
        this.disconnectWebSocket();
    },
    
    methods: {
        // 1. 방 목록 가져오기 (REST API)
        async fetchRooms() {
            try {
                // 백엔드의 getMyChatRooms API 호출
                const response = await fetch('/api/chat/rooms');
                if (response.ok) {
                    this.rooms = await response.json();
                }
            } catch (error) {
                console.error("방 목록을 불러오지 못했습니다.", error);
            }
        },

        // 2. WebSocket 연결
        connectWebSocket() {
            // SockJS와 StompJS 라이브러리가 HTML에 포함되어 있어야 합니다.
            const socket = new SockJS('/ws/chat');
            this.stompClient = Stomp.over(socket);
            
            // 디버그 로그 비활성화 (필요시 주석 처리)
            // this.stompClient.debug = null; 

            this.stompClient.connect({}, (frame) => {
                console.log('Connected: ' + frame);
            }, (error) => {
                console.error('STOMP error: ', error);
            });
        },

        // 3. WebSocket 연결 해제
        disconnectWebSocket() {
            if (this.currentSubscription) {
                this.currentSubscription.unsubscribe();
            }
            if (this.stompClient !== null) {
                this.stompClient.disconnect();
            }
        },

        // 4. 채팅방 입장
        async goToRoom(roomId, roomName) {
            this.selectedRoomId = roomId;
            this.currentRoomName = roomName;
            this.currentView = 'room';
            this.messages = []; // 초기화
            
            // 기존 구독이 있다면 해제
            if (this.currentSubscription) {
                this.currentSubscription.unsubscribe();
            }

            // 4-1. 과거 대화 내역 불러오기 (REST API)
            try {
                const response = await fetch(`/api/chat/rooms/${roomId}/messages`);
                if (response.ok) {
                    this.messages = await response.json();
                    this.scrollToBottom();
                }
            } catch (error) {
                console.error("메시지 내역을 불러오지 못했습니다.", error);
            }

            // 4-2. 해당 방 구독 (STOMP)
            if (this.stompClient && this.stompClient.connected) {
                this.currentSubscription = this.stompClient.subscribe(`/topic/chat/rooms/${roomId}`, (payload) => {
                    const receivedMsg = JSON.parse(payload.body);
                    this.messages.push(receivedMsg);
                    this.scrollToBottom();
                    
                    // TODO: 메시지를 받았으므로 읽음 처리 신호(read)를 보내는 로직 추가 가능
                });
            }
        },

        // 5. 목록으로 돌아가기
        goToList() {
            this.selectedRoomId = null;
            this.currentRoomName = '';
            this.currentView = 'list';
            if (this.currentSubscription) {
                this.currentSubscription.unsubscribe();
                this.currentSubscription = null;
            }
            this.fetchRooms(); // 방 목록(마지막 메시지 등) 갱신
        },

        // 6. 메시지 전송
        sendMessage() {
            const content = this.chatInput.trim();
            if (!content || !this.stompClient || !this.selectedRoomId) return;

            const chatMessage = {
                content: content,
                msgType: 1 // 1: 텍스트
            };

            // 백엔드의 @MessageMapping("/chat/rooms/{roomId}/send") 로 전송
            this.stompClient.send(`/app/chat/rooms/${this.selectedRoomId}/send`, {}, JSON.stringify(chatMessage));
            
            this.chatInput = ''; // 입력창 초기화
        },

        // 유틸리티: 스크롤 맨 아래로 이동
        scrollToBottom() {
            this.$nextTick(() => {
                const container = this.$refs.messageArea;
                if (container) {
                    container.scrollTop = container.scrollHeight;
                }
            });
        },

        // 유틸리티: 시간 포맷팅 (예: 오후 6:30)
        formatTime(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            return date.toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' });
        }
    }
};