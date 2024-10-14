<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Friend's Diet</title>
    <link rel="stylesheet" href="../css/main.css">
    <style>
    
        nav ul li .dropdown-menu {
    top: calc(100% + 1px) !important; /* 드롭다운 메뉴 위치 조정 */
    margin-top: 10px !important;
}
body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    color: #333;
    background-color: #ffffff !important;
}

.diet-page {
    max-width: 100%;
    margin: 2rem auto;
    padding: 0 2rem;
    background-color: #ffffff;
}

.diet-page h2 {
    font-size: 2rem;
    margin-bottom: 1rem;
    padding-top: 240px;
    clear: both;
}

.content-wrapper {
    display: flex;
    justify-content: space-between;
    gap: 2rem;
    width: 100%;
    max-width: 1600px;
    margin: 0 auto;
}

.calendar-wrapper, .diet-form-wrapper {
    background-color: #ffffff;
    border-radius: 8px;
    padding: 2rem;
    border: 1px solid #000;
    box-shadow: none;
}

.calendar-wrapper {
    flex: 0.75;
    width: calc(40% - 1rem);
}

.diet-form-wrapper {
    flex: 1.25;
    width: calc(60% - 1rem);
}

.calendar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

.calendar-header button {
    background: none;
    border: none;
    font-size: 1.2rem;
    cursor: pointer;
}

.calendar table {
    width: 100%;
    border-collapse: collapse;
}

.calendar th, .calendar td {
    text-align: center;
    padding: 0.5rem;
    border: 1px solid #e0e0e0;
}

.calendar td.selectable {
    cursor: pointer;
}

.calendar td.selectable:hover {
    background-color: #f0f0f0;
}

.calendar td.selected {
    background-color: #4CAF50;
    color: white;
}

.diet-record h4 {
    margin-bottom: 1rem;
}

.meal-input {
    margin-bottom: 1rem;
}

.meal-input label {
    display: block;
    margin-bottom: 0.5rem;
}

.meal-input textarea {
    width: 100%;
    height: 150px;
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    resize: none;
}

.total-calories {
    display: flex;
    align-items: center;
    margin-bottom: 1rem;
}

.total-calories label {
    margin-right: 10px;
}

.total-calories input {
    width: 100px;
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin-right: 5px;
}

.total-calories span {
    font-size: 15px;
    color: #333;
}

@media (max-width: 768px) {
    .content-wrapper {
        flex-direction: column;
    }
    
    .calendar-wrapper, .diet-form-wrapper {
        width: 100%;
    }
}
</style>
</head>
<body>
    <%@ include file="../main/header.jsp"%>

    <main class="diet-page">
        <h2>Friend's Diet</h2>
        <div class="content-wrapper">
            <div class="calendar-wrapper">
                <div class="calendar">
                    <div class="calendar-header">
                        <button id="prevMonth">&lt;</button>
                        <h3 id="calendarTitle"></h3>
                        <button id="nextMonth">&gt;</button>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Su</th><th>Mo</th><th>Tu</th><th>We</th><th>Th</th><th>Fr</th><th>Sa</th>
                            </tr>
                        </thead>
                        <tbody id="calendarBody"></tbody>
                    </table>
                </div>
            </div>
            <div class="diet-form-wrapper">
                <div class="diet-record">
                    <h4>오늘의 식단</h4>
                    <input type="hidden" id="friendId" name="friendId" value="<%= java.net.URLEncoder.encode(request.getParameter("friendId"), "UTF-8") %>">
                    <input type="hidden" id="selectedDate" name="selectedDate" value="">
                    <div class="meal-input">
                        <label for="diet">오늘의 식단:</label>
                        <textarea id="diet" name="diet" rows="6" readonly></textarea>
                    </div>
                    <div class="total-calories">
                        <label for="calories">총 칼로리:</label>
                        <input type="number" id="calories" name="calories" readonly>
                        <span>kcal</span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/chatbot/chatbot.jsp"%>
    <%@ include file="../main/footer.jsp"%>

     <script src="../diet/common-calendar.js"></script>
    <script src="../diet/diet-calendar.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        initCalendar();
        const today = new Date().toISOString().split('T')[0];
        loadDietData(today);
    });
</script>

</body>
</html>