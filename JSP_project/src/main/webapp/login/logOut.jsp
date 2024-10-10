<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션 무효화
    session.invalidate();

    // 로그아웃 후 메인 페이지로 이동
    response.sendRedirect("../main/main.jsp");
%>