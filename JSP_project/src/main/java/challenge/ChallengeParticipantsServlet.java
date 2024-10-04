package challenge;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/challenge/challengeparticipants")
public class ChallengeParticipantsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		MultipartRequest multi = new MultipartRequest(request, ChallengeMgr.SAVEFOLDER, ChallengeMgr.MAXSIZE, ChallengeMgr.ENCODING, new DefaultFileRenamePolicy());
		ChallengeMgr mgr = new ChallengeMgr();
		String challengeId = multi.getParameter("challengeId");
		int num = Integer.parseInt(challengeId);
		boolean result = mgr.challengeParticpants(multi);
		if(result) {
			out.println("<script>");
			out.println("window.opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
		} else {
			
			out.println("<script>");
			out.println("alert('작성 실패했습니다.')");
			out.println("history.back()");
			out.println("</script>");
		}
	}

}
