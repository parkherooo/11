<%@page import="user.UserMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body class="loginbody">
<%
    String myuserId = request.getParameter("myuserId");
    String pwd = request.getParameter("password");

    UserMgr userMgr = new UserMgr();
    boolean loggedIn = userMgr.loginUser(myuserId, pwd, session);

    if (loggedIn) {
        response.sendRedirect("../main/main.jsp");
    } else {
%>
        <script>
            alert('로그인 실패. 아이디와 비밀번호를 확인해주세요.');
            history.back(); // 이전 페이지로 
        </script>
<%
    }
%>
</body>
</html>