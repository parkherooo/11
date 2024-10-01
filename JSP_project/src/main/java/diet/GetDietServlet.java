package diet;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;
import org.json.simple.JSONObject;

@WebServlet("/diet/GetDietServlet")
public class GetDietServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String selectedDate = request.getParameter("selectedDate");
        JSONObject jsonResult = new JSONObject();
        
        if (userId == null || selectedDate == null) {
            jsonResult.put("error", "Invalid parameters");
            sendJsonResponse(response, jsonResult);
            return;
        }

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime?useSSL=false&serverTimezone=UTC", "root", "1234");
             PreparedStatement pstmt = conn.prepareStatement("SELECT diet, calorie FROM tblDietaryRecords WHERE userId = ? AND drDate = ?")) {
            
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    jsonResult.put("diet", rs.getString("diet"));
                    jsonResult.put("calories", rs.getInt("calorie"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResult.put("error", "데이터를 불러오는 중 오류가 발생했습니다.");
        }
        
        sendJsonResponse(response, jsonResult);
    }

    private void sendJsonResponse(HttpServletResponse response, JSONObject jsonResult) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResult.toJSONString());
    }
}