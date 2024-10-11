<%@page import="challenge.ChallengeBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/main/header.jsp" %>
<meta charset="UTF-8">
<title>Challenge Insert</title>
<style>
    body {
        text-align: center;
	    position: relative;
		top:200px;
    }

    h3 {
        margin-top: 50px;
        font-size: 28px;
    }

    form {
        display: block; /* inline-block 대신 block으로 변경 */
	    margin: 0 auto; /* 폼을 수평 중앙에 배치 */
	    text-align: left; /* 폼 내부는 왼쪽 정렬 */
	    margin-bottom: 200px;
	    padding: 30px;
	    border-radius: 10px;
	    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	    width: 400px;
    }

    label {
    	margin:10px;
        display: block;
        font-weight: bold;
        margin-bottom: 10px;
    }

    input[type="text"], input[type="date"], textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

    textarea {
        resize: none;
    }

    .c-btn {
        margin-top:20px;
        width: 100%;
        padding: 10px;
        background-color: black;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
    }

    .c-btn:hover {

        background-color: gray;
    }


</style>
<script>
    function validateDates() {
        const startDate = document.getElementById("startDate").value;
        const endDate = document.getElementById("endDate").value;
        const today = new Date().toISOString().split('T')[0]; // 현재 날짜

        if (startDate === endDate) {
            alert("시작 날짜와 끝나는 날짜는 같을 수 없습니다.");
            return false; // 폼 제출 중단
        }

        if (new Date(startDate) > new Date(endDate)) {
            alert("시작 날짜는 끝나는 날짜보다 빨라야 합니다.");
            return false; // 폼 제출 중단
        }

        if (endDate < today) {
            alert("끝나는 날짜는 현재 날짜보다 뒤여야 합니다.");
            return false; // 폼 제출 중단
        }

        return true; // 유효성 검사 통과
    }
</script>

</head>
<body>
    <h3>Challenge 열기</h3>
    <form action="challengeInsert" method="post" onsubmit="return validateDates();">
        <label>챌린지명</label>
        <input type="text" name="challengeName" required>

        <label>챌린지 설명</label>
        <textarea id="description" name="description" rows="5" required></textarea>

        <label>챌린지 시작 날짜</label>
        <input type="date" id="startDate" name="startDate" required>

        <label>챌린지 끝나는 날짜</label>
        <input type="date" id="endDate" name="endDate" required>

        <label>챌린지 목표</label>
        <input type="text" name="goal" required>

        <button class="c-btn" type="submit">작성</button>
    </form>
 <%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
