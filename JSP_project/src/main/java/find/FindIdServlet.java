package find;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserMgr;

@WebServlet("/find/findId")
public class FindIdServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 파라미터로 전달된 이름과 전화번호를 받습니다.
        String name = request.getParameter("name").trim();
        String phone = request.getParameter("phone").trim();

        // UserMgr 객체 생성
        UserMgr userMgr = new UserMgr();
        String foundId = userMgr.findUserId(name, phone);

        String loginPlatform = null;
        if (foundId != null && !foundId.isEmpty()) {
            // 각 소셜 로그인 플랫폼에 대해 확인
            if (userMgr.isSocialUserExist(foundId, "KAKAO")) {
                loginPlatform = "카카오";
            } else if (userMgr.isSocialUserExist(foundId, "NAVER")) {
                loginPlatform = "네이버";
            } else if (userMgr.isSocialUserExist(foundId, "GOOGLE")) {
                loginPlatform = "구글";
            }
        }

        // 결과를 request에 설정
        request.setAttribute("foundId", foundId);
        request.setAttribute("loginPlatform", loginPlatform);
        request.setAttribute("searchPerformed", true); // 검색 작업이 수행됨을 표시

        // findId.jsp로 포워드하여 결과 표시
        RequestDispatcher dispatcher = request.getRequestDispatcher("/find/findId.jsp");
        dispatcher.forward(request, response);
    }
}
