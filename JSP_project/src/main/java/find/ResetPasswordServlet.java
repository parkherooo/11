package find;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import user.UserMgr;

@WebServlet("/find/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String resetUserId = (String) session.getAttribute("resetUserId");
        String newPassword = request.getParameter("newPassword");

        // resetUserId가 없을 경우 에러 처리
        if (resetUserId == null) {
            response.sendRedirect("findPwd.jsp?resetPwd=false");
            return;
        }
        
        UserMgr userMgr = new UserMgr();
        boolean isReset = userMgr.resetPassword(resetUserId, newPassword);

        if (isReset) {
            session.removeAttribute("resetUserId");
            session.removeAttribute("verificationCode");
            session.removeAttribute("codeVerified");
            session.removeAttribute("inputCode");
            response.sendRedirect("findPwd.jsp?resetPwd=true");
        } else {
            response.sendRedirect("findPwd.jsp?resetPwd=false");
        }
    }

}
