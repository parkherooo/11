<%@page import="nutritionist.nutritionistBean"%>
<%@page import="nutritionist.nutritionistMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/main/header.jsp" %>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/mealplanrequest.css">
<script type="text/javascript">
function send() {
	// 로그인 상태 확인
    var isLoggedIn = <%= session.getAttribute("userId") != null ? "true" : "false" %>; // 세션에 로그인 정보가 있으면 true

    if (!isLoggedIn) {
        alert("로그인 후 이용 가능합니다.");
        window.location.href = "/JSP_project/login/logIn.jsp";
    } else {
        document.frm.submit();
    }
}
</script>
</head>
<body class="request-body">
	<% 
    	nutritionistMgr nMgr = new nutritionistMgr();
    	nutritionistBean bean = nMgr.isRequestExists(userId);
        if (bean != null) {
    %>
        <div class="already">
            <p class="request-p">이미 신청된 식단이 존재합니다.</p>
        </div>
    <%
        } else {
    %>
    <p class="request-p">식단 신청</p> 
	<form action="/JSP_project/RequestInsertServlet" method="post" name="frm" class="container">
	<input type="hidden" name="userId" value="<%= userId %>">
	<div class="form-group">
	<div class="form-row">
  	<label for="title">일일 식사 횟수</label>
 	<input type="number" id="count" name="count" min="1" max="5" required>
	</div></div>
	
	<div class="form-group">
	<div class="form-row">
  	<label for="title">일일 칼로리 (kcal)</label>
  	<input type="number" id="calorie" name="calorie" min="500" max="5000" required>
	</div></div>
  	
  	<div class="form-group">
  	<div class="form-row">
  	<label for="title">알러지</label>
  	<small>* 해당되는 경우 입력해주세요.</small>
	</div>
 	<textarea id="allergy" name="allergy" placeholder="ex) 견과류, 유제품"></textarea>
	</div>
  	
  	<div class="form-group">
  	<div class="form-row">
  	<label for="title">비선호 식품</label>
  	<small>* 원하지 않는 식재료가 있다면 알려주세요.</small>
	</div>
	<textarea id="dontlike" name="dontlike" placeholder="ex) 특정 채소, 생선" rows="3"></textarea>
	</div>
  	
  	<div class="form-group">
  	<label for="title">추가 요구 사항</label><br>
  	<textarea id="requirement" name="requirement" placeholder="ex) 비건 / 저탄수화물(키토제닉) / 혈당 관리" rows="3"></textarea>
  	</div>

  	<div class="form-group" style="text-align: right;">
  	<div class="form-buttons">
  	<% if(userId=="root"){ %>
    <input type="button" value="리스트" onclick="location.href='mealPlanList.jsp'">
    <%}%>
    <input type="button" value="제출" onclick="send()">
	</div>

  	</div>
</form>
<% } %>
<%@ include file="/chatbot/chatbot.jsp" %>    
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>