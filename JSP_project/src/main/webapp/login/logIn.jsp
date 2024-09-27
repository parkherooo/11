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
        // 카카오 SDK 초기화가 안 된 경우 초기화
        if (!Kakao.isInitialized()) {
            Kakao.init('4a2b51f05cbee79aea7fde3f2167b65a');  // 본인의 JavaScript 키를 입력
            console.log('Kakao SDK 초기화 완료');
        }
        
        // 초기화 후 로그인 버튼 생성
        Kakao.Auth.createLoginButton({
            container: '#kakao-login-btn',
            size: 'medium',
            success: function(authObj) {
                console.log(authObj);
                document.getElementById("access_token").value = authObj.access_token;
                document.getElementById("loginForm").submit();
            },
            fail: function(err) {
                console.error(err);
            }
        });
    }

    // 네이버 로그인 버튼 생성 함수
    function initNaverLogin() {
        var naverLogin = new naver.LoginWithNaverId({
            clientId: "w345Zx3BXiwPQv_AAe9S",  // 네이버 클라이언트 ID
            callbackUrl: "http://localhost/JSP_project/login/naverLoginProc.jsp",
            isPopup: true,
            loginButton: { color: "green", type: 3, height: 48, width: 150 }
        });
        naverLogin.init();
        console.log('Naver SDK 초기화 완료');
    }

    // 페이지가 완전히 로드된 후 실행
    window.onload = function() {
        createKakaoLoginButton();
        initNaverLogin();
    };
</script>

</head>
<%@ include file="../main/header.jsp" %>
<body class="loginbody">

    <!-- 로그인 폼 -->
    <section class="login-section">
        <h1>로그인</h1>
        <!-- 일반 로그인 폼 -->
        <form id="normalLoginForm" action="normalLoginProc.jsp" method="post">
            <input class="login-input" type="text" name="myuserId" placeholder="아이디 (이메일)" required><br>
            <input class="login-input" type="password" name="password" placeholder="비밀번호" required><br>
            <button  type="submit" class="login-btn2">로그인</button>
            <div class="options">
                <a href="../signup/signUp.jsp">회원가입</a> | <a href="../find/findId.jsp">아이디 찾기</a> | <a href="../find/findPwd.jsp">비밀번호 찾기</a>
            </div>
        </form>

        <!-- 소셜 로그인 -->
        <div class="social-login">
            <p>소셜미디어 계정으로 로그인</p>
            <!-- 카카오 로그인 문구 및 버튼 -->
            <div id="kakao-login-btn"></div>
            <!-- 네이버 로그인 문구 및 버튼 -->
            <div id="naverIdLogin"></div>
        </div>
    </section>
    
    <!-- 카카오 로그인 토큰을 서버로 전송할 폼 -->
    <form id="loginForm" action="kakaoLoginProc.jsp" method="post">
        <input type="hidden" id="access_token" name="access_token" />
    </form>
<%@ include file="../chatbot/chatbot.jsp" %>

</body>
<footer><%@ include file="../main/footer.jsp" %></footer>
</html>
