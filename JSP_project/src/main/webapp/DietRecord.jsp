<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fit Time - Diet</title>
    <link rel="stylesheet" href="diet-page.css">
</head>
<body>
    <header>
        <h1>Fit Time.</h1>
        <nav>
            <ul>
                <li><a href="#">Recipe</a></li>
                <li class="dropdown">
                    <a href="#" class="active">Diet</a>
                    <ul class="dropdown-content">
                        <li><a href="#">식단 기록</a></li>
                        <li><a href="#">하루 권장 칼로리</a></li>
                    </ul>
                </li>
                <li><a href="#">Exercise</a></li>
                <li><a href="#">Community</a></li>
                <li><a href="#">Notice</a></li>
            </ul>
        </nav>
        <button class="login-btn">Login</button>
    </header>

    <main class="diet-page">
        <h2>Diet</h2>
        <div class="content-wrapper">
            <div class="calendar-wrapper">
                <div class="calendar">
                    <%
                        Calendar cal = Calendar.getInstance();
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 M월");
                        String currentMonth = sdf.format(cal.getTime());
                    %>
                    <h3><%= currentMonth %></h3>
                    <table>
                        <tr>
                            <th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th><th>Su</th>
                        </tr>
                        <%
                            cal.set(Calendar.DAY_OF_MONTH, 1);
                            int startDay = cal.get(Calendar.DAY_OF_WEEK);
                            int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
                            int dayCount = 1;

                            for (int i = 0; i < 6; i++) {
                                out.println("<tr>");
                                for (int j = 0; j < 7; j++) {
                                    if ((i == 0 && j < startDay - 1) || (dayCount > lastDay)) {
                                        out.println("<td></td>");
                                    } else {
                                        String cellClass = (dayCount == 18) ? " class=\"active\"" : "";
                                        out.println("<td" + cellClass + ">" + dayCount + "</td>");
                                        dayCount++;
                                    }
                                }
                                out.println("</tr>");
                                if (dayCount > lastDay) break;
                            }
                        %>
                    </table>
                </div>
            </div>
            <div class="diet-form-wrapper">
                <form class="diet-record">
                    <h4>오늘의 식단</h4>
                    <div class="meal-input">
                        <label for="breakfast">아침식단:</label>
                        <textarea id="breakfast" name="breakfast"></textarea>
                    </div>
                    <div class="meal-input">
                        <label for="lunch">점심식단:</label>
                        <textarea id="lunch" name="lunch"></textarea>
                    </div>
                    <div class="meal-input">
                        <label for="dinner">저녁식단:</label>
                        <textarea id="dinner" name="dinner"></textarea>
                    </div>
                    <div class="total-calories">
                        <label for="calories">총 칼로리 계산:</label>
                        <input type="number" id="calories" name="calories">
                    </div>
                    <div class="form-actions">
                        <button type="reset">취소</button>
                        <button type="submit">저장</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <!-- <script src="script.js"></script> -->
</body>
</html>