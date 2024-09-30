package mypage;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserMgr;


@WebServlet("/mypage/friendDelete")
public class friendDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		int num = Integer.parseInt(request.getParameter("num"));
		String redirectUrl = "myPage.jsp?category=" + URLEncoder.encode("친구관리", "UTF-8"); // 인코딩 처리

		UserMgr mgr = new UserMgr();
		if(action.equals("delete")) {
			if(mgr.freindDelete(num)) {
				response.sendRedirect(redirectUrl);
			} else {
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('친구삭제에 실패하셨습니다.')");
				out.println("history.back()");
				out.println("</script>");
			}
		}
	}
}
