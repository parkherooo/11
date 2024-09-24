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
    <style>
        body {
            text-align: center; /* 전체 내용 가운데 정렬 */
        }
        .recipe-detail {
            text-align: left; /* 레시피 상세 정보 왼쪽 정렬 */
            margin-left: 20%; /* 왼쪽 마진 20% */
            margin-right: 20%; /* 오른쪽 마진 20% */
        }
        .recipe-detail div {
            margin-bottom: 10px; /* 각 div 요소에 여백 추가 */
        }
        .recipe-image {
            display: block;
            margin-left:10%;
            width: 400px; /* 이미지 폭 설정 */
            height: auto; /* 자동 높이 조정 */
        }
        .ingredients {
            display: flex; /* 플렉스박스 사용 */
            margin-bottom: 20px; /* 성분 정보 아래 여백 추가 */
        }
        .ingredients div {
            margin-left: 200px; /* 성분과 이미지 사이의 여백 */
        }
        a {	
            margin-top: 30px;
            text-decoration: none; /* 밑줄 제거 */
            padding: 10px 20px; /* 여백 추가 */
            color: black; /* 글자 색상 검정색 */
        }
    </style>
</head>
<body>
    <h1>Recipe</h1>
    
    <div class="recipe-detail">
        <h2><%= recipeDetail != null ? recipeDetail.getString("RCP_NM") : "레시피를 찾을 수 없습니다." %></h2>	<br>
        <div class="ingredients">
            <img class="recipe-image" src="<%= recipeDetail != null ? recipeDetail.getString("ATT_FILE_NO_MK") : "" %>" alt="조리 이미지" />
            <div>
                <h3>성분</h3>
                탄수화물: <%= recipeDetail != null ? recipeDetail.getString("INFO_CAR") : "" %>g<br>
                단백질: <%= recipeDetail != null ? recipeDetail.getString("INFO_PRO") : "" %>g<br>
                지방: <%= recipeDetail != null ? recipeDetail.getString("INFO_FAT") : "" %>g<br>
                나트륨: <%= recipeDetail != null ? recipeDetail.getString("INFO_NA") : "" %>g<br>
                열량: <%= recipeDetail != null ? recipeDetail.getString("INFO_ENG") : "" %>cal<br>
            </div>
        </div>
		
        <h3>조리방법</h3>
        <% 
        for (int i = 1; i <= 20; i++) {
            String manualKey = "MANUAL0" + i;
            if (recipeDetail != null && recipeDetail.has(manualKey) && !recipeDetail.getString(manualKey).isEmpty()) {
        %>
                <div><%= recipeDetail.getString(manualKey) %></div>
        <% 
            }
        } 
        %>
        
        <div><b>재료:</b> <%= recipeDetail != null ? recipeDetail.getString("RCP_PARTS_DTLS") : "" %></div>
        
        <h3>저감 조리법 Tip</h3>
        <div><%= recipeDetail != null ? recipeDetail.getString("RCP_NA_TIP") : "" %></div>
        
    </div>
    <br><a href="recipeList.jsp">[목록]</a>
    <%@ include file="/chatbot/chatbot.jsp" %>
</body>
</html>
