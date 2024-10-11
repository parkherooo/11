package community;

import java.io.IOException;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/community/PostManagementServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class PostManagementServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // action 파라미터로 수정 또는 삭제 결정
        String action = request.getParameter("action");
        String cuNumStr = request.getParameter("cuNum");
        int cuNum = 0;

        if (cuNumStr != null && !cuNumStr.trim().isEmpty()) {
            cuNum = Integer.parseInt(cuNumStr);
        }

        if (cuNum == 0) {
            response.sendRedirect("error.jsp");
            return;
        }

        CommunityMgr mgr = new CommunityMgr();

        if ("modify".equals(action)) {
            // 수정 처리 로직
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            Part filePart = request.getPart("cuImg");

            String cuImg = request.getParameter("existingCuImg"); // 기존 이미지 파일 이름
            if (filePart != null && filePart.getSize() > 0) {
                // 파일 업로드 처리 로직
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                // 경로를 제외하고 파일 이름만 저장
                cuImg = fileName;  // 파일 이름만 저장

                // 파일을 실제 경로에 저장 (경로는 하드코딩 또는 설정 파일로 관리)
                String uploadPath = request.getServletContext().getRealPath("/") + "community/upload/";
                filePart.write(uploadPath + fileName);  // 파일을 지정된 경로에 저장
            }

            CommunityBean post = new CommunityBean();
            post.setCuNum(cuNum);
            post.setTitle(title);
            post.setContent(content);
            post.setCuImg(cuImg);

            try {
            	mgr.updatePost(post.getCuNum(), post.getTitle(), post.getContent(), post.getCuImg());
            	response.sendRedirect("Community_Main.jsp");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }

        } else if ("delete".equals(action)) {
            // 삭제 처리 로직
            try {
                boolean success = mgr.deletePost(cuNum);
                if (success) {
                    response.sendRedirect("Community_Main.jsp");
                } else {
                    response.sendRedirect("error.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("error.jsp");
            }
        }
    }
}

