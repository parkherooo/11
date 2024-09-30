package exercise; // 패키지 이름 변경

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import org.json.simple.JSONObject;

@WebServlet("/exercise/GetExerciseServlet") // URL 매핑 추가
public class GetExerciseServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String userId = request.getParameter("userId");
        String selectedDate = request.getParameter("selectedDate");
        JSONObject result = new JSONObject();
        
        if (userId == null || selectedDate == null) {
            result.put("error", "Invalid parameters");
            response.getWriter().write(result.toJSONString());
            return;
        }

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime?useSSL=false&serverTimezone=UTC", "root", "1234");
             PreparedStatement pstmt = conn.prepareStatement("SELECT exercise FROM tblExerciseRecords WHERE userId = ? AND erDate = ?")) {
            
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result.put("exercise", rs.getString("exercise"));
                } else {
                    result.put("exercise", "");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result.put("error", "데이터를 불러오는 중 오류가 발생했습니다.");
        }
        
        response.getWriter().write(result.toJSONString());
    }
}