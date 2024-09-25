<%@page import="java.net.URL"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.HttpURLConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카카오 로그인 처리</title>
</head>
<body>
<%
    // 카카오에서 받아온 access_token 처리
    String accessToken = request.getParameter("access_token");

    if (accessToken != null && !accessToken.isEmpty()) {
        // 카카오 API 요청 URL
        String apiUrl = "https://kapi.kakao.com/v2/user/me";
        
        // API 호출을 위한 HttpURLConnection 설정
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        
        // API 호출 결과 읽기
        int responseCode = conn.getResponseCode();
        if (responseCode == 200) { // 성공적으로 API 응답 받음
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String inputLine;
            StringBuffer responseBuffer = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                responseBuffer.append(inputLine);
            }
            in.close();
            
            // 카카오에서 받은 사용자 정보 출력 (JSON 형식)
            out.println("<h2>카카오 사용자 정보</h2>");
            out.println("<pre>" + responseBuffer.toString() + "</pre>");

            // 여기서 필요한 사용자 정보 추출 및 처리 가능
            // JSON 라이브러리를 사용해 파싱한 후 원하는 데이터를 처리할 수 있습니다.
            // 예시:
            // JSONObject jsonResponse = new JSONObject(responseBuffer.toString());
            // String userId = jsonResponse.getJSONObject("id").toString();
            // String nickname = jsonResponse.getJSONObject("properties").getString("nickname");
            
            // 세션 설정 등
            // session.setAttribute("userId", userId);
        } else {
            out.println("카카오 API 호출 실패: " + responseCode);
        }
    } else {
        out.println("Access Token이 없습니다.");
    }
%>
</body>
</html>
