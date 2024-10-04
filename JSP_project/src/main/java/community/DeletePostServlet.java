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

@WebServlet("/community/DeletePostServlet")
public class DeletePostServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String cuNumStr = request.getParameter("cuNum");
        int cuNum = 0;

        if (cuNumStr != null && !cuNumStr.trim().isEmpty()) {
            try {
                cuNum = Integer.parseInt(cuNumStr); // cuNum 파싱
            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp"); // 잘못된 게시물 번호 처리
                return;
            }
        }

        if (cuNum != 0) {
            CommunityMgr mgr = new CommunityMgr();
            try {
                boolean isDeleted = mgr.deletePost(cuNum); // 삭제 성공 여부 확인

                if (isDeleted) {
                    System.out.println("게시물 삭제 성공: cuNum=" + cuNum);
                    response.sendRedirect("Community_Main.jsp"); // 삭제 후 리디렉션
                } else {
                    System.out.println("게시물 삭제 실패: cuNum=" + cuNum);
                    response.sendRedirect("error.jsp"); // 삭제 실패 처리
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp"); // 예외 처리
            }
        } else {
            System.out.println("유효하지 않은 게시물 번호입니다: " + cuNumStr);
            response.sendRedirect("error.jsp");
        }
    }
}

