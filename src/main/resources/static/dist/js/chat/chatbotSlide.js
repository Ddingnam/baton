(function () {

    const panel = document.getElementById('chatbot-slide-panel');
    const overlay = document.getElementById('chatbot-overlay');
    const trigger = document.getElementById('baton-chatbot-trigger');
    const closeBtn = document.getElementById('csp-close-btn');
    const fullBtn = document.getElementById('csp-fullpage-btn');
    const messagesEl = document.getElementById('csp-messages');
    const inputEl = document.getElementById('csp-input');
    const sendBtn = document.getElementById('csp-send-btn');
    const chipsEl = document.getElementById('csp-chips');

    if (!panel) return;

    var chatHistory = [];
    var isLoading   = false;

    function openPanel() {
        panel.classList.add('open');
        overlay.classList.add('visible');
        document.body.style.overflow = 'hidden';
        if (inputEl) inputEl.focus();
    }

    function closePanel() {
        panel.classList.remove('open');
        overlay.classList.remove('visible');
        document.body.style.overflow = '';
    }

    window.openBatonChatbot  = openPanel;
    window.closeBatonChatbot = closePanel;

    if (trigger) trigger.addEventListener('click', openPanel);
    if (closeBtn) closeBtn.addEventListener('click', closePanel);
    if (overlay) overlay.addEventListener('click', closePanel);

    if (fullBtn) {
        fullBtn.addEventListener('click', function () {
            var ctx = (typeof ContextPath !== 'undefined') ? ContextPath : '';
            window.location.href = ctx + '/chatbot/room';
        });
    }

    if (inputEl) {
        inputEl.addEventListener('input', function () {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 120) + 'px';
            sendBtn.disabled = !this.value.trim();
        });

        inputEl.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                if (!sendBtn.disabled) sendMessage();
            }
        });
    }

    if (sendBtn) {
        sendBtn.addEventListener('click', sendMessage);
    }

    if (chipsEl) {
        chipsEl.addEventListener('click', function (e) {
            var chip = e.target.closest('.csp-chip');
            if (!chip) return;
            var text = chip.getAttribute('data-chip');
            if (!text) return;
            chipsEl.style.display = 'none';
            inputEl.value = text;
            sendMessage();
        });
    }

    function getTimeStr() {
        var now = new Date();
        return now.getHours() + ':' + String(now.getMinutes()).padStart(2, '0');
    }

    function appendMessage(role, text) {
        var row = document.createElement('div');
        row.className = 'csp-msg-row ' + (role === 'user' ? 'csp-msg-user' : 'csp-msg-bot');

        var safeText = text.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\n/g, '<br>');

        if (role === 'assistant') {
            row.innerHTML =
                '<div class="csp-bot-avatar"><i class="ri-robot-line"></i></div>' +
                '<div class="csp-msg-content">' +
                    '<div class="csp-bubble">' + safeText + '</div>' +
                    '<div class="csp-msg-time">' + getTimeStr() + '</div>' +
                '</div>';
        } else {
            row.innerHTML =
                '<div class="csp-msg-content">' +
                    '<div class="csp-bubble">' + safeText + '</div>' +
                    '<div class="csp-msg-time">' + getTimeStr() + '</div>' +
                '</div>';
        }

        messagesEl.appendChild(row);
        messagesEl.scrollTop = messagesEl.scrollHeight;
    }

    function showTyping() {
        var row = document.createElement('div');
        row.id = 'csp-typing-indicator';
        row.className = 'csp-msg-row csp-msg-bot csp-typing';
        row.innerHTML =
            '<div class="csp-bot-avatar"><i class="ri-robot-line"></i></div>' +
            '<div class="csp-msg-content">' +
                '<div class="csp-bubble">' +
                    '<div class="csp-typing-dot"></div>' +
                    '<div class="csp-typing-dot"></div>' +
                    '<div class="csp-typing-dot"></div>' +
                '</div>' +
            '</div>';
        messagesEl.appendChild(row);
        messagesEl.scrollTop = messagesEl.scrollHeight;
    }

    function hideTyping() {
        var el = document.getElementById('csp-typing-indicator');
        if (el) el.remove();
    }

	function sendMessage() {
	    var text = inputEl.value.trim();
	    if (!text || isLoading) return;

	    isLoading = true;
	    sendBtn.disabled = true;
	    inputEl.value = '';
	    inputEl.style.height = 'auto';

	    appendMessage('user', text);
	    showTyping();

	    var ctx = (typeof ContextPath !== 'undefined') ? ContextPath : '';

	    var aiRowId = 'csp-ai-' + Date.now();

	    fetch(ctx + '/chatbot/question?question=' + encodeURIComponent(text))
	    .then(function (response) {
	        var reader = response.body.getReader();
	        var decoder = new TextDecoder();
	        var fullText = '';

	        hideTyping();
	        createAiBubble(aiRowId); 

	        function read() {
	            return reader.read().then(function (result) {
	                if (result.done) {
	                    isLoading = false;
	                    sendBtn.disabled = false;
	                    if (inputEl) inputEl.focus();
	                    return;
	                }

	                var chunk = decoder.decode(result.value, { stream: true });
	                var lines = chunk.split('\n');

	                lines.forEach(function (line) {
	                    if (line.startsWith('data:')) {
	                        var content = line.replace(/^data:\s*/, '');
	                        if (content.startsWith('"') && content.endsWith('"')) {
	                            content = content.slice(1, -1);
	                        }
	                        fullText += content;
	                    } else if (line.trim() && !line.startsWith('event:') && !line.startsWith(':')) {
	                        fullText += line.trim();
	                    }
	                });

	                var bubble = document.getElementById(aiRowId);
	                if (bubble) {
	                    bubble.querySelector('.csp-bubble').innerHTML = fullText.replace(/\n/g, '<br>');
	                    messagesEl.scrollTop = messagesEl.scrollHeight;
	                }

	                return read();
	            });
	        }

	        return read();
	    })
	    .catch(function (err) {
	        hideTyping();
	        appendMessage('assistant', '⚠️ 상담원이 잠시 자리를 비웠습니다. 잠시 후 다시 시도해 주세요.');
	        isLoading = false;
	        sendBtn.disabled = false;
	        console.error('[chatbot-slide]', err);
	    });
	}

	function createAiBubble(id) {
	    var timeStr = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
	    var row = document.createElement('div');
	    row.id = id;
	    row.className = 'csp-msg-row csp-msg-bot';
	    row.innerHTML =
	        '<div class="csp-bot-avatar"><i class="ri-robot-line"></i></div>' +
	        '<div class="csp-msg-content">' +
	            '<div class="csp-bubble">...</div>' +
	            '<div class="csp-msg-time">' + timeStr + '</div>' +
	        '</div>';
	    messagesEl.appendChild(row);
	    messagesEl.scrollTop = messagesEl.scrollHeight;
	}
	
})();
