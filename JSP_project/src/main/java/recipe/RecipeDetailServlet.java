package recipe;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

@WebServlet("/recipe/recipeDetail")
public class RecipeDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String recipeLink = request.getParameter("link");
        Document doc = Jsoup.connect("https://www.10000recipe.com" + recipeLink).get();

        // 제목 추출
        String title = doc.select("div.view2_summary.st3 h3").text();

        // 재료 추출
        String ingredients = doc.select(".ready_ingre3").text(); // 재료

        // "구매"라는 단어 제거
        if (ingredients.endsWith("구매")) {
            ingredients = ingredients.substring(0, ingredients.length() - 2).trim(); // 마지막 "구매" 제거
        }
        ingredients = ingredients.replace("구매", ",").trim(); // 중간 "구매" 제거

        // 조리 방법 추출
        Elements steps = doc.select(".view_step_cont");
        StringBuilder instructions = new StringBuilder();
        for (Element step : steps) {
            String description = step.select(".media-body").text(); // 조리 방법 설명
            String imgSrc = step.select("img").attr("src"); // 이미지 URL
            
            instructions.append("<div class='step'>");
            instructions.append("<p>").append(description).append("</p>");
            if (!imgSrc.isEmpty()) {
                instructions.append("<img src='").append(imgSrc).append("' alt='조리 방법 이미지'/>");
            }
            instructions.append("</div>");
        }

        // JSP로 데이터를 전달
        request.setAttribute("title", title);
        request.setAttribute("ingredients", ingredients);
        request.setAttribute("instructions", instructions.toString());
        request.getRequestDispatcher("/recipe/recipeDetail1.jsp").forward(request, response);
    }
}
