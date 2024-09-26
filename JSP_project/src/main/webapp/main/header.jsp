<%@ page language="java"  pageEncoding="UTF-8"%>

<%
//이미 제공되는 session 객체를 사용하여 userId를 가져옴
String userId = (String) session.getAttribute("userId");
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
			window.location.href = "../login/logOut.jsp"; // 로그아웃 페이지로 이동
		}
	}
</script>
</head>
<body>
	<!-- header.jsp -->
	<header>
    <div class="banner">
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
                <li><a href="community.jsp">Community</a></li>
                <li><a href="../notice/noticeList.jsp">Notice</a></li>
            </ul>
            <div class="login-container">
                <% if (userId != null) { %>
                    <!-- 로그인 상태라면 MyPage 버튼 -->
                    <button class="login-btn1" onclick="goToMyPage()">MyPage</button>
                    <button class="login-btn1" onclick="goToLogout()">Logout</button>
                <% } else { %>
                    <!-- 로그아웃 상태라면 Login 버튼 -->
                    <button class="login-btn1" onclick="goToLogin()">Login</button>
                <% } %>
            </div>
        </nav>
    </div>
	</header>
</body>
</html>