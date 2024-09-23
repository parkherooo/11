<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<!-- 공통 CSS 파일 -->
<link rel="stylesheet" href="css/main.css">
<!-- 추가 CSS 파일 -->
<link rel="stylesheet" href="css/login.css">

<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">
    // 카카오 JavaScript SDK 초기화
    Kakao.init('4a2b51f05cbee79aea7fde3f2167b65a'); // 카카오 디벨로퍼스에서 발급받은 JavaScript 키 입력
    
 	// 카카오 로그인 버튼 생성
    function createKakaoLoginButton() {
        Kakao.Auth.createLoginButton({
            container: '#kakao-login-btn', // 버튼이 삽입될 컨테이너
            size: 'medium', // 버튼 크기: small, medium, large 선택 가능
            success: function(authObj) {
                console.log(authObj); // 로그인 성공 시 처리
                // access_token을 폼에 넣고 서버로 전송
                document.getElementById("access_token").value = authObj.access_token;
                document.getElementById("loginForm").submit();
            },
            fail: function(err) {
                console.error(err); // 로그인 실패 시 처리
            }
        });
    }

    // 페이지 로드 시 카카오 로그인 버튼 생성
    window.onload = function() {
        createKakaoLoginButton();
    };
</script>
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js"></script>
<script type="text/javascript" >
    var naverLogin = new naver.LoginWithNaverId({
        clientId: "w345Zx3BXiwPQv_AAe9S", // 네이버 애플리케이션에서 발급받은 Client ID
        callbackUrl: "http://localhost/JSP_project/main.jsp", // 인증 후 네이버에서 리다이렉트할 URL
        isPopup: false, // 팝업 형식으로 로그인 여부
        loginButton: { color: "green", type: 3, height: 48 } // 로그인 버튼의 스타일 설정
    });

    naverLogin.init(); // 네이버 로그인 초기화

    // 사용자 정보 가져오기
    function getNaverUserProfile() {
        naverLogin.getLoginStatus(function(status) {
            if (status) {
                var email = naverLogin.user.getEmail();
                var name = naverLogin.user.getName();
                console.log("사용자 이메일: " + email);
                console.log("사용자 이름: " + name);
            } else {
                console.error("로그인 상태가 아닙니다.");
            }
        });
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
                    <button class="login-btn1" onclick="loginWithKakao()">Login</button>
                </div>
            </nav>
        </div>
    </header>
    <!-- 로그인 폼 -->
    <section class="login-section">
        <h1>로그인</h1>
        <!-- 일반 로그인 폼 -->
        <form id="normalLoginForm" action="normalLogin.jsp" method="post">
            <input type="text" name="email" placeholder="아이디 (이메일주소)" required><br>
            <input type="password" name="password" placeholder="비밀번호" required><br>
            <button type="submit" class="login-btn2">로그인</button>
            <div class="options">
                <a href="signUp.jsp">회원가입</a> | <a href="#">로그인 정보 찾기</a>
            </div>
        </form>

        <!-- 소셜 로그인 -->
        <div class="social-login">
            <p>소셜미디어 계정으로 로그인</p>
            <!-- 카카오 로그인 버튼 -->
            <div id="kakao-login-btn"></div>
            <!-- 네이버 로그인 버튼 -->
			<div id="naverIdLogin"></div>
        </div>
    </section>
    
    <!-- 카카오 로그인 토큰을 서버로 전송할 폼 -->
    <form id="loginForm" action="kakaoLoginProc.jsp" method="post">
        <input type="hidden" id="access_token" name="access_token" />
    </form>
</body>
</html>
