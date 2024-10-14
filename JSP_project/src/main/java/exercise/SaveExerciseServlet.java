package exercise;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/exercise/SaveExerciseServlet")
public class SaveExerciseServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        System.out.println("SaveExerciseServlet: doPost method started");
        System.out.println("Received parameters:");
        System.out.println("exercise: " + request.getParameter("exercise"));
        System.out.println("selectedDate: " + request.getParameter("selectedDate"));

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("SaveExerciseServlet: User not logged in");
            response.getWriter().write("로그인을 먼저 실행해주세요.");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String exercise = request.getParameter("exercise");
        if (exercise != null) {
            exercise = exercise.trim();
        } else {
            exercise = "";
        }

        String selectedDate = request.getParameter("selectedDate");
        if (selectedDate == null || selectedDate.trim().isEmpty()) {
            selectedDate = LocalDate.now().format(DateTimeFormatter.ISO_DATE);
        }

        System.out.println("SaveExerciseServlet: Processed parameters:");
        System.out.println("userId: " + userId);
        System.out.println("exercise: " + exercise);
        System.out.println("selectedDate: " + selectedDate);

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", "root", "1234");
            String sql = "INSERT INTO tblExerciseRecords (userId, exercise, erDate) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE exercise = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, exercise);
            pstmt.setString(3, selectedDate);
            pstmt.setString(4, exercise);

            System.out.println("SaveExerciseServlet: Executing SQL: " + sql);
            System.out.println("SaveExerciseServlet: SQL parameters: " + userId + ", " + exercise + ", " + selectedDate);

            int result = pstmt.executeUpdate();
            if(result > 0) {
                System.out.println("SaveExerciseServlet: Exercise saved successfully");
                response.getWriter().write("운동 기록이 성공적으로 저장되었습니다.");
            } else {
                System.out.println("SaveExerciseServlet: Failed to save exercise");
                response.getWriter().write("운동 기록 저장에 실패하였습니다.");
            }
        } catch(Exception e) {
            System.out.println("SaveExerciseServlet: Exception occurred: " + e.getMessage());
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
        System.out.println("SaveExerciseServlet: doPost method ended");
    }
}