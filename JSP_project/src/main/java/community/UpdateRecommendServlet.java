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
        String redirectPage = request.getParameter("redirectPage");

        // 디버깅 로그
        System.out.println("cuNumStr: " + cuNumStr);
        System.out.println("redirectPage: " + redirectPage);

        if (cuNumStr != null && !cuNumStr.trim().isEmpty()) {
            try {
                int cuNum = Integer.parseInt(cuNumStr);
                System.out.println("Processing increaseRecommend for cuNum: " + cuNum);
                
                // 좋아요 수 증가
                mgr.increaseRecommend(cuNum);

                // 리다이렉트할 페이지가 postDetail.jsp이면 cuNum을 URL 파라미터로 전달
                if (redirectPage != null && redirectPage.equals("postDetail.jsp")) {
                    response.sendRedirect(redirectPage + "?cuNum=" + cuNum);
                } else if (redirectPage != null && !redirectPage.isEmpty()) {
                    response.sendRedirect(redirectPage);  // 다른 페이지로 리다이렉트 (cuNum 없이)
                } else {
                    response.sendRedirect("Community_Main.jsp");  // 기본 페이지
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            // cuNum이 전달되지 않았을 때 잘못된 접근 메시지 출력
            response.getWriter().write("잘못된 접근입니다.");
        }
    }
}

