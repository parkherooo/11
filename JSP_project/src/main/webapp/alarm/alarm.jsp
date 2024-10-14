<%@ page pageEncoding="UTF-8" %>
<%@page import="mypage.freindBean"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fit Time</title>
    <!-- Font Awesome 아이콘 라이브러리 추가 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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
</body>
</html>
