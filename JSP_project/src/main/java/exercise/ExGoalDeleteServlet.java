package exercise;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ExGoalDeleteServlet")
public class ExGoalDeleteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 사용자 ID를 가져옴
        String userId = request.getParameter("userId");
        
        // ExerciseGoalMgr를 이용해 삭제 수행
        ExerciseGoalMgr Emgr = new ExerciseGoalMgr();
        Emgr.deleteGoal(userId);
        
        response.sendRedirect("exercise/setGoal.jsp");
    }
}
