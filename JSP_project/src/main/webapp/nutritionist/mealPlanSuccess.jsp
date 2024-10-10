<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/mealplanrequest.css">
<style>
.button-container {
        display: flex;
        justify-content: center; /* 수평 중앙 정렬 */
        margin-top: 50px; /* 버튼과 위쪽 요소 간의 간격 조정 */
}
</style>
</head>
<body>
	<p style="font-size: 30px; margin-bottom: 70px;">식단 신청 완료</p>

	<p>식단이 준비될 때까지 기다려주세요!</p>

	<div class="button-container">
		<input type="button" value="돌아가기" onclick="window.location.href = 'mealPlanResult.jsp'">
	</div>
</body>
</html>
