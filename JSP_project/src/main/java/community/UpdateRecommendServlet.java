package community;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;


@WebServlet("/community/UpdateRecommendServlet")
public class UpdateRecommendServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CommunityMgr mgr = new CommunityMgr();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cuNumStr = request.getParameter("cuNum");
        
        if (cuNumStr != null) {
            try {
                int cuNum = Integer.parseInt(cuNumStr);
                mgr.increaseRecommend(cuNum);

                response.sendRedirect("Community_Main.jsp");  
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}
