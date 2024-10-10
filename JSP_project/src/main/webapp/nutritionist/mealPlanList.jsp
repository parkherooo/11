<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="nutritionist.nutritionistMgr"%>
<%@ page import="nutritionist.nutritionistBean"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/main/header.jsp" %>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/mealplanlist.css">
<script type="text/javascript">

function send(index) {
    document.forms['frm_' + index].submit();
}

</script>
</head>
<body class="list-body">
	<p class="list-p">식단 신청 리스트</p>

	<div class="container">
		<table>
			<thead>
				<tr>
					<th>사용자 ID</th>
					<th>식사 횟수</th>
					<th>칼로리</th>
					<th>알러지</th>
					<th>비선호 식품</th>
					<th>추가 요구사항</th>
					<th>식단 등록 여부</th>
					<th>식단표 등록</th>
				</tr>
			</thead>
			<tbody>
				<%
				nutritionistMgr nMgr = new nutritionistMgr();
				ArrayList<nutritionistBean> lists = nMgr.requestList();
				request.setAttribute("lists", lists);

				if (lists != null && !lists.isEmpty()) {
					for (int i = lists.size() - 1; i >= 0; i--) {
				%>
				<tr>
					<td><%= lists.get(i).getUserId() %></td>
					<td><%= lists.get(i).getCount() %></td>
					<td><%= lists.get(i).getCalorie() %></td>
					<td><%= (lists.get(i).getAllergy() != null && !lists.get(i).getAllergy().isEmpty()) ? lists.get(i).getAllergy() : "없음" %></td>
					<td><%= (lists.get(i).getDontlike() != null && !lists.get(i).getDontlike().isEmpty()) ? lists.get(i).getDontlike() : "없음" %></td>
					<td><%= (lists.get(i).getRequirement() != null && !lists.get(i).getRequirement().isEmpty()) ? lists.get(i).getRequirement() : "없음" %></td>
					<td><%= (lists.get(i).getChk() == 0) ? "미등록" : "등록" %></td>
					<td>
						<form action="/JSP_project/ImageUpdateServlet" method="post" name="frm_<%= i %>" enctype="multipart/form-data">
    						<input type="hidden" name="userId" value="<%= lists.get(i).getUserId() %>">
    						<input type="file" id="img" name="img" accept="image/*" required>
						    <input type="button" value="저장" onclick="send('<%= i %>')">
						</form>
					</td>
				</tr>
				<%
					}
				} else {
				%>
				<tr>
					<td colspan="8">신청된 식단이 없습니다.</td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>

		<div class="back-button">
			<input type="button" value="돌아가기" onclick="window.location.href='mealPlanRequest.jsp'">
		</div>
	</div>
<%@ include file="/chatbot/chatbot.jsp" %>    
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
