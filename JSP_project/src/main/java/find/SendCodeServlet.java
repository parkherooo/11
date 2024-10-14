package find;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.UUID;
import user.UserMgr;

@WebServlet("/find/sendCode")
public class SendCodeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String verificationCode = UUID.randomUUID().toString().substring(0, 6); // 인증 코드 생성
 
        // UserMgr 인스턴스 생성 및 이메일 존재 확인
        UserMgr userMgr = new UserMgr();
        boolean userExists = userMgr.idChk(userId);

        if (!userExists) {
            response.sendRedirect("findPwd.jsp?success=false");
            return;
        }
        
        // 이메일 발신자 정보
        String emailService = "naver"; 
        String from = "ekdms6700@naver.com";
        String fromName = "Fit Time";
        String password = "REXJH8ER3HBE"; // 앱 비밀번호
        String subject = "Fit Time 비밀번호 찾기 인증 코드";
        String content = "인증 코드: " + verificationCode;

        // 이메일 전송
        boolean emailSent = EmailService.sendEmail(emailService, from, fromName, password, userId, subject, content);

        HttpSession session = request.getSession();

        if (emailSent) {
            session.setAttribute("verificationCode", verificationCode);
            session.setAttribute("resetUserId", userId);
            session.setAttribute("codeSent", "true");
            response.sendRedirect("findPwd.jsp?sendCode=true");
        } else {
            response.sendRedirect("findPwd.jsp?sendCode=false");
        }
    }
}
