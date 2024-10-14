package mypage;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import user.UserMgr;

@WebServlet("/mypage/mypageProfile")
public class mypageProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // MultipartRequest 생성
        MultipartRequest multi = new MultipartRequest(request, UserMgr.SAVEFOLDER, UserMgr.MAXSIZE, UserMgr.ENCODING, new DefaultFileRenamePolicy());
        String action = multi.getParameter("action");
        UserMgr mgr = new UserMgr();
        
        // 출력 설정
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 프로필 업데이트 처리
        if ("update".equals(action)) {
            boolean result = mgr.myprofileUpdate(multi);
            if (result) {
                out.println("<script>");
                out.println("alert('수정 되었습니다.');");
                out.println("location.href='../mypage/myPage.jsp';");
                out.println("</script>");
                out.close(); // 스트림을 닫음
                return;
            } else {
                out.println("<script>");
                out.println("alert('수정 실패했습니다.');");
                out.println("history.back();");
                out.println("</script>");
                out.close(); // 스트림을 닫음
                return;
            }
        }
        
        // 프로필 삭제 처리
        else if ("delete".equals(action)) {
            boolean res = mgr.deleteProfile(multi);
            if (res) {
                out.println("<script>");
                out.println("alert('프로필 삭제되었습니다.');");
                out.println("location.href='../mypage/myPage.jsp';");
                out.println("</script>");
                out.close(); // 스트림을 닫음
                return;
            } else {
                out.println("<script>");
                out.println("alert('프로필 삭제 실패했습니다.');");
                out.println("history.back();");
                out.println("</script>");
                out.close(); // 스트림을 닫음
            }
        }
    }
}
