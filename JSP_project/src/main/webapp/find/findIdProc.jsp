<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, user.UserMgr"%>
<%
	request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("name").trim();
    String phone = request.getParameter("phone").trim();
    String foundId = null;

    UserMgr userMgr = new UserMgr();
    foundId = userMgr.findUserId(name, phone);

    // 아이디가 찾아졌을 경우 결과 페이지로 전달
    if (foundId != null) {
        request.setAttribute("foundId", foundId);
    } else {
        request.setAttribute("foundId", "");
    }

    // 현재 페이지로 포워드하여 결과 표시
    RequestDispatcher dispatcher = request.getRequestDispatcher("findId.jsp");
    dispatcher.forward(request, response);
%>
