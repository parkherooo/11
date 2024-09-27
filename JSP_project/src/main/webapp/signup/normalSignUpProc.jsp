<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<%@ page import="user.UserMgr, user.UserBean" %>

<%
	request.setCharacterEncoding("UTF-8");

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

    UserMgr mgr = new UserMgr();

    // 전화번호 중복 확인
    boolean isPhoneDuplicate = mgr.phoneChk(phone);

    if (isPhoneDuplicate) {
        // 전화번호가 중복될 경우, 이미 존재하는 아이디라고 경고
        out.println("<script>alert('해당 전화번호로 이미 가입된 아이디가 존재합니다.'); history.back();</script>");
        return; // 더 이상 처리하지 않고 종료
    }

    // 회원가입 처리
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

    boolean result = mgr.insertUser(user);

    if (result) {
        out.println("<script>alert('회원가입이 완료되었습니다.'); location.href='../login/logIn.jsp';</script>");
    } else {
        out.println("<script>alert('회원가입에 실패했습니다.'); history.back();</script>");
    }
%>
