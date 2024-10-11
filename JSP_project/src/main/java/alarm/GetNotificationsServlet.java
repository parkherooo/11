package alarm;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@WebServlet("/alarm/getNotifications")
public class GetNotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	 HttpSession session = request.getSession();
         String userId = (String) session.getAttribute("userId"); 
        
        AlarmMgr alarmMgr = new AlarmMgr();
        List<AlarmBean> notifications;

        try {
            notifications = alarmMgr.getNotifications(userId);  // 알림 목록 가져오기
        } catch (Exception e) {
            e.printStackTrace();
            // 예외 발생 시, 빈 알림 리스트 반환
            notifications = List.of();  // 빈 리스트 반환
        }
        
        // 날짜 형식을 yyyy-MM-dd로 지정하여 JSON으로 변환
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();  // 날짜 형식 지정
        out.print(gson.toJson(notifications));  // JSON으로 변환하여 출력
        out.flush();
    }
}
