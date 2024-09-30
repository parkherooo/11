package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import user.UserMgr;
import user.UserBean;

@WebServlet("/login/kakaoLogin")
public class KakaoLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserMgr userMgr = new UserMgr(); // UserMgr 객체 생성

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 클라이언트로부터 받은 액세스 토큰과 사용자 정보
		String userId = request.getParameter("userId"); // 카카오 유저 ID
		String nickname = request.getParameter("nickname"); // 카카오 닉네임

		// 사용자가 이미 존재하는지 확인
		if (userMgr.isKakaoUserExist(userId)) {
			// 이미 가입된 사용자라면 로그인 처리
			HttpSession session = request.getSession();
			session.setAttribute("userId", userId);
			session.setAttribute("name", nickname);
			response.sendRedirect("YOUR_MAIN_PAGE.jsp"); // 메인 페이지로 이동
		} else {
			// 신규 사용자라면 회원가입 진행
			UserBean newUser = new UserBean();
			newUser.setUserId(userId);
			newUser.setName(nickname);
			// 추가적으로 필요한 사용자 정보 설정 가능

			if (userMgr.insertKakaoUser(newUser)) {
				// 회원가입 성공 시 세션 설정 및 리다이렉트
				HttpSession session = request.getSession();
				session.setAttribute("userId", userId);
				session.setAttribute("name", nickname);
				response.sendRedirect("YOUR_MAIN_PAGE.jsp");
			} else {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "회원가입에 실패하였습니다.");
			}
		}
	}
}
