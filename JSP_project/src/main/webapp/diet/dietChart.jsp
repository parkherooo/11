<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<%-- <%
    // 세션 체크
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉션
        return;
    }
%> --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주간/월간 식단 차트</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
	<%@ include file="../main/header.jsp"%>
	
    <h2>최근 7일간 칼로리 섭취량</h2>
    <canvas id="calorieChart" width="800" height="400"></canvas>

    <%
        // 데이터베이스 연결 정보
        String dbUrl = "jdbc:mysql://113.198.238.93/fittime?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPassword = "1234";

      if(userId == null) {
    	  out.println("<p>로그인이 필요합니다.</p>");
    	  return;
      }

        // 날짜 형식 지정
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        
        // 오늘 날짜
        String endDate = sdf.format(cal.getTime());
        
        // 7일 전 날짜
        cal.add(Calendar.DAY_OF_MONTH, -6);
        String startDate = sdf.format(cal.getTime());

        // 데이터를 저장할 맵
        Map<String, Integer> calorieData = new LinkedHashMap<>();

        // 7일 동안의 모든 날짜를 맵에 0으로 초기화
        for (int i = 0; i < 7; i++) {
            String date = sdf.format(cal.getTime());
            calorieData.put(date, 0); 
            cal.add(Calendar.DAY_OF_MONTH, 1);
        }

        // 데이터베이스에서 데이터 가져오기
        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT drDate, calorie FROM tblDietaryRecords WHERE userId = ? AND drDate BETWEEN ? AND ? ORDER BY drDate")) {
            
            pstmt.setString(1, userId);
            pstmt.setString(2, startDate);
            pstmt.setString(3, endDate);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String date = rs.getString("drDate");
                    int calorie = rs.getInt("calorie");
                    calorieData.put(date, calorie);
                }
            }
        } catch (SQLException e) {
        	out.println("<p>데이터베이스 오류: " + e.getMessage() + "</p>");
            e.printStackTrace();
            return;
        }

        // JSON 데이터 생성
        JSONArray labels = new JSONArray();
        JSONArray values = new JSONArray();

        for (Map.Entry<String, Integer> entry : calorieData.entrySet()) {
            labels.add(entry.getKey());
            values.add(entry.getValue());
        }
    %>

    <script>
    var ctx = document.getElementById('calorieChart').getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: <%= labels.toJSONString() %>,
            datasets: [{
                label: '칼로리 섭취량',
                data: <%= values.toJSONString() %>,
                backgroundColor: 'rgba(75, 192, 192, 0.6)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '칼로리 (kcal)'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: '날짜'
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: '최근 7일간 칼로리 섭취량'
                }
            },
            animation: {
                duration: 1500,
                easing: 'easeOutQuart'
            }
        }
    });
    </script>
    
    <%@ include file="/chatbot/chatbot.jsp"%>
	<%@ include file="../main/footer.jsp"%>
</body>
</html>