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


@WebServlet("/mypage/friendPlus")
public class friendPlusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		UserMgr mgr = new UserMgr();
		String userId = request.getParameter("userId");
		String friendId = request.getParameter("friendId");
		String redirectUrl = "myPage.jsp?category=" + URLEncoder.encode("친구관리", "UTF-8"); // 인코딩 처리
		if(mgr.frplusChk(userId)==true){
			if(mgr.frPlus(userId, friendId)) {
				response.sendRedirect(redirectUrl);
			} else {
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('이미 친구 추가를 하였습니다.')");
				out.println("history.back()");
				out.println("</script>");
			}
		} else {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('상대가 친구 추가를 하였습니다.')");
			out.println("history.back()");
			out.println("</script>");
		}
		
		
		
		
		
	}

}
