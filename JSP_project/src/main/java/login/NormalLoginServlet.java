package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import user.UserMgr;

@WebServlet("/login/normalLogin")
public class NormalLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");

        // 파라미터로 전달된 아이디와 비밀번호를 받습니다.
        String myuserId = request.getParameter("myuserId");
        String pwd = request.getParameter("password");

        // UserMgr 객체 생성
        UserMgr userMgr = new UserMgr();
        HttpSession session = request.getSession();

        // 로그인 로직 수행
        boolean loggedIn = userMgr.loginUser(myuserId, pwd, session);

        if (loggedIn) {
            // 로그인 성공 시 메인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/main/main.jsp");
        } else {
            // 로그인 실패 시 경고 메시지 출력 후 이전 페이지로 돌아가기
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().println("<script>");
            response.getWriter().println("alert('로그인 실패. 아이디와 비밀번호를 확인해주세요.');");
            response.getWriter().println("history.back();");
            response.getWriter().println("</script>");
        }
    }
}
