<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTime 챗봇</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .chat-container {
            display: none; /* 기본적으로 숨김 */
            position: fixed;
            bottom: 80px;
            right: 20px;
            width: 380px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }
        .chat-container img{
        	margin: 10px;
			height: 30px;
			widows: auto;
        }
        
        .messages {
            height: 400px;
            overflow-y: scroll;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-bottom: 10px;
            background-color: #fafafa;
            display: flex;
            flex-direction: column;
        }
        .message {
            padding: 8px;
            margin-bottom: 10px;
            border-radius: 5px;
            width: fit-content;
            max-width: 70%;
        }
        .message.user {
            background-color: #dcf8c6;
            align-self: flex-end;
            text-align: right;
        }
        .message.bot {
            background-color: #e2e2e2;
            align-self: flex-start;
            text-align: left;
        }
        .input-container {
            display: flex;
            align-items: center;
        }
        .input-container input {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .input-container button {
       		width: 60px;
       		height: 35px;
            border-radius: 5px;
            border: none;
            background-color: black;
            color: white;
            cursor: pointer;
            margin-left: 10px;
        }
        .loading-indicator {
            color: #888;
            font-style: italic;
        }
        .circle-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: black;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            z-index: 1000;
        }
    </style>
</head>
<body>
    <div class="circle-button" onclick="toggleChatbot()">FitBot</div>
    <div class="chat-container" id="chatContainer">
        <img alt="로고" src="fittime.png">
        <div class="messages" id="chatWindow"></div>
        <div class="input-container">
            <input type="text" id="userInput" placeholder="메시지를 입력하세요..." onkeydown="handleKeyPress(event)" />
            <button onclick="sendMessage()">전송</button>
        </div>
    </div>

    <script>
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
            })
            .catch(error => {
                loadingMessage.remove();
                addMessageToChat('오류가 발생했습니다. 다시 시도해 주세요.', 'bot');
            });

            userInput.value = '';
            userInput.focus();
        }

        window.onload = function() {
            addMessageToChat('FitTime 챗봇입니다. 레시피, 식단, 운동루틴을 물어보세요!', 'bot');
        };
    </script>
</body>
</html>
