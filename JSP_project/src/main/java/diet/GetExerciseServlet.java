package diet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import org.json.simple.JSONObject;

public class GetExerciseServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String selectedDate = request.getParameter("selectedDate");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdb", "username", "password");

            String sql = "SELECT exercise FROM tblExerciseRecords WHERE userId = ? AND erDate = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));

            rs = pstmt.executeQuery();

            JSONObject result = new JSONObject();
            if(rs.next()) {
                result.put("exercise", rs.getString("exercise"));
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(result.toJSONString());

        } catch(Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("데이터를 불러오는 중 오류가 발생했습니다.");
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
}