package community;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import community.CommunityBean;
import community.CommunityMgr;

@WebServlet("/community/uploadedServlet")
public class UploadedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CommunityMgr mgr;

    public void init() throws ServletException {
        // CommunityMgr 객체 초기화
        mgr = new CommunityMgr();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // POST 요청 처리 (게시물 작성)
        request.setCharacterEncoding("UTF-8");
        
        // 세션에서 로그인된 사용자 ID 가져오기
        String userId = (String) request.getSession().getAttribute("userId");
        if (userId == null) {
            userId = "guest";  // 로그인되지 않은 경우 기본값 설정
        }

        // JSP에서 전달된 폼 데이터 받기
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String cuImg = request.getParameter("cuImg");  // 파일 업로드 로직은 별도로 처리해야 함
        int recommend = 0;  // 추천 수 초기값

        // CommunityBean 객체에 데이터 설정
        CommunityBean bean = new CommunityBean();
        bean.setUserId(userId);
        bean.setTitle(title);
        bean.setContent(content);
        bean.setCuImg(cuImg);
        bean.setRecommend(recommend);

        // 데이터베이스에 게시물 저장
        boolean success = false;
        try {
            success = mgr.insertPost(bean);  // 게시물 저장 메서드 호출
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 결과에 따라 리다이렉트 처리
        if (success) {
            response.sendRedirect("Community_Main.jsp");  // 게시글 작성 성공 후 메인 페이지로 이동
        } else {
            response.sendRedirect("post_create.jsp?error=true");  // 실패 시 다시 작성 페이지로 이동
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);  // GET 요청도 POST 방식으로 처리
    }
}
