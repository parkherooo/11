<%@page import="user.UserMgr"%>
<%@page import="user.UserBean"%>
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
    // 폼에서 받은 회원 정보
    String userId = request.getParameter("userId");
    String name = request.getParameter("name");
    String pwd = request.getParameter("password");
    String birth = request.getParameter("birthDate");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String allergy = request.getParameter("allergies");
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

    UserMgr userMgr = new UserMgr();
    boolean success = userMgr.insertUser(user);

    if (success) {
        response.sendRedirect("signupSuccess.jsp");
    } else {
        out.println("회원가입 실패. 다시 시도해주세요.");
    }
%>
</body>
</html>