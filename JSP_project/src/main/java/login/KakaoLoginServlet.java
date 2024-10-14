package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserBean;
import user.UserMgr;

@WebServlet("/login/kakaoLogin")
public class KakaoLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserMgr userMgr = new UserMgr();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 카카오로부터 받은 데이터
        String kakaoEmail = request.getParameter("kakaoUserId");
        String kakaoName = request.getParameter("kakaoName");
        String loginPlatform = "Kakao"; // 로그인 플랫폼 설정

        // 이미 다른 소셜 플랫폼으로 가입된 사용자인지 확인
        if (userMgr.isSocialUserExist(kakaoEmail, "NAVER")) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('이미 네이버 계정으로 가입되어 있습니다. 해당 계정으로 로그인해주세요.'); location.href='" + request.getContextPath() + "/login/logIn.jsp';</script>");
            return;
        }
        
        // 카카오 사용자 정보를 UserBean에 담음
        UserBean userBean = new UserBean();
        userBean.setUserId(kakaoEmail);
        userBean.setName(kakaoName);
        userBean.setLoginPlatform(loginPlatform);

        // DB에 사용자 정보 저장 또는 중복 확인
        boolean isUserInserted = false;
        if (!userMgr.isSocialUserExist(kakaoEmail, loginPlatform)) {
            // 새로운 사용자라면 기본 정보 저장
            isUserInserted = userMgr.insertSocialUser(userBean);
        }

        // 로그인 처리 및 세션 설정
        request.getSession().setAttribute("userId", kakaoEmail);
        request.getSession().setAttribute("name", kakaoName);
        request.getSession().setAttribute("loginPlatform", "Kakao"); // 로그인 플랫폼 저장

        // 추가 정보 입력 페이지 또는 메인 페이지로 리다이렉트
        if (isUserInserted) {
            // 새로 추가된 사용자라면 추가 정보 입력 페이지로 이동
            response.sendRedirect("../login/additionalInfo.jsp?success=true");
        } else {
            // 기존 사용자라면 바로 메인 페이지로 이동
            response.sendRedirect("../main/main.jsp");
        }
    }
}
