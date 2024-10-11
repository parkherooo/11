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
        // 한글 인코딩 설정
        request.setCharacterEncoding("UTF-8");

        // 파라미터로 전달된 이름과 전화번호를 받습니다.
        String name = request.getParameter("name").trim();
        String phone = request.getParameter("phone").trim();

        // UserMgr 객체 생성
        UserMgr userMgr = new UserMgr();
        String foundId = userMgr.findUserId(name, phone);

        // 아이디가 찾아졌을 경우 결과를 request에 설정
        if (foundId != null) {
            request.setAttribute("foundId", foundId);
        } else {
            request.setAttribute("foundId", "");
        }

        // findId.jsp로 포워드하여 결과 표시
        RequestDispatcher dispatcher = request.getRequestDispatcher("/find/findId.jsp");
        dispatcher.forward(request, response);
    }
}
