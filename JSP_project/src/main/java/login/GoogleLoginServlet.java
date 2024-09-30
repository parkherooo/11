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
        String idTokenString = request.getParameter("idtoken");

        // GoogleTokenVerifier로 토큰 검증
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new JacksonFactory())
            .setAudience(Collections.singletonList(CLIENT_ID))
            .build();

        GoogleIdToken idToken = verifier.verify(idTokenString);
        if (idToken != null) {
            Payload payload = idToken.getPayload();
            
            // 사용자 정보 가져오기
            String userId = payload.getEmail(); // 구글 이메일을 userId로 사용
            String name = (String) payload.get("name");

            // 사용자가 이미 존재하는지 확인
            if (userMgr.isGoogleUserExist(userId)) {
                // 이미 가입된 사용자라면 로그인 처리
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("name", name);
                response.sendRedirect("YOUR_MAIN_PAGE.jsp");
            } else {
                // 신규 사용자라면 회원가입 진행
                UserBean newUser = new UserBean();
                newUser.setUserId(userId);
                newUser.setName(name);
                // 추가적으로 필요한 사용자 정보가 있다면 여기에 설정
                
                if (userMgr.insertGoogleUser(newUser)) {
                    // 회원가입 성공 시 세션 설정 및 리다이렉트
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", userId);
                    session.setAttribute("name", name);
                    response.sendRedirect("YOUR_MAIN_PAGE.jsp");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "회원가입에 실패하였습니다.");
                }
            }
        } else {
            // 토큰 검증 실패 시 처리
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "토큰 검증에 실패하였습니다.");
        }
    }
}


