package find;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/find/verifyCode")
public class VerifyCodeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inputCode = request.getParameter("verificationCode");
        HttpSession session = request.getSession();
        String sessionCode = (String) session.getAttribute("verificationCode");

        if (inputCode.equals(sessionCode)) {
            session.setAttribute("codeVerified", "true");
            response.sendRedirect("findPwd.jsp?codeVerified=true");
        } else {
        	response.sendRedirect("findPwd.jsp?codeVerified=false");
        }
    }

}
