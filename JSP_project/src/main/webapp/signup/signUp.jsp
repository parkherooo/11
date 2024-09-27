<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">

<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js"></script>

<script type="text/javascript">
    // 카카오 로그인 버튼 생성 함수
    function createKakaoLoginButton() {
        if (Kakao.isInitialized()) {
            Kakao.Auth.createLoginButton({
                container: '#kakao-login-btn',
                size: 'medium',
                success: function(authObj) {
                    document.getElementById("access_token").value = authObj.access_token;
                    document.getElementById("loginForm").submit();
                },
                fail: function(err) {
                    console.error(err);
                }
            });
        } else {
            console.error('Kakao SDK가 초기화되지 않았습니다.');
        }
    }

    // 네이버 로그인 버튼 생성 함수
    function initNaverLogin() {
        var naverLogin = new naver.LoginWithNaverId({
            clientId: "w345Zx3BXiwPQv_AAe9S",
            callbackUrl: "http://localhost/JSP_project/login/naverLoginProc.jsp",
            isPopup: true,
            loginButton: { color: "green", type: 3, height: 48, width: 150}
        });
        naverLogin.init();
    }

    // 페이지가 완전히 로드된 후 실행될 함수
    window.onload = function() {
        // 카카오 SDK 초기화
        if (!Kakao.isInitialized()) {
            Kakao.init('4a2b51f05cbee79aea7fde3f2167b65a');
        }

        // 카카오 로그인 버튼 생성
        createKakaoLoginButton();

        // 네이버 로그인 버튼 생성
        initNaverLogin();
    };
</script>
</head>
<body class="signupbody">
<%@ include file="../main/header.jsp" %>
	<!-- 회원가입 폼 -->
    <section class="signup-section">
        <h1>회원가입</h1>
        <!-- 일반 회원가입 폼 -->
        <form id="normalSignupForm" action="normalSignup.jsp" method="post">
        	<p>당신의 건강한 변화를 돕겠습니다 :-)</p><br>
            <button type="submit" class="signup-btn">이메일 주소로 회원가입</button>
            <div class="options">
                <a href="../login/logIn.jsp">로그인</a> | <a href="../find//findId.jsp">아이디 찾기</a> | <a href="../find//findPwd.jsp">비밀번호 찾기</a>
            </div>
        </form>

        <!-- 소셜 로그인 -->
        <div class="social-login">
            <p>소셜미디어 계정으로 가입</p>
            <!-- 카카오 로그인 문구 및 버튼 -->
            <div id="kakao-login-btn"></div>
            <!-- 네이버 로그인 문구 및 버튼 -->
            <div id="naverIdLogin"></div>
        </div>
    </section>
<%@ include file="../chatbot/chatbot.jsp" %>
<%@ include file="../main/footer.jsp" %>
</body>
</html>