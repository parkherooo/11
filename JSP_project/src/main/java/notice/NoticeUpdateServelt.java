package notice;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


@WebServlet("/notice/noticeUpdate")
public class NoticeUpdateServelt extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		MultipartRequest multi = new MultipartRequest(request, NoticeMgr.SAVEFOLDER, NoticeMgr.MAXSIZE, NoticeMgr.ENCODING, new DefaultFileRenamePolicy());
		String nNum = multi.getParameter("nNum");
		NoticeMgr mgr = new NoticeMgr();
		boolean result =  mgr.noticeUpdate(multi);
		if(result) {
			response.sendRedirect("noticeDetail.jsp?nNum="+nNum);
		} else {
			 response.setContentType("text/html; charset=UTF-8");
			 PrintWriter out = response.getWriter();
			 out.println("<script>");
			 out.println("alert('수정 실패했습니다.')");
			 out.println("history.back()");
			 out.println("</script>");
		}
	}
}

