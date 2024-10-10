package mypage;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import user.UserMgr;


@WebServlet("/mypage/mypageProfile")
public class mypageProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);

		
		MultipartRequest multi = new MultipartRequest(request, UserMgr.SAVEFOLDER, UserMgr.MAXSIZE, UserMgr.ENCODING, new DefaultFileRenamePolicy());
		String action = multi.getParameter("action");
		UserMgr mgr = new UserMgr();
		PrintWriter out = response.getWriter();
		
		
		if ("update".equals(action)) {
			boolean result = mgr.myprofileUpdate(multi);
			if(result) {
				response.setContentType("text/html; charset=UTF-8");
				out.println("<script>");
				out.println("alert('수정 되었습니다.')");
				out.println("</script>");
				response.sendRedirect("myPage.jsp");
				 return;
			} else {
				response.setContentType("text/html; charset=UTF-8");
				out.println("<script>");
				out.println("alert('수정 실패했습니다.')");
				out.println("history.back()");
				out.println("</script>");
				 return;
			}
		} else if("delete".equals(action)) {
			boolean res = mgr.deleteProfile(multi);
			if(res) {
			response.setContentType("text/html; charset=UTF-8");
			out.println("<script>");
			out.println("alert('탈퇴 되었습니다.')");
			out.println("</script>");
			response.sendRedirect("myPage.jsp");
			 return;
			} else {
				response.setContentType("text/html; charset=UTF-8");
				out.println("<script>");
				out.println("alert('탈퇴 실패했습니다.')");
				out.println("history.back()");
				out.println("</script>");
			}
			
		}
	}

}
