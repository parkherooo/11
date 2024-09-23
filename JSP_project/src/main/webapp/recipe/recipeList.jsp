<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, org.json.JSONArray, org.json.JSONObject" %>

<%
    String searchQuery = request.getParameter("search");
    String pageParam = request.getParameter("page");
    int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
    int start = (currentPage - 1) * 15 + 1;
    int end = currentPage * 15;

    String apiUrl = "https://openapi.foodsafetykorea.go.kr/api/12cb932ee6ff42828803/COOKRCP01/json/" + start + "/" + end;

    if (searchQuery != null && !searchQuery.isEmpty()) {
        apiUrl += "/RCP_NM=" + java.net.URLEncoder.encode(searchQuery, "UTF-8");
    }

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

    JSONArray recipes = null;
    try {
        JSONObject jsonResponse = new JSONObject(result.toString());
        recipes = jsonResponse.getJSONObject("COOKRCP01").getJSONArray("row");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>레시피 목록</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            text-align: center; /* 전체 내용 가운데 정렬 */
            color: black; /* 기본 글자 색상 검정색 */
        }
        h2 {
        margin-left: 10%; /* h3 태그 왼쪽 마진 70% */
        text-align: left; /* 왼쪽 정렬 */
   		}
        form {
            border: none; /* 테두리 없음 */
            margin-left: 20%; /* 검색 폼 왼쪽 마진 70% */
        	text-align: left; /* 검색 폼 내의 텍스트 왼쪽 정렬 */
        }
        input[type="text"] {
            padding: 10px;
            font-size: 16px;
            border: none;
        }
        button {
            border: none;
            background: none;
            cursor: pointer;
            font-size: 20px; /* 아이콘 크기 증가 */
        }
        hr {
            border: none; /* 기본 테두리 없애기 */
            height: 1px;
            width: 70%; /* 줄의 길이 */
            background-color: gray; /* 회색 줄 */
            margin: 20px auto; /* 여백 추가 및 가운데 정렬 */
        }
        .recipe-list {
            text-align: left; /* 왼쪽 정렬 */
            margin-left: 20%; /* 왼쪽 간격 설정 */
            margin-right: 20%;
        }
        .recipe-item {
            text-decoration: none; /* 밑줄 제거 */
            display: block; /* 각 레시피를 블록으로 표시 */
            padding: 10px;
            margin: 5px 0;
            color: black; /* 글자 색상 검정색 */
            background-color: #f9f9f9; /* 배경색 추가 */
        }
        .recipe-item:hover {
            background-color: #f1f1f1; /* 마우스 오버 시 색상 변경 */
        }
        .pagination {
            display: inline-block; /* 버튼을 같은 줄에 배치 */
            margin: 20px 0; /* 여백 추가 */
        }
        .pagination a {
            text-decoration: none; /* 밑줄 제거 */
            padding: 10px 20px; /* 여백 추가 */
            color: black; /* 글자 색상 검정색 */
        }
    </style>
</head>
<body>
    <h2>레시피 목록</h2>

    <form method="GET" action="recipeList.jsp">
        <input type="text" name="search" placeholder="레시피명을 입력하세요" value="<%= searchQuery != null ? searchQuery : "" %>" required>
        <button type="submit">
            <i class="fas fa-search"></i>
        </button>
    </form>
    
    <hr>

    <div class="recipe-list"> <!-- 레시피 리스트를 감싸는 div 추가 -->
        <%
            if (recipes != null) {
                for (int i = 0; i < recipes.length(); i++) {
                    JSONObject recipe = recipes.getJSONObject(i);
                    String title = recipe.getString("RCP_NM");
                    String id = recipe.getString("RCP_SEQ");
        %>
                <a href="recipeDetail.jsp?id=<%= id %>&title=<%= title %>" class="recipe-item"><%= title %></a>
        <%
                }
            } else {
        %>
                <div>레시피가 더이상 없습니다.</div>
        <%
            }
        %>
    </div>

    <div class="pagination"> <!-- 페이지 버튼을 감싸는 div 추가 -->
    <%
        int totalRecipes = 1124; // 전체 레시피 수 (API에서 가져온 정보로 변경 가능)
        int totalPages = (int) Math.ceil((double) totalRecipes / 15); // 총 페이지 수

        if (currentPage > 1) { // 이전 페이지가 있는 경우
    %>
        <a href="recipeList.jsp?page=<%= currentPage - 5 %>&search=<%= searchQuery != null ? java.net.URLEncoder.encode(searchQuery, "UTF-8") : "" %>">이전</a>
    <%
        }

        // 페이지 번호 출력
        int startPage = Math.max(1, currentPage - 2); // 현재 페이지 기준으로 이전 2개 페이지
        int endPage = Math.min(totalPages, startPage + 4); // 현재 페이지 기준으로 다음 4개 페이지

        for (int i = startPage; i <= endPage; i++) {
            String linkStyle = (i == currentPage) ? "font-weight: bold;" : "";
    %>
        <a href="recipeList.jsp?page=<%= i %>&search=<%= searchQuery != null ? java.net.URLEncoder.encode(searchQuery, "UTF-8") : "" %>" 
           style="<%= linkStyle %>"><%= i %></a>
    <%
        }

        if (currentPage < totalPages) { // 다음 페이지가 있는 경우
    %>
        <a href="recipeList.jsp?page=<%= currentPage + 5 %>&search=<%= searchQuery != null ? java.net.URLEncoder.encode(searchQuery, "UTF-8") : "" %>">다음</a>
    <%
        }
    %>
</div>

    <a href="recipeList.jsp" class="recipe-item">목록으로</a>
</body>
</html>
