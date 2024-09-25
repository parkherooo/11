<%@page import="user.UserMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
    String userId = request.getParameter("userId");
    String pwd = request.getParameter("password");

    UserMgr userMgr = new UserMgr();
    boolean loggedIn = userMgr.loginUser(userId, pwd);

    if (loggedIn) {
        session.setAttribute("userId", userId);
        response.sendRedirect("main.jsp");
    } else {
        out.println("로그인 실패. 아이디와 비밀번호를 확인해주세요.");
    }
%>
</body>
</html>