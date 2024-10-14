<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fit Time - Exercise</title>
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

/* 메인 컨텐츠 영역 스타일 */
.exercise-page {
    max-width: 100%;
    margin: 2rem auto;
    padding: 0 2rem;
    background-color: #ffffff;
}

/* 메인 제목 스타일 */
.exercise-page h2 {
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
    max-width: 1600px; /* 전체 콘텐츠의 최대 너비 설정 */
    margin: 0 auto; /* 중앙 정렬 */
}

.calendar-wrapper, .exercise-form-wrapper {
    background-color: #ffffff;
    border-radius: 8px;
    padding: 2rem;
    border: 1px solid #000;
    box-shadow: none;
    width: calc(50% - 2rem); /* 캘린더와 운동 입력 폼의 너비 */
}

.calendar-wrapper {
    flex: 0.75;
}

.exercise-form-wrapper {
    flex: 1.5;
    width: 60%;
}

.calendar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

/* 캘린더 헤더 버튼 스타일 */
.calendar-header button {
    background: none;
    border: none;
    font-size: 1.2rem;
    cursor: pointer;
}

/* 캘린더 테이블 스타일 */
.calendar table {
    width: 100%;
    border-collapse: collapse;
}

/* 캘린더 셀 스타일 */
.calendar th, .calendar td {
    text-align: center;
    padding: 0.5rem;
    border: 1px solid #e0e0e0;
}

/* 활성화된 캘린더 셀 스타일 */
.calendar td.active {
    background-color: #4CAF50;
    color: white;
}

/* 선택 가능한 캘린더 셀 스타일 */
.calendar td.selectable {
    cursor: pointer;
}

/* 선택 가능한 캘린더 셀 호버 스타일 */
.calendar td.selectable:hover {
    background-color: #f0f0f0;
}

/* 선택된 캘린더 셀 스타일 */
.calendar td.selected {
    background-color: #4CAF50;
    color: white;
}

/* 운동 기록 제목 스타일 */
.exercise-record h4 {
    margin-bottom: 1rem;
}

/* 운동 입력 영역 스타일 */
.exercise-input {
    margin-bottom: 1rem;
}

.exercise-input label {
    display: block;
    margin-bottom: 0.5rem;
}

.exercise-input textarea {
    width: 100%;
    height: 60px;
    width: 600px;
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    resize: none;
}

/* 폼 액션 버튼 영역 스타일 */
.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
}

