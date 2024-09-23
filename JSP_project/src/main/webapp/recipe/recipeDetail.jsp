<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, org.json.JSONObject" %>

<%	
    String title = request.getParameter("title");
    String recipeId = request.getParameter("id");
    String apiUrl = "https://openapi.foodsafetykorea.go.kr/api/12cb932ee6ff42828803/COOKRCP01/json/1/100/RCP_SEQ=" + recipeId + "&RCP_NM=" +java.net.URLEncoder.encode(title, "UTF-8");
    StringBuilder result = new StringBuilder();

    try {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line;
        while ((line = rd.readLine()) != null) {
            result.append(line);
        }
        rd.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // JSON 데이터 파싱
    JSONObject recipeDetail = null;
    try {
        JSONObject jsonResponse = new JSONObject(result.toString());
        recipeDetail = jsonResponse.getJSONObject("COOKRCP01").getJSONArray("row").getJSONObject(0);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= recipeDetail != null ? recipeDetail.getString("RCP_NM") : "레시피 상세" %></title>
</head>
<body>
    <h1><%= recipeDetail != null ? recipeDetail.getString("RCP_NM") : "레시피를 찾을 수 없습니다." %></h1>
    <h3>조리방법</h3>
    <ul>
        <% 
        for (int i = 1; i <= 20; i++) {
            String manualKey = "MANUAL0" + i;
            if (recipeDetail != null && recipeDetail.has(manualKey) && !recipeDetail.getString(manualKey).isEmpty()) {
        %>
                <li><%= recipeDetail.getString(manualKey) %></li>
        <% 
            }
        } 
        %>
        <li>재료: <%= recipeDetail != null ? recipeDetail.getString("RCP_PARTS_DTLS") : "" %></li>
        <li>탄수화물: <%= recipeDetail != null ? recipeDetail.getString("INFO_CAR") : "" %></li>
        <li>단백질: <%= recipeDetail != null ? recipeDetail.getString("INFO_PRO") : "" %></li>
        <li>지방: <%= recipeDetail != null ? recipeDetail.getString("INFO_FAT") : "" %></li>
        <li>나트륨: <%= recipeDetail != null ? recipeDetail.getString("INFO_NA") : "" %></li>
        <li>열량: <%= recipeDetail != null ? recipeDetail.getString("INFO_ENG") : "" %></li>
    </ul>
    <a href="recipeList.jsp">목록으로</a>
</body>
</html>
