<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fit Time - 하루 권장 칼로리</title>
<link rel="stylesheet" href="../css/main.css">
<style>
body {
	background-color: #ffffff;
}

main.diet-page {
	background-color: #ffffff;
	padding-top: 200px;
}

.diet-page {
	max-width: 1200px;
	margin: 2rem auto;
	padding: 0 1rem;
	background-color: #ffffff;
}

.diet-page h2 {
	font-size: 2rem;
	margin-bottom: 1rem;
}

.diet-nav {
	margin-bottom: 1rem;
}

.diet-nav a {
	text-decoration: none;
	color: #333;
	margin-right: 1rem;
}

.diet-nav a.active {
	color: #4CAF50;
	font-weight: bold;
	border-bottom: 2px solid #4CAF50;
}

.calorie-calc {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-top: 20px;
	gap: 2rem;
	background-color: #ffffff;
}

.human-figure {
	width: 30%;
	max-width: 250px;
	height: auto;
}

.calc-form {
	flex: 1;
	padding: 20px;
	border: 1px solid #000;
	border-radius: 8px;
	background-color: #ffffff;
}

.form-row {
	margin-bottom: 15px;
}

.checkbox-group {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
	gap: 10px;
}

.radio-group label {
	display: flex;
	align-items: center;
	flex-direction: row;
	margin-right: 15px;
}

.radio-group label span {
	margin-left: 5px;
}

.radio-group label {
	display: inline-flex;
	align-items: center;
	white-space: nowrap;
	margin-right: 15px;
}

/* 라디오 버튼 스타일 */
.radio-group input[type="radio"] {
	margin-left: 5px;
	 margin-top: 20px;
	vertical-align: middle;
}

.checkbox-group label, .form-row label {
	display: flex;
	align-items: center;
}

input[type="text"], input[type="number"] {
	width: 100%;
	padding: 8px;
	margin-top: 5px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

.submit-btn {
	background-color: #4CAF50;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	float: right;
}

.submit-btn:hover {
	background-color: #45a049;
}

.radio-group {
	display: flex;
	flex-wrap: wrap;
	gap: 15px;

}

.gender-group, .goal-group {
	justify-content: flex-start;
}

#recommendedCalories {
	font-weight: bold;
	color: #4CAF50;
}

@media ( max-width : 768px) {
	.calorie-calc {
		flex-direction: column;
	}
	.human-figure {
		width: 100%;
		max-width: 200px;
		margin: 0 auto 20px;
	}
	.calc-form {
		width: 100%;
	}
	.radio-group {
		flex-direction: column;
	}
	.radio-group label {
		margin-bottom: 10px;
	}
}
</style>
</head>
<body>
	<%@ include file="../main/header.jsp"%>

	<main class="diet-page">
		<h2>Diet</h2>
		<div class="calorie-calc">
			<img src="../img/human-figure.png" alt="인체 도형" class="human-figure">
			<form class="calc-form">
				<div class="form-row radio-group gender-group">
					<label>남성<input type="radio" name="gender" value="male"
						required></label> <label>여성<input type="radio"
						name="gender" value="female" required></label>
				</div>
				<div class="form-row radio-group activity-group">
					<label>거의 운동하지 않음<input type="radio" name="activity"
						value="1.2" required></label> <label>가벼운 운동<input
						type="radio" name="activity" value="1.375"></label> <label>중간
						운동<input type="radio" name="activity" value="1.55">
					</label> <label>강한 운동<input type="radio" name="activity"
						value="1.725"></label> <label>매우 강한 운동<input type="radio"
						name="activity" value="1.9"></label>
				</div>
				<div class="form-row">
					<label for="age">나이</label> <input type="number" id="age"
						name="age" required>
				</div>
				<div class="form-row">
					<label for="height">키(cm)</label> <input type="number" id="height"
						name="height" required>
				</div>
				<div class="form-row">
					<label for="weight">몸무게(kg)</label> <input type="number"
						id="weight" name="weight" required>
				</div>
				<div class="form-row radio-group goal-group">
					<label>체중 감량<input type="radio" name="goal" value="lose"
						required></label> <label>체중 유지<input type="radio"
						name="goal" value="maintain" required></label> <label>벌크 업<input
						type="radio" name="goal" value="gain" required></label>
				</div>
				<div class="form-row" id="targetWeightRow" style="display: none;">
					<label for="targetWeight">목표 몸무게 (kg)</label> <input type="number"
						id="targetWeight" name="targetWeight">
				</div>
				<div class="form-row">
					<label>하루 권장 칼로리 : </label> <span id="recommendedCalories"></span>
				</div>
				<button type="button" class="submit-btn"
					onclick="calculateCalories()">입력</button>
			</form>
		</div>
	</main>

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<script>
    $(document).ready(function() {
        $('input[name="goal"]').change(function() {
            if ($(this).val() === 'maintain') {
                $('#targetWeightRow').hide();
            } else {
                $('#targetWeightRow').show();
            }
        });
    });

    function calculateCalories() {
        let gender = $('input[name="gender"]:checked').val();
        let activity = parseFloat($('input[name="activity"]:checked').val());
        let age = parseInt($('#age').val());
        let height = parseInt($('#height').val());
        let weight = parseInt($('#weight').val());
        let goal = $('input[name="goal"]:checked').val();
        let targetWeight = parseInt($('#targetWeight').val());

        if (gender && activity && age && height && weight && goal && (goal === 'maintain' || targetWeight)) {
            let bmr;
            if (gender === 'male') {
                bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
            } else {
                bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
            }

            let maintenanceCalories = Math.round(bmr * activity);
            let recommendedCalories;

            switch(goal) {
                case 'lose':
                    // 주당 0.5kg 감량 목표 (1kg = 약 7700kcal)
                    let weightLossRate = 0.5;
                    let calorieDeficit = (weight - targetWeight) > 0 ? 3850 / 7 : 0; // 주당 3850kcal 감소
                    recommendedCalories = Math.max(1200, Math.round(maintenanceCalories - calorieDeficit));
                    break;
                case 'gain':
                    // 주당 0.25kg 증량 목표
                    let weightGainRate = 0.25;
                    let calorieSurplus = (targetWeight - weight) > 0 ? 1925 / 7 : 0; // 주당 1925kcal 증가
                    recommendedCalories = Math.round(maintenanceCalories + calorieSurplus);
                    break;
                default: // 'maintain'
                    recommendedCalories = maintenanceCalories;
            }

            $('#recommendedCalories').text(recommendedCalories + ' kcal');
        } else {
            $('#recommendedCalories').text('모든 항목을 입력해주세요.');
        }
    }

    // 입력 필드 변경 시 자동 계산
    $('#calorieForm input').on('change', calculateCalories);
    </script>

	<%@ include file="/chatbot/chatbot.jsp"%>
	<%@ include file="../main/footer.jsp"%>
</body>
</html>