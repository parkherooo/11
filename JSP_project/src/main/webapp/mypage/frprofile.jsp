<%@page import="mypage.freindBean"%>
<%@page import="java.util.Vector"%>
<%@page import="recipe.UserAllergyMgr"%>
<%@page import="user.UserMgr"%>
<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    UserBean bean = new UserBean();
    UserMgr mgr = new UserMgr();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>myPage</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../css/mypage.css">
    <%@ include file="/main/header.jsp" %>
</head>
<%	
	userId = request.getParameter("id");
	//카테고리 분류
    String category = request.getParameter("category");
	//내정보 가져오기
    bean = mgr.myInfo(userId);
    
	//알러지 정보 가져오기
    UserAllergyMgr allergyMgr = new UserAllergyMgr();
	String[] userAllergies = {"없음"};
	

	//비로그인시 메인으로 이동
    if(userId==null||userId.equals("")){
%>
<script>
       alert("로그인이 필요합니다. 메인 페이지로 이동합니다.");
       window.location.href = "../main/main.jsp"; 
</script>
<%} %>
<body>
<div class="mypage-body">
    <div class="myprofile">
        <table class="profile-table">
            <tr>
                <% if(bean.getProfile() == null || bean.getProfile().equals("")) { %>
			    <th>
			        <img class="profile" alt="빈프로필" src="../img/profile/null_Profile.png?t=<%= System.currentTimeMillis() %>">
			    </th>
				<% } else { %>
				    <th>
				        <img class="profile" alt="프로필" src="../img/profile/<%= bean.getProfile() %>?t=<%= System.currentTimeMillis() %>">
				    </th>
				<% } %>

            </tr>
            <tr>
                <th><h3><%=bean.getName() %>님</h3></th>
            </tr>
            <tr style="margin-bottom: 50px;">
                <%if(bean.getMsg()==null) {%>
                <th>소개글이 없습니다.</th>
                <%} else { %>
                <th><%=bean.getMsg().replace("\n", "<br>") %></th>
                <%} %>
            </tr>
        </table>
    </div>
    
    <div class="mypage-div">
        <div class="mypage-ca">
            <a class="mypage-a <%= (category == null || category.equals("프로필관리")) ? "active" : "" %>" href="frprofile.jsp?id=<%=userId %>&category=프로필관리">프로필</a>
            <a class="mypage-a <%= (category != null && category.equals("알러지관리")) ? "active" : "" %>" href="frprofile.jsp?id=<%=userId %>&category=알러지관리">알러지</a>
        </div>
        
        <div class="mypage-info">
            <% if(category == null || category.equals("프로필관리")) { %>
                <h2>프로필 정보</h2>    
                <form>
                    <table>
                        <tr>
                            <td>이름:</td>
                            <td><input type="text" name="name" value="<%=bean.getName() %>" required></td>
                        </tr>
                        <tr>
                            <td>전화번호:</td>
                            <td><input type="text" name="phone" value="<%=bean.getPhone() %>" required></td>
                        </tr>
                        <tr>
                            <td>주소:</td>
                            <td><input type="text" name="address" value="<%=bean.getAddress() %>" required></td>
                        </tr>
                        <tr>
                            <td>생년월일:</td>
                            <td><input type="text" name="birth" value="<%=bean.getBirth() %>" required></td>
                        </tr>
                    </table>
                </form>
            <% } else if (category.equals("알러지관리")) { %>
           <div class="allergy">
		    <h2>알러지 정보</h2><br>
				<form id="allergyForm" class="allergyForm">
				    
				    <div>
				        <br><h3>기존 알러지</h3><br>
				        <div>
				            <% 
				            if(allergyMgr.selectAllergy(userId)!=null){
				            	 userAllergies=allergyMgr.selectAllergy(userId); 
				            }
				            for (int i = 0; i < userAllergies.length; i++) { %>
				                <input type="button" value="<%= userAllergies[i] %>" class="existing-allergy-btn" onclick="toggleAllergy(this.value)">
				            <% } %>
				        </div>

				    </div>
				</form>
		</div>

            <% } %>
           		
        </div>
    </div>
</div>

<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
