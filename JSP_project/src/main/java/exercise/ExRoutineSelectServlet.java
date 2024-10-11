package exercise;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/exercise/ExRoutineSelectServlet")
public class ExRoutineSelectServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 사용자가 선택한 값 가져오기
        String split = request.getParameter("split");
        // ExerciseRoutineMgr 인스턴스 생성
        ExerciseRoutineMgr rMgr = new ExerciseRoutineMgr();

        if ("nopart".equals(split)) {
            // noPart() 메서드 호출
            List<ExerciseRoutineBean> routineList = rMgr.noPart();
            
            // 결과를 요청 속성에 저장
            request.setAttribute("routineList", routineList);
        }
        else  if ("twopart".equals(split)) {
            List<ExerciseRoutineBean> routineList = rMgr.twoPart();

            request.setAttribute("routineList", routineList);
        }
        else  if ("threepart".equals(split)) {
        	List<ExerciseRoutineBean> routineList = rMgr.threePart();

        	request.setAttribute("routineList", routineList);
        }
        else  if ("cardio".equals(split)) {
        	List<ExerciseRoutineBean> routineList = rMgr.cardio();

        	request.setAttribute("routineList", routineList);
        }        
        

        // JSP로 포워딩
        request.getRequestDispatcher("/exercise/routineResult.jsp").forward(request, response);
    }
}
