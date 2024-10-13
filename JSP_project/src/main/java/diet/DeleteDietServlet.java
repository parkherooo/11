package diet;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/diet/DeleteDietServlet")
public class DeleteDietServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        System.out.println("DeleteDietServlet: doPost method started");

        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("DeleteDietServlet: User not logged in");
            response.getWriter().write("로그인을 먼저 실행해주세요.");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String selectedDate = request.getParameter("selectedDate");

        if (selectedDate == null || selectedDate.trim().isEmpty()) {
            System.out.println("DeleteDietServlet: selectedDate is missing");
            response.getWriter().write("삭제할 날짜를 선택해주세요.");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", "root", "1234");
            
            // 해당 날짜의 식단 데이터 삭제
            String sql = "DELETE FROM tblDietaryRecords WHERE userId = ? AND drDate = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, selectedDate);

            System.out.println("DeleteDietServlet: Executing SQL: " + sql);
            System.out.println("DeleteDietServlet: SQL parameters: " + userId + ", " + selectedDate);

            int result = pstmt.executeUpdate();
            if(result > 0) {
                System.out.println("DeleteDietServlet: Diet deleted successfully");
                response.getWriter().write("식단이 성공적으로 삭제되었습니다.");
            } else {
                System.out.println("DeleteDietServlet: No record found to delete");
                response.getWriter().write("삭제할 식단 기록이 없습니다.");
            }
        } catch(Exception e) {
            System.out.println("DeleteDietServlet: Exception occurred: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("오류가 발생했습니다: " + e.getMessage());
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException se) {
                se.printStackTrace();
            }
        }

        System.out.println("DeleteDietServlet: doPost method ended");
    }
}
