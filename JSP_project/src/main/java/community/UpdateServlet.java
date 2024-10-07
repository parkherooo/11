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

@WebServlet("/community/updateServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UpdateServlet extends HttpServlet {

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

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        int cuNum = Integer.parseInt(request.getParameter("cuNum")); 

        if (title == null || title.trim().isEmpty()) {
            title = "제목 없음";
        }

        CommunityBean bean = new CommunityBean();
        bean.setCuNum(cuNum);  
        bean.setTitle(title);
        bean.setContent(content);
        bean.setCuImg(fileName);  

        CommunityMgr mgr = new CommunityMgr();
        boolean success = false;
        try {
            success = mgr.updatePost(cuNum, title, content, fileName);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 결과에 따른 응답 처리
        if (success) {
            request.setAttribute("message", "게시물이 성공적으로 수정되었습니다.");
            request.getRequestDispatcher("/Community_Main.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "게시물 수정에 실패했습니다.");
            request.getRequestDispatcher("/Community_Main.jsp").forward(request, response);
        }
    }
}
