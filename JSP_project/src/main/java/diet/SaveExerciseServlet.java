package diet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class SaveExerciseServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String exercise = request.getParameter("exercise");
        String selectedDate = request.getParameter("selectedDate");

        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime", "root", "1234");

            String sql = "INSERT INTO tblExerciseRecords (userId, exercise, erDate) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, exercise);
            pstmt.setDate(3, java.sql.Date.valueOf(selectedDate));

            int result = pstmt.executeUpdate();
            if(result > 0) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("fail");
            }
        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
        }
    }
}