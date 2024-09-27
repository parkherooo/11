package mypage;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserMgr;


@WebServlet("/mypage/FriendAction")
public class friendActionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = request.getParameter("userId");
		String friendId = request.getParameter("friendId");
		String redirectUrl = "myPage.jsp?category=" + URLEncoder.encode("친구관리", "UTF-8"); // 인코딩 처리
		String action = request.getParameter("action");
		UserMgr mgr = new UserMgr();
		
		System.out.println(userId);
		System.out.println(friendId);
		System.out.println(action);
		if ("accept".equals(action)) {
	        // 친구 요청 수락 처리
	        mgr.frOk(userId, friendId);
	       
			response.sendRedirect(redirectUrl);
	    } else if ("delete".equals(action)) {
	        // 친구 요청 삭제 처리
	        mgr.frDelete(userId, friendId);
	    	response.sendRedirect(redirectUrl);
	    }
	}

}
