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
    <link rel="stylesheet" href="../css/mypage.css">
    <%@ include file="/main/header.jsp" %>
</head>
<%
    String category = request.getParameter("category");
    bean = mgr.myInfo(userId);
%>
<body>
<div class="mypage-body">
    <div class="myprofile">
        <table class="profile-table">
            <tr>
                <%if(bean.getProfile()==null) {%>
                <th><img class="profile" alt="빈프로필" src="../img/profile/null_Profile.png"></th>
                <%} else {%>
                <th><img class="profile" alt="프로필" src="../img/profile/<%=bean.getProfile()%>"></th>
                <%} %>
            </tr>
            <tr>
                <th><h3><%=bean.getName() %>님</h3></th>
            </tr>
            <tr style="margin-bottom: 50px;">
                <%if(bean.getMsg()==null) {%>
                <th>소개글이 없습니다.</th>
                <%} else { %>
                <th><%=bean.getMsg() %></th>
                <%} %>
            </tr>
        </table>
    </div>
    
    <div class="mypage-div">
        <div class="mypage-ca">
            <a class="mypage-a <%= (category == null || category.equals("프로필관리")) ? "active" : "" %>" href="myPage.jsp?category=프로필관리">프로필 관리</a>
            <a class="mypage-a <%= (category != null && category.equals("알러지관리")) ? "active" : "" %>" href="myPage.jsp?category=알러지관리">알러지 관리</a>
            <a class="mypage-a <%= (category != null && category.equals("커뮤니티관리")) ? "active" : "" %>" href="myPage.jsp?category=커뮤니티관리">커뮤니티 관리</a>
            <a class="mypage-a <%= (category != null && category.equals("친구관리")) ? "active" : "" %>" href="myPage.jsp?category=친구관리">친구 관리</a>
        </div>
        
        <div class="mypage-info">
            <% if(category == null || category.equals("프로필관리")) { %>
                <h2>회원 정보 수정</h2>
                <form action="updateUserInfo.jsp" method="post">
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
                        <tr>
                            <td colspan="2" style="text-align: right;">
                                <input type="submit" value="수정" class="submit-button">
                                <input type="submit" value="회원탈퇴" class="submit-button" style="background-color: RED">
                            </td>
                        </tr>
                    </table>
                </form>
            <% } else if (category.equals("알러지관리")) { %>
            <div class="allergy">
         	    <h3>먹을 수 없는 음식을 선택하세요.</h3>
         	    <div>
         	    	<input type="button" value="견과류" class="allergy-btn">
         	    	<input type="button" value="유제품" class="allergy-btn">
         	    	<input type="button" value="계란" class="allergy-btn">
         	    	<input type="button" value="생선" class="allergy-btn">
         	    	<input type="button" value="갑각류" class="allergy-btn">
         	    </div>
         	    <div class="input-row">
         	    	<input type="text" value="음식 직접입력" class="allergy-input">
         	    	<input type="submit" value="추가" class="allergy-plus">
         	    </div>
            </div>
               

            <% } else if (category.equals("커뮤니티관리")) { %>
                <h2>커뮤니티 관리</h2>
                <!-- 커뮤니티 관리에 대한 내용 추가 -->
                <p>여기에서 커뮤니티 관리 기능을 구현하세요.</p>
            <% } else if (category.equals("친구관리")) { %>
                <h2>친구 관리</h2>
                <!-- 친구 관리에 대한 내용 추가 -->
                <p>여기에서 친구 관리 기능을 구현하세요.</p>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
