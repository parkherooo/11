function toggleChatbot() {
    const chatContainer = document.getElementById('chatContainer');
    if (chatContainer.style.display === 'none' || chatContainer.style.display === '') {
        chatContainer.style.display = 'block';
    } else {
        chatContainer.style.display = 'none';
    }
}

function addMessageToChat(content, sender) {
    const chatWindow = document.getElementById('chatWindow');
    const message = document.createElement('div');
    message.classList.add('message', sender);
    message.textContent = content;
    chatWindow.appendChild(message);
    chatWindow.scrollTop = chatWindow.scrollHeight;
}

function handleKeyPress(event) {
    if (event.key === 'Enter') {
        sendMessage();
    }
}

function sendMessage() {
    const userInput = document.getElementById('userInput');
    const userMessage = userInput.value.trim();
    if (userMessage === '') return;

    addMessageToChat(userMessage, 'user');
    
    // 세션에 메시지 추가
    updateSessionStorage(userMessage, 'user');
    
    const loadingMessage = document.createElement('div');
    loadingMessage.classList.add('message', 'bot', 'loading-indicator');
    loadingMessage.textContent = 'GPT 응답 중...';
    document.getElementById('chatWindow').appendChild(loadingMessage);

    fetch('/JSP_project/ChatServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'question=' + encodeURIComponent(userMessage)
    })
    .then(response => response.text())
    .then(data => {
        loadingMessage.remove();
        addMessageToChat(data, 'bot');
        
        // 세션에 GPT 응답 추가
        updateSessionStorage(data, 'bot');
    })
    .catch(error => {
        loadingMessage.remove();
        addMessageToChat('오류가 발생했습니다. 다시 시도해 주세요.', 'bot');
    });

    userInput.value = '';
    userInput.focus();
}
function updateSessionStorage(message, sender) {
    let chatHistory = JSON.parse(sessionStorage.getItem('chatHistory')) || [];
    chatHistory.push({ message, sender });
    sessionStorage.setItem('chatHistory', JSON.stringify(chatHistory));
}

function loadChatHistory() {
    const chatHistory = JSON.parse(sessionStorage.getItem('chatHistory')) || [];
    chatHistory.forEach(entry => {
        addMessageToChat(entry.message, entry.sender);
    });
}
window.onload = function() {
	loadChatHistory(); // 세션에서 대화 내용 로드
    addMessageToChat('FitTime 챗봇입니다. 레시피, 식단, 운동루틴을 물어보세요!', 'bot');
};
