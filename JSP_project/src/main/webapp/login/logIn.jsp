<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">

<!-- 카카오 SDK -->
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<!-- 카카오 로그인 버튼 생성 -->
<script>
    // SDK 초기화
    Kakao.init('4a2b51f05cbee79aea7fde3f2167b65a'); // 발급받은 JavaScript 키로 변경
    console.log('SDK 초기화 여부:', Kakao.isInitialized()); // SDK 초기화 여부 확인

    // 카카오 로그인 함수
    function kakaoLogin() {
        Kakao.Auth.login({
            success: function(authObj) {
                // 액세스 토큰으로 사용자 정보 요청
                Kakao.API.request({
                    url: '/v2/user/me',
                    success: function(response) {
                        console.log('사용자 정보:', response);

                        // 사용자 정보를 서버로 전송
                        var xhr = new XMLHttpRequest();
                        xhr.open('POST', 'http://localhost/JSP_project/login/kakaoLogin'); // 서블릿 URL
                        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                        xhr.onload = function() {
                            console.log('서버 응답:', xhr.responseText);
                        };
                        xhr.send('accessToken=' + authObj.access_token + '&userId=' + response.id + '&nickname=' + response.properties.nickname);
                    },
                    fail: function(error) {
                        console.log('사용자 정보 요청 실패:', error);
                    },
                });
            },
            fail: function(err) {
                console.log('로그인 실패:', err);
            },
        });
    }

    // 카카오 로그인 버튼 생성  
	document.addEventListener('DOMContentLoaded', function() {
		console.log('createLoginButton 호출 시작'); // 로그 추가: 버튼 생성 함수가 호출되기 시작할 때

		Kakao.Auth.createLoginButton({
			container : '#kakao-login-btn',
			// size: 'large', // 필요 시 주석 처리
			success : function(authObj) {
				console.log('로그인 성공:', authObj); // 로그인 성공 시 콘솔에 출력
				kakaoLogin(authObj);
			},
			fail : function(err) {
				console.log('카카오 로그인 실패:', err); // 로그인 실패 시 콘솔에 출력
			}
		});

		console.log('createLoginButton 호출 완료'); // 로그 추가: 버튼 생성 함수가 호출이 완료되었을 때
	});
</script>

</head>
<%@ include file="../main/header.jsp" %>
<body class="loginbody">

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
            <div id="kakao-login-btn"></div>
        </div>
    </section>
    
<%@ include file="../chatbot/chatbot.jsp" %>
</body>
<footer>
    <%@ include file="../main/footer.jsp" %>
</footer>
</html>
