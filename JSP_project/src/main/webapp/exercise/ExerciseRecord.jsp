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
body {
	font-family: Arial, sans-serif;
	line-height: 1.6;
	margin: 0;
	padding: 0;
	background-color: #f4f4f4;
}

.exercise-page {
	max-width: 1200px;
	margin: 0 auto;
	padding: 20px;
	background-color: #fff;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	padding-top: 200px;
}

.exercise-page h2 {
	color: #333;
	margin-top: 0; /* 헤더 아래 여백 */
}

.content-wrapper {
	display: flex;
	gap: 20px;
	margin-top: 20px;
}

.calendar-wrapper, .exercise-form-wrapper, .calorie-calculator {
	flex: 1;
	min-width: 0;
}

.calendar {
	width: 100%;
	border: 1px solid #ddd;
	border-radius: 8px;
	overflow: hidden;
}

.calendar-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px;
	background-color: #f0f0f0;
}

.calendar table {
	width: 100%;
	border-collapse: collapse;
}

.calendar th, .calendar td {
	text-align: center;
	padding: 10px;
	border: 1px solid #ddd;
}

.calendar td:hover {
	background-color: #f0f0f0;
	cursor: pointer;
}

.exercise-input textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	resize: vertical;
}

.form-actions {
	display: flex;
	justify-content: flex-end;
	margin-top: 10px;
}

.form-actions button {
	padding: 10px 20px;
	margin-left: 10px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.form-actions button[type="submit"] {
	background-color: #4CAF50;
	color: white;
}

.form-actions button[type="reset"] {
	background-color: #f44336;
	color: white;
}

@media ( max-width : 768px) {
	.content-wrapper {
		flex-direction: column;
	}
	.calendar-wrapper, .exercise-form-wrapper {
		width: 100%;
	}
}

.calorie-calculator {
	display: flex; flex-direction : column; padding : 20px; border : 1px
	solid #ddd;
	border-radius: 8px;
	flex-direction: column;
	margin-top: 30px;
	padding: 20px;
	border: 1px solid #ddd;
}

.calorie-calculator h3 {
            margin-top: 0;
        }

.exercise-type, #cardioOptions, #strengthOptions, .input-group {
	margin-bottom: 15px;
}

.input-group label {
            display: block;
            margin-bottom: 5px;
        }

label {
	display: inline-block;
	margin-right: 10px;
}

input[type="number"] {
	width: 80px;
	padding: 5px;
	margin-bottom: 10px;
}

#result {
	font-weight: bold;
	margin-top: 20px;
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