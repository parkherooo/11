package challenge;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/challenge/heartPlus")
public class heartPlusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		ChallengeMgr mgr = new ChallengeMgr();
		String userId = request.getParameter("userId");
		String challengeId = request.getParameter("challengeId");
		int id = Integer.parseInt(request.getParameter("participantId"));
		
		boolean heartOn = mgr.heartPlus(userId, id);

        // 결과를 request 속성으로 설정

        request.setAttribute("heartStatus", heartOn);

        // 페이지 포워딩
        RequestDispatcher dispatcher = request.getRequestDispatcher("challengeParticipation.jsp?num=" + challengeId);
        dispatcher.forward(request, response);
	}

}
