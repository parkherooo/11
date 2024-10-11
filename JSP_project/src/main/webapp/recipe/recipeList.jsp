<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, org.json.JSONArray, org.json.JSONObject" %>
<%@ page import="recipe.UserAllergyMgr" %>
<%@ include file="/main/header.jsp" %>
<%   

   UserAllergyMgr allergyMgr = new UserAllergyMgr();
   String[] userAllergies = allergyMgr.selectAllergy(userId); // 사용자 알러지 목록 가져오기
   
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
    
    // 필터링된 레시피 목록
    JSONArray filteredRecipes = new JSONArray();
    if (recipes != null) {
        for (int i = 0; i < recipes.length(); i++) {
            JSONObject recipe = recipes.getJSONObject(i);
            String food = recipe.getString("RCP_NA_TIP");
            boolean containsAllergy = false;

            // 사용자 알러지 목록과 비교
            if (userAllergies != null) {
                for (String allergy : userAllergies) {
                    if (food.contains(allergy)) {
                        containsAllergy = true;
                        break; // 하나의 알러지가 포함되면 더 이상 확인할 필요 없음
                    }
                }
            }

            // 제외할 알러지가 포함되어 있지 않은 경우 추가
            if (!containsAllergy) {
                filteredRecipes.put(recipe);
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>   
    <title>레시피 목록</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../css/recipe.css">
</head>
<body class="recipe-body">
    <div class="recipe-list"> <!-- 레시피 리스트를 감싸는 div 추가 -->
       <h1 class="recipe-h1">Recipe</h1>
       <h3 class="recipe-h3">레시피 목록</h3>
       
       <form method="GET" action="recipeList.jsp">
        <input type="text" name="search" placeholder="레시피명을 입력하세요" value="<%= searchQuery != null ? searchQuery : "" %>" required>
        <button type="submit" class="search">
            <i class="fas fa-search"></i>
        </button>
       </form>
       <hr>
    
        <%
            if (filteredRecipes != null && filteredRecipes.length() > 0) {
                for (int i = 0; i < filteredRecipes.length(); i++) {
                    JSONObject recipe = filteredRecipes.getJSONObject(i);
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

        // 이전 페이지 계산 (최소 1 페이지)
        int prevPage = Math.max(1, currentPage - 5);

        if (currentPage > 1) { // 이전 페이지가 있는 경우
    %>
        <a href="recipeList.jsp?page=<%= prevPage %>&search=<%= searchQuery != null ? java.net.URLEncoder.encode(searchQuery, "UTF-8") : "" %>">이전</a>
    <%
        }

        // 페이지 번호 출력
        int startPage = Math.max(1, currentPage - 2); // 현재 페이지 기준으로 이전 2개 페이지
        int endPage = Math.min(totalPages, startPage + 4); // 현재 페이지 기준으로 다음 4개 페이지

        for (int i = startPage; i <= endPage; i++) {
            String linkStyle = (i == currentPage) ? "text-decoration: underline;" : "";

    %>
        <a href="recipeList.jsp?page=<%= i %>&search=<%= searchQuery != null ? java.net.URLEncoder.encode(searchQuery, "UTF-8") : "" %>" 
           style="<%= linkStyle %>"><%= i %></a>
    <%
        }

        // 다음 페이지 계산 (최대 totalPages)
        int nextPage = Math.min(totalPages, currentPage + 5);

        if (currentPage < totalPages) { // 다음 페이지가 있는 경우
    %>
        <a href="recipeList.jsp?page=<%= nextPage %>&search=<%= searchQuery != null ? java.net.URLEncoder.encode(searchQuery, "UTF-8") : "" %>">다음</a>
    <%
        }
    %>
   </div>
    <a href="recipeList.jsp" class="recipe-item">[목록]</a>
     <%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
