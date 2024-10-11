package exercise;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import org.json.simple.JSONObject;

@WebServlet("/exercise/SaveExerciseServlet")
public class SaveExerciseServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JSONObject result = new JSONObject();
        
        String userId = request.getParameter("userId");
        String exercise = request.getParameter("exercise");
        String selectedDate = request.getParameter("selectedDate");
        
        System.out.println("Received parameters - userId: " + userId + ", exercise: " + exercise + ", selectedDate: " + selectedDate);
        
        if (userId == null || exercise == null || selectedDate == null) {
            result.put("status", "fail");
            result.put("message", "Invalid parameters");
            response.getWriter().write(result.toJSONString());
            return;
        }

        String dbUrl = "jdbc:mysql://113.198.238.93/fittime?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPassword = "1234";

        String sql = "INSERT INTO tblExerciseRecords (userId, exercise, erDate) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE exercise = ?";
        
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, userId);
            pstmt.setString(2, exercise);
            pstmt.setDate(3, java.sql.Date.valueOf(selectedDate));
            pstmt.setString(4, exercise);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                result.put("status", "success");
                result.put("message", "Exercise record saved successfully");
            } else {
                result.put("status", "fail");
                result.put("message", "Failed to save exercise record");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result.put("status", "error");
            result.put("message", "Database error occurred");
        }
        
        response.getWriter().write(result.toJSONString());
    }
}