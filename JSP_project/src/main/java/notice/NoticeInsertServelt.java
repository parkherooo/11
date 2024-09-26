package notice;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/notice/noticePost")
public class NoticeInsertServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		NoticeMgr mgr = new NoticeMgr();
		boolean result =  mgr.noticeInsert(request);
		if(result) {
			response.sendRedirect("noticeList.jsp");
		} else {
			 response.setContentType("text/html; charset=UTF-8");
			 PrintWriter out = response.getWriter();
			 out.println("<script>");
			 out.println("alert('작성 실패했씁니다.')");
			 out.println("history.back()");
			 out.println("</script>");
		}
				
		
		
	}
}

