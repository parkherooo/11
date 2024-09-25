<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fit Time - Exercise</title>
    <link rel="stylesheet" href="diet-page.css">
</head>
<body>
    <header>
        <h1>Fit Time.<br><small>for your health</small></h1>
        <nav>
            <ul>
                <li><a href="#">Recipe</a></li>
                <li><a href="#">Diet</a></li>
                <li><a href="#" class="active">Exercise</a></li>
                <li><a href="#">Community</a></li>
                <li><a href="#">Notice</a></li>
            </ul>
        </nav>
        <button class="login-btn">Login</button>
    </header> 

    <main class="exercise-page">
        <h2>Exercise</h2>
        <div class="exercise-nav">
            <a href="#" class="active">오늘의 루틴</a>
            <a href="#">목표 설정</a>
            <a href="#">하루 루틴 추천</a>
        </div>
        
        <p>오늘의 운동 루틴을 기록해보세요.</p>
        
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
                        <tbody id="calendarBody">
                            <!-- JavaScript로 동적 생성됩니다 -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="exercise-form-wrapper">
                <form class="exercise-record" id="exerciseForm">
                    <h4>오늘의 운동 루틴</h4>
                    <input type="hidden" id="userId" name="userId" value="<%= session.getAttribute("userId") %>">
                    <input type="hidden" id="selectedDate" name="selectedDate" value="">
                    <div class="exercise-input">
                        <label for="exercise">운동 내용:</label>
                        <textarea id="exercise" name="exercise" rows="10"></textarea>
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="saveExercise()">저장</button>
                        <button type="reset">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="calendar-script.js"></script>
    <script>
    function saveExercise() {
        const exercise = document.getElementById('exercise').value;
        const selectedDate = document.getElementById('selectedDate').value;
        const userId = document.getElementById('userId').value;

        if (!exercise || !selectedDate) {
            alert('운동 내용과 날짜를 모두 입력해주세요.');
            return;
        }

        $.ajax({
            url: 'SaveExerciseServlet',
            type: 'POST',
            data: {
                userId: userId,
                exercise: exercise,
                selectedDate: selectedDate
            },
            success: function(response) {
                alert('운동 기록이 저장되었습니다.');
                // 필요하다면 여기에 추가 로직을 구현할 수 있습니다.
            },
            error: function(xhr, status, error) {
                alert('운동 기록 저장에 실패했습니다. 다시 시도해주세요.');
                console.error('Error:', error);
            }
        });
    }

    // 날짜 선택 시 해당 날짜의 운동 기록 불러오기
    function loadExercise(date) {
        const userId = document.getElementById('userId').value;
        $.ajax({
            url: 'GetExerciseServlet',
            type: 'GET',
            data: {
                userId: userId,
                selectedDate: date
            },
            success: function(response) {
                document.getElementById('exercise').value = response.exercise || '';
                document.getElementById('selectedDate').value = date;
            },
            error: function(xhr, status, error) {
                console.error('Error:', error);
            }
        });
    }

    // calendar-script.js의 selectDate 함수를 오버라이드
    function selectDate(day) {
        // 기존의 selectDate 로직
        // ...

        // 선택된 날짜의 운동 기록 불러오기
        const selectedDate = new Date(currentYear, currentMonth, day);
        const formattedDate = selectedDate.toISOString().split('T')[0];
        loadExercise(formattedDate);
    }
    </script>
</body>
</html>