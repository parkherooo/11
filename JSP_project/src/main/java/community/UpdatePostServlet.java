package community;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/community/UpdatePostServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
                 maxFileSize = 1024 * 1024 * 10,       // 10MB
                 maxRequestSize = 1024 * 1024 * 50)    // 50MB
public class UpdatePostServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 폼 데이터에서 게시물 정보를 가져옴
        String cuNumStr = request.getParameter("cuNum");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // 게시물 번호 파싱
        int cuNum = 0;
        if (cuNumStr != null && !cuNumStr.trim().isEmpty()) {
            cuNum = Integer.parseInt(cuNumStr);
        }

        // 이미지 파일 처리 (파일 이름만 가져옴)
        String cuImg = null;
        Part filePart = request.getPart("cuImg");  // 업로드된 파일 파트 가져오기
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = extractFileName(filePart);  // 파일 이름 추출
            cuImg = fileName;  // 데이터베이스에 저장할 파일 이름만 할당
        } else {
            // 파일이 없으면 기존 이미지를 유지할 수 있습니다.
            cuImg = request.getParameter("existingCuImg");  // 기존 이미지 파일 이름
        }

        if (cuNum != 0) {
            CommunityMgr mgr = new CommunityMgr();
            try {
                // 게시물 업데이트
                mgr.updatePost(cuNum, title, content, cuImg);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 수정 후 메인 페이지로 리다이렉트
        response.sendRedirect("Community_Main.jsp");
    }

    // 파일 이름 추출 메소드
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
