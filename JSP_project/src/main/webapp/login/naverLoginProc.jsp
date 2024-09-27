<%@page import="java.io.InputStreamReader"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.net.URL"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>네이버 로그인 처리</title>
</head>
<body class="loginbody">
<%
    // 네이버에서 전달된 access_token 받기
    String accessToken = request.getParameter("access_token");

    if (accessToken != null && !accessToken.isEmpty()) {
        // 사용자 정보 요청 URL
        String apiURL = "https://openapi.naver.com/v1/nid/me";

        // 네이버 API에 요청 보내기
        URL url = new URL(apiURL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) { // 성공적으로 사용자 정보를 받은 경우
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuffer responseBuffer = new StringBuffer();
            
            while ((inputLine = br.readLine()) != null) {
                responseBuffer.append(inputLine);
            }
            br.close();

            // 응답 데이터 JSON 파싱
            JSONObject jsonResponse = new JSONObject(responseBuffer.toString());
            String email = jsonResponse.getJSONObject("response").getString("email");
            String name = jsonResponse.getJSONObject("response").getString("name");

            // 출력 또는 세션 저장
            out.println("사용자 이메일: " + email);
            out.println("사용자 이름: " + name);

            // 세션 설정 등
            // session.setAttribute("userEmail", email);
            // session.setAttribute("userName", name);
        } else {
            out.println("네이버 로그인 실패: " + responseCode);
        }
    } else {
        out.println("Access Token이 없습니다.");
    }
%>
</body>
</html>
