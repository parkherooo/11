<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserMgr" %>
<%
    // AJAX 요청을 받으면 처리
    if (request.getParameter("checkDuplicate") != null) {
        String userId = request.getParameter("userId");
        UserMgr mgr = new UserMgr();
        boolean isDuplicate = mgr.idChk(userId);

        if (isDuplicate) {
            out.print("DUPLICATE"); // 이미 사용 중인 아이디
        } else {
            out.print("OK"); // 사용 가능한 아이디
        }

        return; // AJAX 처리만 하고 바로 종료
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<script>
    var isEmailValid = false; // 이메일 형식이 맞는지 여부
    var isIdChecked = false;  // 아이디 중복 확인 여부

    // 이메일 형식 확인 함수
    function validateEmail(email) {
        var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailPattern.test(email);
    }

    // 중복 확인 버튼 클릭 시 실행되는 함수
    function checkDuplicate() {
        var userId = document.getElementById("userId").value;

        // 이메일 형식 확인
        if (!validateEmail(userId)) {
            alert("아이디는 이메일 형식이어야 합니다.");
            isEmailValid = false;
            return;
        } else {
            isEmailValid = true;
        }

        // AJAX 요청으로 중복 확인
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "", true); // 현재 페이지로 POST 요청
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4 && xhr.status == 200) {
                if (xhr.responseText.trim() === "OK") {
                    alert("사용 가능한 아이디입니다.");
                    isIdChecked = true; // 중복 확인 성공
                } else {
                    alert("이미 사용 중인 아이디입니다.");
                    isIdChecked = false; // 중복 확인 실패
                }
            }
        };
        xhr.send("checkDuplicate=true&userId=" + encodeURIComponent(userId));
    }

    // 회원가입 버튼 클릭 시 중복 확인 여부 확인
    
	function validateForm() {
		// 중복 확인 여부 먼저 확인
		if (!isIdChecked) {
			alert("아이디 중복 확인을 해주세요.");
			return false;
		}

		// 이메일 형식이 잘못된 경우만 체크
		var userId = document.getElementById("userId").value;
		if (!validateEmail(userId)) {
			alert("유효한 이메일 형식이 아닙니다.");
			return false;
		}

		return true; // 중복 확인 및 이메일 검증이 모두 통과되면 회원가입 가능
	}
</script>
</head>
<body>
<%@ include file="../main/header.jsp" %>
	<section class="normal-signup-section">
        <h1>회원가입</h1>
        <form action="normalSignUpProc.jsp" method="post" class="normal-signup-form" onsubmit="return validateForm()">
            <!-- 이름 -->
            <div class="full-width">
                <label for="name">이름:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <!-- 아이디와 비밀번호 -->
            <div class = "email-field">
                <label for="userId">아이디(이메일):</label>
                <button type="button" class="idchk-btn" onclick="checkDuplicate()">중복 확인</button>
                <input type="text" id="userId" name="userId" required>
            </div>
            <div>
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <!-- 생일과 전화번호 -->
            <div>
                <label for="birthDate">생일:</label>
                <input type="date" id="birthDate" name="birthDate" required>
            </div>
            <div>
                <label for="phone">전화번호:</label>
                <input type="tel" id="phone" name="phone" required pattern="[0-9]{3}[0-9]{4}[0-9]{4}" placeholder="01012345678">
            </div>
            <!-- 주소 (전체 너비 사용) -->
            <div class="full-width">
                <label for="address">주소:</label>
                <input type="text" id="address" name="address" required>
            </div>
            <!-- 알러지와 성별 -->
            <div>
                <label for="allergies">알러지:</label>
                <input type="text" id="allergies" name="allergies" placeholder="알러지가 없다면 '없음'으로 입력">
            </div>
            <div>
                <label for="gender">성별:</label>
                <select id="gender" name="gender" required>
                    <option value="1">남성</option>
                    <option value="0">여성</option>
                </select>
            </div>
            <!-- 키와 몸무게 -->
            <div>
                <label for="height">키 (cm):</label>
                <input type="number" id="height" name="height" min="50" max="300" required>
            </div>
            <div>
                <label for="weight">몸무게 (kg):</label>
                <input type="number" id="weight" name="weight" min="20" max="300" required>
            </div>
            <!-- 제출 버튼 -->
            <div class="full-width">
                <button type="submit" class="normal-signup-btn">회원가입</button>
            </div>
        </form>
    </section>
<%@ include file="../chatbot/chatbot.jsp" %>
<%@ include file="../main/footer.jsp" %>
</body>
</html>