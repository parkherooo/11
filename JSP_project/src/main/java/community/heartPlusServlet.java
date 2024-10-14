package community;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/community/heartPlus")
public class heartPlusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		CommunityMgr mgr = new CommunityMgr();
		String userId = request.getParameter("userId");
		String cuNum = request.getParameter("cuNum");
		int id = Integer.parseInt(request.getParameter("cuNum"));
		
		boolean heartOn = mgr.heartPlus(userId, id);

        // 결과를 request 속성으로 설정

        request.setAttribute("heartStatus", heartOn);

        // 페이지 포워딩
        response.sendRedirect("postDetail.jsp?cuNum="+cuNum);
	}

}
