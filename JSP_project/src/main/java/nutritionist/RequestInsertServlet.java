package nutritionist;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DB.MUtil;


@WebServlet("/RequestInsertServlet")
public class RequestInsertServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		
		String userId = request.getParameter("userId");
		int count = Integer.parseInt(request.getParameter("count"));
		int calorie = Integer.parseInt(request.getParameter("calorie"));
		String allergy = request.getParameter("allergy");
		String dontlike = request.getParameter("dontlike");
		String requirement = request.getParameter("requirement");
		
		nutritionistBean nBean = new nutritionistBean();
		nutritionistMgr nMgr = new nutritionistMgr();
		
		nBean.setUserId(userId);
		nBean.setCount(count);
		nBean.setCalorie(calorie);
		nBean.setAllergy(allergy);
		nBean.setDontlike(dontlike);
		nBean.setRequirement(requirement);
		
		nMgr.insertRequest(nBean);
		
		response.sendRedirect("nutritionist/mealPlanSuccess.jsp");
	}

}
