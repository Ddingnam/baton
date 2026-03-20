const chatArea = document.getElementById("chatArea");
const typingArea = document.getElementById("typingArea");
const chatInput = document.getElementById("chatInput");

function handleEnter(e) {
	if(e.keyCode === 13 && !e.shiftKey) {
		e.preventDefault();
		sendMessage();
	}
}

async function sendMessage() {
	const question = chatInput.value.trim();
	if(!question) return;

	appendUserMessage(question);
	chatInput.value = '';

	typingArea.style.display = 'block';
	scrollToBottom();

	const aiMsgId = 'ai-' + Date.now();
	createAiBubble(aiMsgId);

	try {
		const response = await fetch(`${ContextPath}/chatbot/question?question=` + encodeURIComponent(question));
		const reader = response.body.getReader();
		const decoder = new TextDecoder();
            
		let fullText = "";
		typingArea.style.display = 'none';

		while (true) {
			const { done, value } = await reader.read();
			if (done) break;

			const chunk = decoder.decode(value, { stream: true });
                
			const lines = chunk.split('\n');
			for(let line of lines) {
			    if (line.startsWith('data:')) {
			        let content = line.replace(/^data:\s*/, '');
			        if(content.startsWith('"') && content.endsWith('"')) {
			            content = content.slice(1, -1);
			        }
			        fullText += content;
			    } 
			    else if (line.trim() && !line.startsWith('event:') && !line.startsWith(':')) {
			        fullText += line.trim();
			    }
			}

			const bubble = document.getElementById(aiMsgId).querySelector('.msg-bubble');
			bubble.innerHTML = fullText.replace(/\n/g, '<br>');
			scrollToBottom();
		}
	} catch (error) {
		console.error("AI Error:", error);
		typingArea.style.display = 'none';
		document.getElementById(aiMsgId).querySelector('.msg-bubble').innerText = "상담원이 잠시 자리를 비웠습니다. 잠시 후 다시 시도해 주세요.";
	}
}

function appendUserMessage(text) {
        const timeStr = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
        const html = `
            <div class="msg-row msg-me">
                <span class="msg-time">${timeStr}</span>
                <div class="msg-bubble">${text.replace(/\n/g, '<br>')}</div>
            </div>`;
        chatArea.insertAdjacentHTML('beforeend', html);
        scrollToBottom();
}

function createAiBubble(id) {
	const timeStr = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
	const html = `
		<div class="msg-row msg-other" id="${id}">
			<div class="ai-profile-circle"><i class="ri-robot-line"></i></div>
			<div>
				<div class="nickname">바톤 가이드</div>
				<div style="display: flex; align-items: flex-end;">
					<div class="msg-bubble">...</div>
					<span class="msg-time">${timeStr}</span>
				</div>
			</div>
		</div>`;
	chatArea.insertAdjacentHTML('beforeend', html);
}

function scrollToBottom() {
	chatArea.scrollTop = chatArea.scrollHeight;
}