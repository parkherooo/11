package diet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import org.json.simple.JSONObject;

@WebServlet("/diet/SaveDietServlet")
public class SaveDietServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            sendJsonResponse(response, false, "로그인을 먼저 실행해주세요.");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String diet = request.getParameter("diet");
        String selectedDate = request.getParameter("selectedDate");
        int calorie; 

        try {
            calorie = Integer.parseInt(request.getParameter("calories"));
        } catch (NumberFormatException e) {
            sendJsonResponse(response, false, "칼로리는 숫자여야 합니다.");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", "root", "1234");

            String sql = "INSERT INTO tblDietaryRecords (userId, diet, calorie, drDate) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, diet);
            pstmt.setInt(3, calorie);
            pstmt.setString(4, selectedDate);

            int result = pstmt.executeUpdate();
            if(result > 0) {
                sendJsonResponse(response, true, "식단이 성공적으로 저장되었습니다.");
            } else {
                sendJsonResponse(response, false, "식단 저장에 실패했습니다.");
            }
        } catch(Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "오류가 발생했습니다: " + e.getMessage());
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("success", success);
        jsonObject.put("message", message);
        response.getWriter().write(jsonObject.toJSONString());
    }
}