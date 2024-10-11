package challenge;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/challenge/challengeInsert")
public class ChallengeInsertServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		ChallengeMgr mgr = new ChallengeMgr();
		ChallengeBean bean = new ChallengeBean();

		
		bean.setChallengeName(request.getParameter("challengeName"));
		bean.setDescription(request.getParameter("description"));
		bean.setStartDate(request.getParameter("startDate"));
		bean.setEndDate(request.getParameter("endDate"));
		bean.setGoal(request.getParameter("goal"));

		if(mgr.challengeInsert(bean)) {
			response.sendRedirect("challengeList.jsp");
		} else {
			response.setContentType("text/html; charset=UTF-8");
			 PrintWriter out = response.getWriter();
			 out.println("<script>");
			 out.println("alert('작성 실패했습니다.')");
			 out.println("history.back()");
			 out.println("</script>");
		}
	}

}
