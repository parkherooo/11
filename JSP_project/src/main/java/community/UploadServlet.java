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


@WebServlet("/community/community/uploadServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "C:/jsp project/JSP_project/JSP_project/src/main/webapp/community/upload/";  // 파일이 저장될 폴더의 절대 경로

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        System.out.println("Upload file path: " + UPLOAD_DIR);

        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String fileName = null;
        Part filePart = request.getPart("cuImg"); 
        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            filePart.write(UPLOAD_DIR + File.separator + fileName); 
        }

        String userId = request.getParameter("userId");;  // 실제 로그인된 사용자의 ID로 변경 필요
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        if (title == null || title.trim().isEmpty()) {
            title = "제목 없음";
        }

        int recommend = 0;  

        CommunityBean bean = new CommunityBean();
        bean.setUserId(userId);
        bean.setTitle(title);
        bean.setContent(content);
        bean.setCuImg(fileName);
        bean.setCuDate(new java.util.Date());
        bean.setRecommend(recommend);

        CommunityMgr mgr = new CommunityMgr();
        boolean success = false;
        try {
            success = mgr.insertPost(bean);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 결과에 따른 응답 처리
        if (success) {
            // 성공 시 원래 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/community/Community_Main.jsp?message=success");
        } else {
            // 실패 시 원래 페이지로 리다이렉트, 에러 메시지 포함
            response.sendRedirect(request.getContextPath() + "/community/Community_Main.jsp?message=fail");
        }
    }
}
