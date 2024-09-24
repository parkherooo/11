package diet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class SaveDietServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	// 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            // 로그인하지 않은 경우
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script type=\"text/javascript\">");
            out.println("alert('로그인을 먼저 실행해주세요.');");
            out.println("location='login.jsp';");
            out.println("</script>");
            return;
        }
    	String userId = (String) session.getAttribute("userId");
        String breakfast = request.getParameter("breakfast");
        String lunch = request.getParameter("lunch");
        String dinner = request.getParameter("dinner");
        String calories = request.getParameter("calories");
        String selectedDate = request.getParameter("selectedDate");
        System.out.println("Received selectedDate: " + selectedDate);

        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime", "root", "1234");

            String sql = "INSERT INTO tblDietaryRecords (userId, breakfast, lunch, dinner, calorie, drDate) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, breakfast);
            pstmt.setString(3, lunch);
            pstmt.setString(4, dinner);
            pstmt.setInt(5, Integer.parseInt(calories));
            

            int result = pstmt.executeUpdate();
            if(result > 0) {
                response.getWriter().write("success");
            } else {
                response.getWriter().write("fail");
            }
        } catch(Exception e) {
        	e.printStackTrace();
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            String errorDetails = sw.toString();
            response.getWriter().write("Error: " + e.getMessage() + "\n" + errorDetails);
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
