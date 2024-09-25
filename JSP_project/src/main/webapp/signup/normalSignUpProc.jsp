<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserMgr, user.UserBean" %>

<%
    String userId = request.getParameter("userId");
    String name = request.getParameter("name");
    String pwd = request.getParameter("password");
    String birth = request.getParameter("birth");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String allergy = request.getParameter("allergy");
    float height = Float.parseFloat(request.getParameter("height"));
    float weight = Float.parseFloat(request.getParameter("weight"));
    int gender = Integer.parseInt(request.getParameter("gender"));
    
    UserBean user = new UserBean();
    user.setUserId(userId);
    user.setName(name);
    user.setPwd(pwd);
    user.setBirth(birth);
    user.setPhone(phone);
    user.setAddress(address);
    user.setAllergy(allergy);
    user.setHeight(height);
    user.setWeight(weight);
    user.setGender(gender);

    UserMgr mgr = new UserMgr();
    boolean result = mgr.insertUser(user);

    if (result) {
        out.println("<script>alert('회원가입이 완료되었습니다.'); location.href='../login/logIn.jsp';</script>");
    } else {
        out.println("<script>alert('회원가입에 실패했습니다.'); history.back();</script>");
    }
%>