/* 폼 액션 버튼 공통 스타일 */
.form-actions button {
    padding: 0.5rem 2rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

/* 제출 버튼 스타일 */
.form-actions button[type="submit"] {
    background-color: #4CAF50;
    color: white;
}

/* 리셋 버튼 스타일 */
.form-actions button[type="reset"] {
    background-color: #f44336;
    color: white;
}

@media (max-width: 768px) {
    .content-wrapper {
        flex-direction: column;
    }
    .calendar-wrapper, .exercise-form-wrapper {
        width: 100%;
    }
}
</style>
</head>
<body>
	<%@ include file="../main/header.jsp"%>

	<main class="exercise-page">
		<h2>Exercise</h2>
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
								<th>Su</th>
								<th>Mo</th>
								<th>Tu</th>
								<th>We</th>
								<th>Th</th>
								<th>Fr</th>
								<th>Sa</th>
							</tr>
						</thead>
						<tbody id="calendarBody"></tbody>
					</table>
				</div>
			</div>
			<div class="exercise-form-wrapper">
				<form class="exercise-record" id="exerciseForm">
					<h4>오늘의 운동 루틴</h4>
					<input type="hidden" id="userId" name="userId"
						value="<%=session.getAttribute("userId")%>"> <input
						type="hidden" id="selectedDate" name="selectedDate" value="">
					<div class="exercise-input">
						<label for="exercise">운동 내용:</label>
						<textarea id="exercise" name="exercise" rows="10" maxlength="500"
							placeholder="오늘 수행한 운동을 자유롭게 기록해주세요. (최대 500자)"></textarea>
					</div>
					<div class="form-actions">
						<button type="reset">취소</button>
						<button type="submit">저장</button>
					</div>
				</form>
			</div>
		</div>
		<div class="calorie-calculator">
			<h3>칼로리 계산기</h3>
			<div class="exercise-type">
				<label><input type="radio" name="exerciseType"
					value="cardio"> 유산소</label> <label><input type="radio"
					name="exerciseType" value="strength"> 무산소</label>
			</div>

			<div id="cardioOptions" style="display: none;">
				<label><input type="radio" name="cardioType" value="walking">
					걷기</label> <label><input type="radio" name="cardioType"
					value="running"> 뛰기</label> <label><input type="radio"
					name="cardioType" value="swimming"> 수영</label> <label><input
					type="radio" name="cardioType" value="cycling"> 자전거</label>
			</div>

			<div id="strengthOptions" style="display: none;">
				<label><input type="radio" name="strengthType" value="low">
					저강도</label> <label><input type="radio" name="strengthType"
					value="medium"> 중강도</label> <label><input type="radio"
					name="strengthType" value="high"> 고강도</label>
			</div>

			<div class="input-group">
				<label>키 (cm): <input type="number" id="height" min="1"
					max="300"></label> <label>체중 (kg): <input type="number"
					id="weight" min="1" max="500"></label> <label>운동 시간 (분): <input
					type="number" id="duration" min="1" max="1440"></label>
			</div>

			<div id="result">
				<p>
					오늘 소모한 칼로리: <span id="calories">0</span> kcal
				</p>
			</div>
		</div>
	</main>

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script src="../diet/common-calendar.js"></script>
	<script src="../exercise/exercise-calendar.js"></script>
	<script>
document.addEventListener('DOMContentLoaded', function() {
    const exerciseTypeRadios = document.querySelectorAll('input[name="exerciseType"]');
    const cardioOptions = document.getElementById('cardioOptions');
    const strengthOptions = document.getElementById('strengthOptions');
    const heightInput = document.getElementById('height');
    const weightInput = document.getElementById('weight');
    const durationInput = document.getElementById('duration');
    const caloriesSpan = document.getElementById('calories');

    exerciseTypeRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            if (this.value === 'cardio') {
                cardioOptions.style.display = 'block';
                strengthOptions.style.display = 'none';
            } else {
                cardioOptions.style.display = 'none';
                strengthOptions.style.display = 'block';
            }
            calculateCalories();
        });
    });

    [heightInput, weightInput, durationInput].forEach(input => {
        input.addEventListener('input', calculateCalories);
    });

    document.querySelectorAll('input[name="cardioType"], input[name="strengthType"]')
        .forEach(radio => {
            radio.addEventListener('change', calculateCalories);
        });

    function calculateCalories() {
        const height = parseFloat(heightInput.value);
        const weight = parseFloat(weightInput.value);
        const duration = parseFloat(durationInput.value);
        
        if (!height || !weight || !duration) {
            caloriesSpan.textContent = '0';
            return;
        }

        let caloriesPerMinute = 0;
        const exerciseType = document.querySelector('input[name="exerciseType"]:checked').value;
        
        if (exerciseType === 'cardio') {
            const cardioType = document.querySelector('input[name="cardioType"]:checked');
            if (cardioType) {
                switch (cardioType.value) {
                    case 'walking': caloriesPerMinute = 0.05 * weight; break;
                    case 'running': caloriesPerMinute = 0.1 * weight; break;
                    case 'swimming': caloriesPerMinute = 0.08 * weight; break;
                    case 'cycling': caloriesPerMinute = 0.07 * weight; break;
                }
            }
        } else {
            const strengthType = document.querySelector('input[name="strengthType"]:checked');
            if (strengthType) {
                switch (strengthType.value) {
                    case 'low': caloriesPerMinute = 0.03 * weight; break;
                    case 'medium': caloriesPerMinute = 0.05 * weight; break;
                    case 'high': caloriesPerMinute = 0.08 * weight; break;
                }
            }
        }

        const totalCalories = Math.round(caloriesPerMinute * duration);
        caloriesSpan.textContent = totalCalories;
    }
});
</script>


	<%@ include file="/chatbot/chatbot.jsp"%>
	<%@ include file="../main/footer.jsp"%>
</body>
</html>