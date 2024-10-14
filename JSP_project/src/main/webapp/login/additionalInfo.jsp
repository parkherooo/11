<%@page import="user.UserMgr"%>
<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

    String sessionUserId = (String) session.getAttribute("userId");
    System.out.println("Session userId: " + sessionUserId);
   
    // 성공 여부를 위한 변수
    boolean success = false;

    // 폼 제출 여부 확인
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // UserBean 객체 생성 및 폼 데이터 설정
        UserBean user = new UserBean();
        user.setUserId(sessionUserId);
        user.setBirth(request.getParameter("birth"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        user.setAllergy(request.getParameter("allergy"));
        user.setGender(Integer.parseInt(request.getParameter("gender")));
        user.setHeight(Float.parseFloat(request.getParameter("height")));
        user.setWeight(Float.parseFloat(request.getParameter("weight")));

        // UserMgr를 사용하여 사용자 정보를 업데이트
        UserMgr userMgr = new UserMgr();
        success = userMgr.updateSocialUser(user);
    }

    // 성공 여부를 문자열로 변환
    String successStr = success ? "true" : "false";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 서버에서 전달된 성공 여부를 확인하여 alert 메시지를 표시
        const success = "<%= successStr %>";
        if (success === "true") {
            alert("회원가입이 완료되었습니다.");
            window.location.href = "../main/main.jsp"; // 메인 페이지로 리다이렉트
        } 
    });
</script>
</head>
<%@ include file="../main/header.jsp" %>
<body class="additionalbody">Z
    <section class="additional-info-section">
        <h1>추가 정보 입력</h1>
        <form id="additionalInfoForm" action="additionalInfo.jsp" method="post" class="additional-info-form">
            <input type="hidden" name="userId" value="<%= sessionUserId %>">
            <!-- 생일과 전화번호 -->
            <div>
                <label for="birth">생일:</label>
                <input type="date" id="birth" name="birth" required>
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
                <label for="allergy">알러지:</label>
                <input type="text" id="allergy" name="allergy" placeholder="알러지가 없다면 '없음'으로 입력">
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
