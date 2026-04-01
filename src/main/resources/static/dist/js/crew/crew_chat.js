const CrewChatComponent = {
    template: '#crew-chat-template',
    emits: ['close-chat'],
    
    props: {
        currentUserIdx: {
            type: Number,
            required: true 
        },
		isOpen: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    
    data() {
        return {
            currentView: 'list',
            selectedRoomId: null,
            currentRoomName: '',
            rooms: [],
            messages: [],
            chatInput: '',
            stompClient: null,
            currentSubscription: null,
			
			participants: [],
			showParticipants: false
        }
    },
	
	watch: {
        isOpen(newVal) {
            if (!newVal) {
                this.showParticipants = false;
                // this.goToList(); 
            }
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
        async fetchRooms() {
            try {
                const response = await fetch('/api/chat/rooms');
                if (response.ok) {
                    this.rooms = await response.json();
                }
            } catch (error) {
                console.error("방 목록을 불러오지 못했습니다.", error);
            }
        },
		
        connectWebSocket() {
            const socket = new SockJS('/ws/chat');
            this.stompClient = Stomp.over(socket);
            // this.stompClient.debug = null; 

            this.stompClient.connect({}, (frame) => {
                console.log('Connected: ' + frame);
            }, (error) => {
                console.error('STOMP error: ', error);
            });
        },

        disconnectWebSocket() {
            if (this.currentSubscription) {
                this.currentSubscription.unsubscribe();
            }
            if (this.stompClient !== null) {
                this.stompClient.disconnect();
            }
        },

        async goToRoom(roomId, roomName) {
            this.selectedRoomId = roomId;
            this.currentRoomName = roomName;
            this.currentView = 'room';
            this.messages = [];
            
            if (this.currentSubscription) {
                this.currentSubscription.unsubscribe();
            }

            try {
                const response = await fetch(`/api/chat/rooms/${roomId}/messages`);
                if (response.ok) {
                    this.messages = await response.json();
                    this.scrollToBottom();
                }
            } catch (error) {
                console.error("메시지 내역을 불러오지 못했습니다.", error);
            }

            if (this.stompClient && this.stompClient.connected) {
                this.currentSubscription = this.stompClient.subscribe(`/topic/chat/rooms/${roomId}`, (payload) => {
                    const receivedMsg = JSON.parse(payload.body);
                    this.messages.push(receivedMsg);
                    this.scrollToBottom();
                });
            }
        },
		
		async toggleParticipants() {
            this.showParticipants = !this.showParticipants;
            if (this.showParticipants && this.participants.length === 0) {
                await this.fetchParticipants();
            }
        },

        async fetchParticipants() {
            if (!this.selectedRoomId) return;
            try {
                const response = await fetch(`/api/chat/rooms/${this.selectedRoomId}/participants`);
                if (response.ok) {
                    this.participants = await response.json();
                }
            } catch (error) {
                console.error("참여자 목록을 불러오지 못했습니다.", error);
            }
        },

        async leaveRoom() {
            if (!confirm("정말 이 채팅방에서 나가시겠습니까?")) return;
            if (!this.selectedRoomId) return;

            try {
                const response = await fetch(`/api/chat/rooms/${this.selectedRoomId}/leave`, {
                    method: 'DELETE'
                });
                
                if (response.ok) {
                    alert("채팅방에서 나갔습니다.");
                    this.goToList();
                } else {
                    alert("방 나가기에 실패했습니다.");
                }
            } catch (error) {
                console.error("방 나가기 중 오류가 발생했습니다.", error);
            }
        },

        goToList() {
            this.selectedRoomId = null;
            this.currentRoomName = '';
            this.currentView = 'list';
            if (this.currentSubscription) {
                this.currentSubscription.unsubscribe();
                this.currentSubscription = null;
            }
			this.showParticipants = false;
			this.participants = [];
            this.fetchRooms();
        },

        sendMessage() {
            const content = this.chatInput.trim();
            if (!content || !this.stompClient || !this.selectedRoomId) return;

            const chatMessage = {
                content: content,
                msgType: 1
            };

            this.stompClient.send(`/app/chat/rooms/${this.selectedRoomId}/send`, {}, JSON.stringify(chatMessage));
            
            this.chatInput = '';
        },

        scrollToBottom() {
            this.$nextTick(() => {
                const container = this.$refs.messageArea;
                if (container) {
                    container.scrollTop = container.scrollHeight;
                }
            });
        },

        formatTime(dateString) {
            if (!dateString) return '';
            const date = new Date(dateString);
            return date.toLocaleTimeString('ko-KR', { hour: 'numeric', minute: '2-digit' });
        }
    }
};