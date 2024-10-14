package exercise;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import org.json.simple.JSONObject;

@WebServlet("/exercise/GetExerciseServlet")
public class GetExerciseServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        
        JSONObject jsonResult = new JSONObject();
        
        try {
            String userId = java.net.URLDecoder.decode(request.getParameter("userId"), "UTF-8");
            String selectedDate = request.getParameter("selectedDate");
            
            System.out.println("Received userId: " + userId);
            System.out.println("Received selectedDate: " + selectedDate);
            
            if (userId == null || selectedDate == null) {
                throw new IllegalArgumentException("Invalid parameters");
            }
            
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", "root", "1234");
                 PreparedStatement pstmt = conn.prepareStatement("SELECT exercise FROM tblExerciseRecords WHERE userId = ? AND erDate = ?")) {
                
                pstmt.setString(1, userId);
                pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));
                
                System.out.println("Executing SQL: " + pstmt.toString());
                
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        String exercise = rs.getString("exercise");
                        System.out.println("Found data: exercise = " + exercise);
                        jsonResult.put("exercise", exercise);
                    } else {
                        System.out.println("No data found for the selected date");
                    }
                }
            } catch (SQLException e) {
                System.out.println("SQL Error: " + e.getMessage());
                throw new ServletException("Database error: " + e.getMessage());
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            jsonResult.put("error", e.getMessage());
        }
        
        System.out.println("Sending response: " + jsonResult.toJSONString());
        response.getWriter().write(jsonResult.toJSONString());
    }
}