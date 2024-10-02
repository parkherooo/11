package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.api.client.auth.openidconnect.IdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;

import user.UserBean;
import user.UserMgr;

@WebServlet("/login/googleLogin")
public class GoogleLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    private static final String CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID"; // 구글 클라이언트 ID
    private UserMgr userMgr = new UserMgr();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    }
}


