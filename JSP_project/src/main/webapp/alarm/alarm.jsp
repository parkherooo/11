<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@page import="mypage.freindBean"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fit Time</title>
    <link rel="stylesheet" href="../css/alarm.css?after">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="../alarm/alarm.js"></script>
</head>
<body>
    <!-- header.jsp -->
    <header>
        <div class="notification-container">
            <!-- 알림 벨 아이콘 -->
            <img src="../img/bell.png" alt="Notification Bell" class="notification-bell" onclick="toggleNotificationBox()">
            
            <!-- 알림 박스 -->
            <div id="notificationBox" class="notification-box" style="display:none;">
                <ul id="notificationList">
                </ul>
                <div class="close-btn" onclick="toggleNotificationBox()">닫기</div>
            </div>
        </div>
    </header>
    

    <!-- 페이지 로드 시 알림 체크 시작 -->
    <script>
        window.onload = function() {
            // 5초마다 알림을 확인하는 함수 호출
            checkNewAlarms();  
        }
    </script>
</body>
</html>
