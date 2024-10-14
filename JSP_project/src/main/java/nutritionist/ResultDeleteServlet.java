package nutritionist;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import exercise.ExerciseGoalMgr;

@WebServlet("/ResultDeleteServlet")
public class ResultDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String userId = request.getParameter("userId");

		nutritionistMgr nMgr = new nutritionistMgr();
		nMgr.deleteResult(userId);

		response.sendRedirect("nutritionist/mealPlanRequest.jsp");
	}

}
