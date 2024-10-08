<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>크롤링된 레시피 목록</title>
</head>
<body>
    <h1>만개의레시피에서 가져온 레시피</h1>
    <form action="recipeCrawler" method="get">
        <input type="text" placeholder="레시피명을 입력하세요" name="recipeName" required value="<%= request.getParameter("recipeName") != null ? request.getParameter("recipeName") : "" %>">
        <button type="submit">검색</button>
    </form>
    <div>
        <% 
        // recipeList는 HTML 문자열로 가정
        String recipeList = (String) request.getAttribute("recipeList");
        
        // totalRecipes가 null일 경우 기본값을 0으로 설정
        Integer totalRecipesObj = (Integer) request.getAttribute("totalRecipes");
        int totalRecipes = (totalRecipesObj != null) ? totalRecipesObj : 0; // 총 레시피 개수
        
        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1; // 현재 페이지
        int itemsPerPage = 10; // 페이지당 아이템 수
        int totalPages = (int) Math.ceil((double) totalRecipes / itemsPerPage); // 총 페이지 수
        int startIndex = (currentPage - 1) * itemsPerPage; // 시작 인덱스
        int endIndex = Math.min(startIndex + itemsPerPage, totalRecipes); // 종료 인덱스

        // 페이지 범위에 맞춰 레시피 출력
        if (recipeList != null && !recipeList.isEmpty()) {
            String[] recipesArray = recipeList.split("<br>"); // 줄바꿈으로 레시피를 나누기
            
            // 현재 페이지에 맞는 레시피만 출력
            for (int i = startIndex; i < endIndex; i++) {
        %>
                <%= recipesArray[i] %> <br> <!-- 레시피 출력 -->
        <% 
            } // for문 종료
        } else {
            // 레시피 목록이 비어 있을 때 메시지 출력
            out.println("검색된 레시피가 없습니다.");
        }
        %>
    </div>

    <div>
        <nav>
            <ul style="list-style-type:none;">
                <% if (currentPage > 1) { %>
                    <li><a href="?recipeName=<%= request.getParameter("recipeName") %>&page=<%= currentPage - 1 %>">이전</a></li>
                <% } %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <li>
                        <a href="?recipeName=<%= request.getParameter("recipeName") %>&page=<%= i %>" <%= (i == currentPage) ? "style='font-weight:bold;'" : "" %> >
                            <%= i %>
                        </a>
                    </li>
                <% } %>
                <% if (currentPage < totalPages) { %>
                    <li><a href="?recipeName=<%= request.getParameter("recipeName") %>&page=<%= currentPage + 1 %>">다음</a></li>
                <% } %>
            </ul>
        </nav>
    </div>
</body>
</html>
