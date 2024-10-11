package alarm;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/alarm/checkNewAlarms")
public class CheckNewAlarmsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 현재 로그인된 사용자의 ID를 세션에서 가져옴
        String userId = (String) request.getSession().getAttribute("userId");

        // 알림 리스트 초기화
        List<AlarmBean> newAlarms = new ArrayList<>();

        if (userId != null) {
            AlarmMgr alarmMgr = new AlarmMgr();
            try {
                // 확인되지 않은 알림 가져오기
                newAlarms = alarmMgr.getUnseenAlarms(userId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 알림 목록을 JSON으로 변환하여 응답
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        out.print(gson.toJson(newAlarms));  // 알림 목록을 JSON 형태로 반환
        out.flush();
    }
}
