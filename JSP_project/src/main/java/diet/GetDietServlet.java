package diet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class GetDietServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String selectedDate = request.getParameter("selectedDate");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // 데이터베이스 연결 (연결 정보는 실제 환경에 맞게 수정해야 합니다)
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime", "root", "1234");

            String sql = "SELECT breakfast, lunch, dinner, calorie FROM tblDietaryRecords WHERE userId = ? AND drDate = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));

            rs = pstmt.executeQuery();

            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{");
            if(rs.next()) {
                jsonBuilder.append("\"breakfast\":\"").append(escapeJson(rs.getString("breakfast"))).append("\",");
                jsonBuilder.append("\"lunch\":\"").append(escapeJson(rs.getString("lunch"))).append("\",");
                jsonBuilder.append("\"dinner\":\"").append(escapeJson(rs.getString("dinner"))).append("\",");
                jsonBuilder.append("\"calories\":").append(rs.getInt("calorie"));
            }
            jsonBuilder.append("}");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(jsonBuilder.toString());

        } catch(Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"데이터를 불러오는 중 오류가 발생했습니다.\"}");
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
        }
    }

    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
