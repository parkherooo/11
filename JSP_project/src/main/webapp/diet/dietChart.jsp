<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<%
    // 세션 확인
    if (session.getAttribute("userId") == null) {
        // JavaScript를 사용하여 알림을 표시하고 리다이렉트
        out.println("<script>");
        out.println("alert('로그인이 필요합니다.');");
        out.println("window.location.href='../login/logIn.jsp';");
        out.println("</script>");
        return; // 페이지 처리 중단
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주간 식단 차트</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
     <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #ffffff;
            padding-top: 2000px; /* 헤더의 높이에 따라 조정 */
        }

        .diet-page {
            max-width: 100px;
            margin: 2rem auto;
            padding: 0 1rem;
            background-color: #ffffff;
        }

        h2 {
            font-size: 2rem;
            margin-bottom: 1rem;
            padding-top: 240px; /* 기존 240px에서 조정 */
            clear: both;
            text-align: center;
        }

        #calorieChart {
            max-width: 800px;
            margin: 0 auto;
        }

        @media (max-width: 768px) {
            body {
                padding-top: 40px; /* 모바일에서 헤더 높이가 다를 경우 조정 */
            }
        }
    </style>
</head>
<body>
    <%@ include file="../main/header.jsp"%>
    
    <h2>주간 식단 차트</h2>
    <canvas id="calorieChart" width="1000" height="600"></canvas>

    <%!
    // 날짜를 하루 뒤로 조정하는 메서드
    public String adjustDate(String dateStr, SimpleDateFormat sdf) {
        try {
            Calendar tempCal = Calendar.getInstance();
            tempCal.setTime(sdf.parse(dateStr));
            tempCal.add(Calendar.DAY_OF_MONTH, 1);
            return sdf.format(tempCal.getTime());
        } catch (Exception e) {
            return dateStr;
        }
    }
    %>

    <%
        // 데이터베이스 연결 정보
        String dbUrl = "jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC";
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
        cal.add(Calendar.DAY_OF_MONTH, -7);
        String startDate = sdf.format(cal.getTime());

        // 데이터를 저장할 맵
        Map<String, Integer> calorieData = new LinkedHashMap<>();

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
                    String adjustedDate = adjustDate(date, sdf);
                    calorieData.put(adjustedDate, calorie);
                }
            }
        } catch (SQLException e) {
            out.println("<p>데이터베이스 오류: " + e.getMessage() + "</p>");
            e.printStackTrace();
            return;
        }

        // 7일 동안의 모든 날짜를 맵에 포함시키기 (데이터가 없는 날짜는 0으로)
        cal.setTime(sdf.parse(startDate));
        for (int i = 0; i < 7; i++) {
            String date = sdf.format(cal.getTime());
            String adjustedDate = adjustDate(date, sdf);
            if (!calorieData.containsKey(adjustedDate)) {
                calorieData.put(adjustedDate, 0);
            }
            cal.add(Calendar.DAY_OF_MONTH, 1);
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
                    max: 5000,
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