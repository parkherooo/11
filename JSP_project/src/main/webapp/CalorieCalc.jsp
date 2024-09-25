<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fit Time - 하루 권장 칼로리</title>
    <link rel="stylesheet" href="diet-page.css">
    <style>
        .calorie-calc {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .human-figure {
            width: 200px;
        }
        .calc-form {
            width: 60%;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
        }
        .form-row {
            margin-bottom: 10px;
        }
        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
        }
        .checkbox-group label {
            margin-right: 15px;
        }
        input[type="text"], input[type="number"] {
            width: 100%;
            padding: 5px;
            margin-top: 5px;
        }
        .submit-btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            float: right;
        }
    </style>
</head>
<body>
    <header>
        <h1>Fit Time.<br><small>for your health</small></h1>
        <nav>
            <ul>
                <li><a href="#">Recipe</a></li>
                <li><a href="#" style="color: green;">Diet</a></li>
                <li><a href="#">Exercise</a></li>
                <li><a href="#">Community</a></li>
                <li><a href="#">Notice</a></li>
            </ul>
        </nav>
        <button class="login-btn">Login</button>
    </header>

    <main class="diet-page">
        <h2>Diet</h2>
        <div class="diet-nav">
            <a href="DietRecord.jsp">식단 기록</a>
            <a href="CalorieCalc.jsp" class="active">하루 권장 칼로리</a>
        </div>
        
        <div class="calorie-calc">
            <img src="human-figure.png" alt="인체 도형" class="human-figure">
            <form class="calc-form">
                <div class="form-row">
                    <label><input type="radio" name="gender" value="male" required> 남성</label>
                    <label><input type="radio" name="gender" value="female" required> 여성</label>
                </div>
                <div class="form-row checkbox-group">
                    <label><input type="radio" name="activity" value="1.2" required> 거의운동하지 않음</label>
                    <label><input type="radio" name="activity" value="1.375"> 가벼운 운동</label>
                    <label><input type="radio" name="activity" value="1.55"> 중간 운동</label>
                    <label><input type="radio" name="activity" value="1.725"> 강한 운동</label>
                    <label><input type="radio" name="activity" value="1.9"> 매우 강한 운동</label>
                </div>
                <div class="form-row">
                    <label for="age">나이</label>
                    <input type="number" id="age" name="age" required>
                </div>
                <div class="form-row">
                    <label for="height">키(cm)</label>
                    <input type="number" id="height" name="height" required>
                </div>
                <div class="form-row">
                    <label for="weight">몸무게(kg)</label>
                    <input type="number" id="weight" name="weight" required>
                </div>
                <div class="form-row">
        			<label><input type="radio" name="goal" value="lose" required> 체중 감량</label>
        			<label><input type="radio" name="goal" value="maintain" required> 체중 유지</label>
       				<label><input type="radio" name="goal" value="gain" required> 벌크 업</label>
  			  	</div>
                 <div class="form-row" id="targetWeightRow" style="display:none;">
        			<label for="targetWeight">목표 몸무게 (kg)</label>
       				<input type="number" id="targetWeight" name="targetWeight">
   				 </div>
                <div class="form-row">
                    <label>하루 권장 칼로리 : </label>
                    <span id="recommendedCalories"></span>
                </div>
                <button type="button" class="submit-btn" onclick="calculateCalories()">입력</button>
            </form>
        </div>
    </main>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
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
</body>
</html>