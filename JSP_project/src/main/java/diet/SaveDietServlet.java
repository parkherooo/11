package diet;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;
import org.json.simple.JSONObject;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.ZoneId;

@WebServlet("/diet/SaveDietServlet")
public class SaveDietServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
    	System.out.println("SaveDietServlet: doPost method started"); // 디버깅 로그
        System.out.println("Received parameters:");
        System.out.println("diet: " + request.getParameter("diet"));
        System.out.println("selectedDate: " + request.getParameter("selectedDate"));
        System.out.println("calories: " + request.getParameter("calories"));

         
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("SaveDietServlet: User not logged in"); // 디버깅 로그
            response.getWriter().write("로그인을 먼저 실행해주세요.");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String diet = request.getParameter("diet");
        if (diet != null) {
            diet = diet.trim();
        } else {
            diet = ""; // 빈 문자열로 설정
        }

        String selectedDate = request.getParameter("selectedDate");
        if (selectedDate != null) {
            selectedDate = selectedDate.trim();
        } else {
            selectedDate = LocalDate.now().format(DateTimeFormatter.ISO_DATE); // 현재 날짜로 설정
        }

        String caloriesParam = request.getParameter("calories");
        if (caloriesParam != null) {
            caloriesParam = caloriesParam.trim();
        } else {
            caloriesParam = "0"; // 기본값 0으로 설정
        }

        String sugarParam = request.getParameter("sugar");
        if (sugarParam != null) {
            sugarParam = sugarParam.trim();
        } else {
            sugarParam = "0"; // 기본값 0으로 설정
        }

        String carbohydrateParam = request.getParameter("carbohydrate");
        if (carbohydrateParam != null) {
            carbohydrateParam = carbohydrateParam.trim();
        } else {
            carbohydrateParam = "0"; // 기본값 0으로 설정
        }

        String proteinParam = request.getParameter("protein");
        if (proteinParam != null) {
            proteinParam = proteinParam.trim();
        } else {
            proteinParam = "0"; // 기본값 0으로 설정
        }

        String fatParam = request.getParameter("fat");
        if (fatParam != null) {
            fatParam = fatParam.trim();
        } else {
            fatParam = "0"; // 기본값 0으로 설정
        }
        
        float sugar, carbohydrate, protein, fat;
        try {
            sugar = Float.parseFloat(sugarParam);
            carbohydrate = Float.parseFloat(carbohydrateParam);
            protein = Float.parseFloat(proteinParam);
            fat = Float.parseFloat(fatParam);
        } catch (NumberFormatException e) {
            System.out.println("SaveDietServlet: Invalid nutrient format");
            response.getWriter().write("영양 정보는 숫자로 입력해주세요.");
            return;
        }

        System.out.println("SaveDietServlet: Received parameters:"); // 디버깅 로그
        System.out.println("userId: " + userId);
        System.out.println("diet: " + diet);
        System.out.println("selectedDate: " + selectedDate);
        System.out.println("calories: " + caloriesParam);

        int calorie; 
        try {
            if (caloriesParam == null || caloriesParam.trim().isEmpty()) {
                System.out.println("SaveDietServlet: Calories parameter is null or empty"); // 디버깅 로그
                response.getWriter().write("칼로리 값이 입력되지 않았습니다.");
                return;
            }
            calorie = Integer.parseInt(caloriesParam);
        } catch (NumberFormatException e) {
            System.out.println("SaveDietServlet: Invalid calorie format: " + caloriesParam); // 디버깅 로그
            response.getWriter().write("칼로리는 숫자로 입력해주세요.");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC", "root", "1234");
            String sql = "INSERT INTO tblDietaryRecords (userId, diet, calorie, drDate, sugar, carbohydrate, protein, fat) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, diet);
            pstmt.setInt(3, calorie);
            pstmt.setString(4, selectedDate);
            pstmt.setFloat(5, sugar);
            pstmt.setFloat(6, carbohydrate);
            pstmt.setFloat(7, protein);
            pstmt.setFloat(8, fat);

            System.out.println("SaveDietServlet: Executing SQL: " + sql); // 디버깅 로그
            System.out.println("SaveDietServlet: SQL parameters: " + userId + ", " + diet + ", " + calorie + ", " + selectedDate);

            int result = pstmt.executeUpdate();
            if(result > 0) {
                System.out.println("SaveDietServlet: Diet saved successfully"); // 디버깅 로그
                response.getWriter().write("식단이 성공적으로 저장되었습니다.");
            } else {
                System.out.println("SaveDietServlet: Failed to save diet"); // 디버깅 로그
                response.getWriter().write("식단 저장에 실패하였습니다.");
            }
        } catch(Exception e) {
            System.out.println("SaveDietServlet: Exception occurred: " + e.getMessage()); // 디버깅 로그
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
        System.out.println("SaveDietServlet: doPost method ended"); // 디버깅 로그
    }
}