package alarm;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/alarm/updateAlarm")
public class UpdateAlarmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청으로부터 알림 번호 (alarmNum) 가져오기
        String alarmNumStr = request.getParameter("alarmNum");
        int alarmNum = Integer.parseInt(alarmNumStr);  
        
        AlarmMgr alarmMgr = new AlarmMgr();
        boolean success = false;  // 변수 초기화

        try {
            success = alarmMgr.updateCheckAlarm(alarmNum);  // 업데이트 성공 시 true로 변경
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 응답 처리
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        if (success) {
            out.write("success");
        } else {
            out.write("fail");
        }
        out.flush();
    }
}
