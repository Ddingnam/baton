const CrewChatComponent = {
    template: '#crew-chat-template',
	emits: ['close-chat'],
	
    data() {
        return {
            currentView: 'list',
            selectedRoomId: null
        }
    },
    methods: {
        goToRoom(roomId) {
            this.selectedRoomId = roomId;
            this.currentView = 'room';
        },
        goToList() {
            this.selectedRoomId = null;
            this.currentView = 'list';
        }
    }
};