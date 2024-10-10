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

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter(); // 스트림 호출

        MultipartRequest multi = new MultipartRequest(request, UserMgr.SAVEFOLDER, UserMgr.MAXSIZE, UserMgr.ENCODING, new DefaultFileRenamePolicy());
        String action = multi.getParameter("action");
        UserMgr mgr = new UserMgr();
        
        if ("update".equals(action)) {
            boolean result = mgr.myprofileUpdate(multi);
            out.println("<script>");
            if(result) {
                out.println("alert('수정 되었습니다.');");
                out.println("location.href='../mypage/myPage.jsp';");
            } else {
                out.println("alert('수정 실패했습니다.');");
                out.println("history.back();");
            }
            out.println("</script>");
            out.close(); // 출력 스트림을 닫아줍니다.
            return;
        } else if ("delete".equals(action)) {
            boolean res = mgr.deleteProfile(multi);
            out.println("<script>");
            if(res) {
                out.println("alert('프로필 삭제 되었습니다.');");
                out.println("location.href='../mypage/myPage.jsp';");
            } else {
                out.println("alert('프로필 삭제 실패했습니다.');");
                out.println("history.back();");
            }
            out.println("</script>");
            out.close(); // 출력 스트림을 닫아줍니다.
            return;
        }
    }
}
