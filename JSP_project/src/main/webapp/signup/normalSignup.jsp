<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
</head>
<body>
<%@ include file="../main/header.jsp" %>
	<section class="normal-signup-section">
        <h1>회원가입</h1>
        <form action="normalSignUpProc.jsp" method="post" class="normal-signup-form">
            <!-- 이름 -->
            <div class="full-width">
                <label for="name">이름:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <!-- 아이디와 비밀번호 -->
            <div>
                <label for="userId">아이디(이메일):</label>
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
                    <option value="male">남성</option>
                    <option value="female">여성</option>
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