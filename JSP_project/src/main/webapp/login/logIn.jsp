<%@page import="java.math.BigInteger"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<!-- 카카오 SDK 불러오기 -->
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<!-- 네이버 SDK 불러오기 -->
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js"></script>

<script>
    // 카카오 SDK 초기화
    Kakao.init('4a2b51f05cbee79aea7fde3f2167b65a'); // 실제 JavaScript 앱 키 사용
    console.log(Kakao.isInitialized()); // true 여부 확인
    
    // 카카오 사용자 정보 요청
    function getKakaoUserInfo() {
        Kakao.API.request({
            url: '/v2/user/me',
            success: function(response) {
                console.log("response:", response); // 확인용 로그
                const kakaoAccount = response.kakao_account;

                // 정확한 이메일 정보 가져오기
                const userId = kakaoAccount.account_email; // 이메일이 userId로 사용
                const name = kakaoAccount.profile.nickname; // 이름 또는 닉네임

                // 로그인 후 서버로 전송하기
                document.getElementById('kakaoUserId').value = userId;
                document.getElementById('kakaoName').value = name;
                document.getElementById('kakaoLoginForm').submit();
            },
            fail: function(error) {
                console.error("Failed to get user info:", error);
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
    	// 카카오 로그인 버튼 생성
        Kakao.Auth.createLoginButton({
            container: '#kakao-login-btn',
            scope: 'profile_nickname, account_email', // 필요한 동의 항목 설정
            success: function(authObj) {
                console.log("authObj:", authObj); // 확인용 로그
                getKakaoUserInfo(); // 로그인 성공 시 정보 가져오기
            },
            fail: function(err) {
                console.log("Failed to log in:", err);
            }
        });
        
    });
</script>
</head>
<%@ include file="../main/header.jsp" %>
<body>

	<% 
        // 네이버 로그인 URL 생성 부분
        String clientId = "w345Zx3BXiwPQv_AAe9S"; // 애플리케이션 클라이언트 아이디값
        String redirectURI = URLEncoder.encode("http://localhost/JSP_project/login/naverCallback", "UTF-8");
        SecureRandom random = new SecureRandom();
        String state = new BigInteger(130, random).toString();
        String naverApiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
        naverApiURL += "&client_id=" + clientId;
        naverApiURL += "&redirect_uri=" + redirectURI;
        naverApiURL += "&state=" + state;
        session.setAttribute("state", state);
    %>
    <!-- 로그인 폼 -->
    <section class="login-section">
        <h1>로그인</h1>
        <!-- 일반 로그인 폼 -->
        <form id="normalLoginForm" action="normalLogin" method="post">
            <input class="login-input" type="text" name="myuserId" placeholder="아이디 (이메일)" required><br>
            <input class="login-input" type="password" name="password" placeholder="비밀번호" required><br>
            <button type="submit" class="login-btn2">로그인</button>
            <div class="options">
                <a href="../signup/signUp.jsp">회원가입</a> | <a href="../find/findId.jsp">아이디 찾기</a> | <a href="../find/findPwd.jsp">비밀번호 찾기</a>
            </div>
        </form>

        <!-- 소셜 로그인 -->
        <div class="social-login">
            <p>소셜미디어 계정으로 로그인</p>
            <!-- 카카오 로그인 버튼 -->
        	<div id="kakao-login-btn"></div>
        	<!-- 네이버 로그인 버튼 -->
    		<div>
        		<a href="<%= naverApiURL %>"><img height="50" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/></a>
    		</div>
        </div>
        <!-- 카카오 로그인 정보 폼 -->
        <form id="kakaoLoginForm" action="kakaoLogin" method="post">
            <input type="hidden" name="kakaoUserId" id="kakaoUserId">
            <input type="hidden" name="kakaoName" id="kakaoName">
        </form>
        
    </section>
    
<%@ include file="../chatbot/chatbot.jsp" %>
</body>
<footer>
    <%@ include file="../main/footer.jsp" %>
</footer>
</html>
