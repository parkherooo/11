<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<script>
	// 메일 전송
	function sendCode() {
    	const userId = document.getElementById("userId").value.trim();
    	if (userId === "") {
        	alert("아이디(이메일)를 입력해주세요.");
        	return false;
    	}
    	// 코드 전송 여부 플래그 설정
    	sessionStorage.setItem('codeSent', 'true');
    	document.getElementById("sendCodeForm").submit();
	}

	// 코드 인증
    function verifyCode() {
        const userId = document.getElementById("userId").value.trim();
        const code = document.getElementById("verificationCode").value.trim();

        // 이메일이 입력되지 않았을 때 경고
        if (userId === "") {
            alert("아이디(이메일)를 입력해주세요.");
            return false;
        }

     	// 코드가 전송되지 않았을 때 경고
        if (sessionStorage.getItem('codeSent') !== 'true') {
            alert("코드가 전송되지 않았습니다.");
            return false;
        }

        // 코드가 입력되지 않았을 때 경고
        if (code === "") {
            alert("코드를 입력해주세요.");
            return false;
        }
        
        document.getElementById("verifyCodeForm").submit();
    }
	
 	// 비밀번호 재설정 함수
    function resetPassword() {
        const userId = document.getElementById("userId").value.trim();
        const verificationCode = document.getElementById("verificationCode").value.trim();
        const newPassword = document.getElementById("newPassword").value.trim();
        const codeSent = '<%= session.getAttribute("codeSent") != null ? session.getAttribute("codeSent") : "false" %>';
        const codeVerified = '<%= session.getAttribute("codeVerified") != null ? session.getAttribute("codeVerified") : "false" %>';

        // 이메일이 입력되지 않았을 때 경고
        if (userId === "") {
            alert("아이디(이메일)를 입력해주세요.");
            return false;
        }

        // 코드가 전송되지 않았을 때 경고
        if (codeSent !== 'true') {
            alert("코드를 먼저 보내세요.");
            return false;
        }

        // 코드가 입력되지 않았을 때 경고
        if (verificationCode === "") {
            alert("코드가 입력되지 않았습니다.");
            return false;
        }

        // 코드가 확인되지 않았을 때 경고
        if (codeVerified !== 'true') {
            alert("코드 인증 확인을 해주세요.");
            return false;
        }

        // 비밀번호가 입력되지 않았을 때 경고
        if (newPassword === "") {
            alert("새 비밀번호를 입력해주세요.");
            return false;
        }

        // 모든 조건이 만족되면 비밀번호 재설정 진행
        document.getElementById("resetPwdForm").submit();
    }
 	
 	
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const sendCode = urlParams.get("sendCode");
        const codeVerified = urlParams.get("codeVerified");
        const resetPwd = urlParams.get("resetPwd");

        if (sendCode === "true") {
            alert("인증 코드가 이메일로 전송되었습니다.");
        } else if (sendCode === "false") {
            alert("이메일 전송에 실패했습니다.");
        }

        if (codeVerified === "true") {
            alert("인증 코드가 확인되었습니다.");
        } else if (codeVerified === "false") {
            alert("인증 코드가 일치하지 않습니다.");
        }

        if (resetPwd === "true") {
            alert("비밀번호를 재설정하였습니다.");
            window.location.href = '../login/logIn.jsp';
        } else if (resetPwd === "false") {
            alert("비밀번호 재설정에 실패했습니다.");
        }
    });

</script>
</head>
<body>

<%@ include file="../main/header.jsp" %>
	<section class="find-pwd-section">
    <h1>비밀번호 찾기</h1>

    <!-- userId로 코드 전송 -->
    <form id="sendCodeForm" action="sendCode" method="post">
        <input type="text" id="userId" name="userId" placeholder="아이디 (이메일)" 
               value="<%= (request.getParameter("sendCode") != null && request.getParameter("sendCode").equals("true")) || (request.getParameter("codeVerified") != null && request.getParameter("codeVerified").equals("true")) ? session.getAttribute("resetUserId") : "" %>" 
               required><br>
        <button type="button" onclick="sendCode()">코드 보내기</button>
    </form>

    <!-- 코드 입력 및 검증 -->
    <form id="verifyCodeForm" action="verifyCode" method="post">
        <input type="text" id="verificationCode" name="verificationCode" placeholder="이메일로 받은 코드 입력" 
               value="<%= (request.getParameter("codeVerified") != null && request.getParameter("codeVerified").equals("true")) ? session.getAttribute("verificationCode") : "" %>" required><br>
        <input type="hidden" name="userId" value="<%= (String) session.getAttribute("resetUserId") %>">
        <button type="button" onclick="verifyCode()">코드 확인</button>
    </form>

    <!-- 비밀번호 재설정 -->
    <form id="resetPwdForm" action="resetPassword" method="post">
        <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호 입력" required><br>
        <input type="hidden" name="userId" value="<%= (String) session.getAttribute("resetUserId") %>">
        <button type="button" onclick="resetPassword()">비밀번호 재설정</button>
    </form>
    <div class="options">
        <a href="../signup/signUp.jsp">회원가입</a> | <a href="findId.jsp">아이디 찾기</a> | <a href="findPwd.jsp">비밀번호 찾기</a>
    </div>
	</section>

<%@ include file="../chatbot/chatbot.jsp" %>
<%@ include file="../main/footer.jsp" %>
</body>
</html>
