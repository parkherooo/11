<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="nutritionist.nutritionistMgr"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.util.Optional"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/main/header.jsp" %>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/mealplanresult.css">
<script>
	function send() {
		document.frm.submit();
	}
</script>
</head>
<body class="result-body">
	<%
		
		nutritionistMgr nMgr = new nutritionistMgr();
		String mealImage = nMgr.getMealImage(userId); // 이미지 경로 가져오기
	%>
	<form action="/JSP_project/ResultDeleteServlet" method="post" name="frm" class="container">
	<input type="hidden" name="userId" value="<%= userId %>">
		<h2>식단표</h2>
		<%
		if (mealImage != null) {
		%>
		<p class="result-p">새로운 식단을 신청하려면 기존의 식단을 삭제 후 재신청 가능합니다.</p>
		<img src="/JSP_project/nutritionist/images/<%=mealImage%>" alt="이미지" style="max-width: 100%; height: auto;">
		<div class="form-buttons">
			<input type="button" value="삭제" onclick="send()">
		</div>
		<%
		} else {
		%>
		<p class="result-p">아직 식단이 등록되지 않았습니다.</p>
		<%
		}
		%>

	</form>
<%@ include file="/chatbot/chatbot.jsp" %>    
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
