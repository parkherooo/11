<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FitTime 챗봇</title>
    <link rel="stylesheet" type="text/css" href="../css/chatbot.css">
    <script src="../chatbot/chatbot.js"></script>
</head>
<body class="chatbot-body">
    <div class="circle-button" onclick="toggleChatbot()">FitBot</div>
    <div class="chat-container" id="chatContainer">

        <img alt="로고" src="../img/fittime.png" style="display: block; margin-left: 10px; width: 200px; height: auto;">

        <div class="messages" id="chatWindow"></div>
        <div class="input-container">
            <input type="text" id="userInput" placeholder="메시지를 입력하세요..." onkeydown="handleKeyPress(event)" />
            <button class="" onclick="sendMessage()">전송</button>
        </div>
    </div>    
</body>
</html>