package mypage;

import java.io.IOException;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserMgr;


@WebServlet("/mypage/allergyUpdate")
public class allergyUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String selectedAllergies = request.getParameter("selectedAllergies");
		selectedAllergies = selectedAllergies.replace("갑각류", "새우,게,킹크랩");
		selectedAllergies = selectedAllergies.replace("유제품", "우유,치즈,요거트,버터,아이스크림");
		selectedAllergies = selectedAllergies.replace("견과류", "호두,아몬드,피스타치오,캐슈넛,피칸,헤이즐넛,마카다미아,브라질넛,잣");
		String userId = request.getParameter("userId");
		
		UserMgr mgr = new UserMgr();
		mgr.updateAllergy(userId, selectedAllergies);
		String redirectUrl = "myPage.jsp?category=" + URLEncoder.encode("알러지관리", "UTF-8"); // 인코딩 처리
		response.sendRedirect(redirectUrl);
	}

}
