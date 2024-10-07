<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>실시간 알림</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1 {
            color: #333;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        li {
            background-color: #f1f1f1;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <h1>알림 목록</h1>
    <ul id="notificationList"></ul>

    <script>
        // WebSocket 서버에 연결
        var socket = new WebSocket("ws://localhost:8080/JSP_project/alarm/notifications");

        // WebSocket 연결이 성공했을 때 실행
        socket.onopen = function(event) {
            console.log("WebSocket 연결 성공");
        };

        // WebSocket으로부터 알림 메시지를 받았을 때 실행
        socket.onmessage = function(event) {
            var notification = event.data;  // 서버로부터 받은 알림 메시지
            var notificationList = document.getElementById("notificationList");
            var li = document.createElement("li");
            li.textContent = notification;
            notificationList.appendChild(li);  // 새로운 알림을 목록에 추가
        };

        // WebSocket 연결이 종료되었을 때 실행
        socket.onclose = function(event) {
            console.log("WebSocket 연결 종료");
        };

        // WebSocket에서 오류가 발생했을 때 실행
        socket.onerror = function(event) {
            console.log("WebSocket 오류 발생: " + event);
        };
    </script>
</body>
</html>
