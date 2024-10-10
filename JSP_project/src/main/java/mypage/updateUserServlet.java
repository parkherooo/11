package mypage;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import user.UserBean;
import user.UserMgr;


@WebServlet("/mypage/updateUser")
public class updateUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");
		UserBean bean = new UserBean();
		
		bean.setName(request.getParameter("name"));
		bean.setUserId(request.getParameter("userId"));
		bean.setPhone(request.getParameter("phone"));
		bean.setAddress(request.getParameter("address"));
		bean.setBirth(request.getParameter("birth"));
		
		UserMgr mgr = new UserMgr();
		
		if(action.equals("update")) {
			if(mgr.myinfoUpdate(bean)) {
				PrintWriter out = response.getWriter();
				 out.println("<script>");
				 out.println("alert('수정 성공했습니다.')");
				 out.println("</script>");
				response.sendRedirect("myPage.jsp");
			} else {
				response.setContentType("text/html; charset=UTF-8");
				 PrintWriter out = response.getWriter();
				 out.println("<script>");
				 out.println("alert('수정 실패했습니다.')");
				 out.println("history.back()");
				 out.println("</script>");
			}
		} else if(action.equals("delete")) {
			if(mgr.myinfoDelete(bean.getUserId())) {
				PrintWriter out = response.getWriter();
				 out.println("<script>");
				 out.println("alert('탈퇴 성공했습니다.')");
				 out.println("</script>");
				 HttpSession session = request.getSession();
				 session.invalidate(); // 세션을 무효화하여 모든 속성을 삭제합니다.
				response.sendRedirect("../main/main.jsp");
			} else {
				response.setContentType("text/html; charset=UTF-8");
				 PrintWriter out = response.getWriter();
				 out.println("<script>");
				 out.println("alert('탈퇴 실패했습니다.')");
				 out.println("history.back()");
				 out.println("</script>");
			}
		}
		
	}

}
