package recipe;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;

@WebServlet("/recipe/recipeCrawler")
public class RecipeCrawlerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Jsoup을 이용해 만개의레시피 웹사이트에서 레시피 데이터를 가져오기
        String recipeName = request.getParameter("recipeName");
        String url = "https://www.10000recipe.com/recipe/list.html?q=" + recipeName;
        Document doc = Jsoup.connect(url).get();
        
        // 원하는 데이터를 추출 (예: 레시피 이름과 링크)
        Elements recipes = doc.select(".common_sp_list_li");  // 레시피 목록이 포함된 요소 선택
        
        // 레시피 제목 및 링크 가져오기
        StringBuilder recipeList = new StringBuilder();
        recipes.forEach(recipe -> {
            String title = recipe.select(".common_sp_caption_tit.line2").text();  // 레시피 제목
            String link = recipe.select("a").attr("href");  // 레시피 링크
            recipeList.append("<a href='recipeDetail?link=").append(link).append("'>")
                      .append(title).append("</a><br>");
        });


        // JSP로 데이터를 전달
        request.setAttribute("recipeList", recipeList.toString());
        request.setAttribute("totalRecipes", recipes.size()); // 총 레시피 개수 전달
        request.getRequestDispatcher("/recipe/recipeList1.jsp").forward(request, response);
    }
}
