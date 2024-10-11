package exercise;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ExGoalInsertServlet")
public class ExGoalInsertServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");


		// 폼에서 전달된 값 받기
		String userId = request.getParameter("userId");
		String sdate = request.getParameter("sdate");
		String edate = request.getParameter("edate");
		String goalweight = request.getParameter("goalweight");
		String mypromise = request.getParameter("mypromise");

		// 값이 제대로 넘어왔는지 확인
		if (sdate != null && edate != null && goalweight != null && mypromise != null) {
			// ExerciseGoalBean과 ExerciseGoalMgr 객체 생성
			ExerciseGoalMgr goalMgr = new ExerciseGoalMgr();
			ExerciseGoalBean goalBean = new ExerciseGoalBean();

			goalBean.setUserId(userId);
			goalBean.setGoalweight(goalweight);
			goalBean.setSdate(sdate);
			goalBean.setEdate(edate);
			goalBean.setMypromise(mypromise);

			// DB에 운동 목표 저장
			goalMgr.insertGoal(goalBean);

			// 성공 시 피드백 페이지로 리디렉션 (다른 페이지로 설정 가능)
			response.sendRedirect("exercise/setGoal.jsp");
		}
	}
}