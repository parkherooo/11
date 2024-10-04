<%@page import="challenge.ChallengeBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/main/header.jsp" %>
<meta charset="UTF-8">
<title>Challenge Insert</title>
<script>
    function validateDates() {
        const startDate = document.getElementById("startDate").value;
        const endDate = document.getElementById("endDate").value;

        if (startDate === endDate) {
            alert("시작 날짜와 끝나는 날짜는 같을 수 없습니다.");
            return false; // 폼 제출 중단
        }

        if (new Date(startDate) > new Date(endDate)) {
            alert("시작 날짜는 끝나는 날짜보다 빨라야 합니다.");
            return false; // 폼 제출 중단
        }

        return true; // 유효성 검사 통과
    }
</script>
</head>
<body style="text-align: center;">
    <h3>Challenge 열기</h3>
    <form action="challengeInsert" method="post" onsubmit="return validateDates();" style="text-align: left;">
        <label>챌린지명</label><br>
        <input type="text" name="challengeName" required><br>
        <label>챌린지 설명</label><br>
        <textarea id="description" name="description" rows="15" required></textarea><br>
        <label>챌린지 시작 날짜</label><br>
        <input type="date" id="startDate" name="startDate" required><br>
        <label>챌린지 끝나는 날짜</label><br>
        <input type="date" id="endDate" name="endDate" required><br>
        <label>챌린지 목표</label><br>
        <input type="text" name="goal" required><br>
        <button type="submit" class="btn btn-primary">작성</button>
    </form>
    <br>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
