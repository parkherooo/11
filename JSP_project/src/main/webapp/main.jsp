<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="css/main.css">
<script>
	// 로그인 페이지로 이동하는 함수
	function goToLogin() {
		window.location.href = "logIn.jsp";
	}
</script>
</head>
<body>
	<!-- 헤더(상단 배너) -->
	<header>
        <div class="banner">
            <div class="logo">
                <a href="main.jsp">
                	<img src="img/logo.png" alt="Fit Time 로고"/>
            	</a>
            </div>
            <nav>
                <ul>
                    <li><a href="recipe.jsp">Recipe</a></li>
                    <li><a href="diet.jsp">Diet</a></li>
                    <li><a href="exercise.jsp">Exercise</a></li>
                    <li><a href="community.jsp">Community</a></li>
                    <li><a href="notice.jsp">Notice</a></li>
                </ul>
                <div class="login-container">
                <a href="logIn.jsp">
                    <button class="login-btn1" onclick="goToLogin()">Login</button>
                </a>
            	</div>
            </nav>
        </div>
    </header>
    
    <!-- 메인 콘텐츠 섹션 -->
    <section class="main-content">
    <div class="content-wrapper">
        <!-- 왼쪽 화살표 -->
        <div class="arrow left-arrow">
            <img src="img/arrow.png" alt="Left Arrow">
        </div>
        
        <!-- 슬라이드 내용 -->
        <div class="slide">
            <h2>아보카도 토마토 샐러드</h2>
            <p>부드러운 아보카도와 신선한 토마토가 어우러진 상큼한 샐러드</p>
        </div>
        
        <!-- 오른쪽 화살표 -->
        <div class="arrow right-arrow">
            <img src="img/arrow.png" alt="Right Arrow">
        </div>
    </div>

    <!-- 슬라이드 네비게이션 -->
    <div class="slider-nav">
        <span class="current-slide">1</span>
        <div class="line"></div>
        <span class="total-slides">10</span>
    </div>
	</section>

</body>
</html>