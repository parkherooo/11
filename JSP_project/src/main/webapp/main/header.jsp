<%@ page language="java"  pageEncoding="UTF-8"%>

<%
	// 이미 제공되는 session 객체를 사용하여 userId를 가져옴
	String userId = (String) session.getAttribute("userId");
	String name = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>

<link rel="stylesheet" href="../css/main.css">

<script>
	// 로그인 페이지로 이동하는 함수
	function goToLogin() {
		window.location.href = "../login/logIn.jsp";
	}
	
	// 마이페이지로 이동하는 함수
	function goToMyPage() {
		window.location.href = "../mypage/myPage.jsp";
	}
	
	// 로그아웃 페이지로 이동하는 함수
	function goToLogout() {
		if (confirm("로그아웃 하시겠습니까?")) {
			window.location.href = "../login/logOut.jsp"; 
		}
	}
</script>
</head>
<body>
	<!-- header.jsp -->
	<header>
    <div class="banner">
    	<!-- 환영 메시지 -->
        <% if (name != null) { %>
            <div class="welcome-message">
                <span><%= name %>님 환영합니다!</span>
            </div>
        <% } %>
        <div class="logo">
            <a href="../main/main.jsp">
                <img src="../img/logo.png" alt="Fit Time 로고"/>
            </a>
        </div>
        <nav>
            <ul>
                <li><a href="../recipe/recipeList.jsp">Recipe</a></li>
                <li>
                	<a href="">Diet</a>
                	<ul class="dropdown-menu">
                        <li><a href="diet1.jsp">식단 기록</a></li>
                        <li><a href="diet2.jsp">하루 권장 칼로리</a></li>
                    </ul>
                </li>
                <li>
                	<a href="">Exercise</a>
                	<ul class="dropdown-menu">
                        <li><a href="diet1.jsp">운동 기록</a></li>
                        <li><a href="diet2.jsp">목표 설정</a></li>
                        <li><a href="diet2.jsp">오늘의 루틴 추천</a></li>
                    </ul>
                </li>
                <li>

                	<a href="">Community</a>
                	<ul class="dropdown-menu">
                        <li><a href="../community/Community_Main.jsp">나의 게시글</a></li>
                        <li><a href="../community/Heart.jsp">인기글</a></li>
                        <li><a href="../community/post_create.jsp">게시물 작성</a></li>	
                    </ul>

                </li>
                 <li><a href="../challenge/challengeList.jsp">Challenge</a></li>
                <li><a href="../notice/noticeList.jsp">Notice</a></li>
            </ul>
            <!-- 로그인 상태 -->
        	<% if (userId != null) { %>
        	<div class="notification-container">
            	<img src="../img/bell.png" alt="Notification Bell" class="notification-bell">
        	</div>
        	<div class="login-container">
            	<button class="mypage-btn" onclick="goToMyPage()">MyPage</button>&nbsp;&nbsp;
            	<button class="logout-btn" onclick="goToLogout()">Logout</button>
        	</div>
        	<!-- 로그아웃 상태 -->
        	<% } else { %>
        	<div class="login-container">
            	<button class="login-btn1" onclick="goToLogin()">Login</button>
        	</div>
        	<% } %>
        	</nav> 
    </div>
	</header>
</body>
</html>