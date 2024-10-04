<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/exroutine.css">
<script>
function strength() {
    // '근력' 체크박스 상태 확인
    const isStrengthChecked = document.getElementById('strength').checked;

    // '무분할', '2분할', '3분할' 라디오 버튼 활성화/비활성화
    const radios = document.querySelectorAll('input[name="split"]');
    radios.forEach(radio => {
        radio.disabled = !isStrengthChecked;
    });
}

function cardio() {
    // '유산소'를 선택하면 라디오 버튼 비활성화 및 체크 해제
    const isCardioChecked = document.getElementById('cardio').checked;

    if (isCardioChecked) {
        const radios = document.querySelectorAll('input[name="split"]');
        radios.forEach(radio => {
            radio.disabled = true;  // 유산소 선택 시 모두 비활성화
            radio.checked = false;  // 선택 상태 초기화
        });
    }
}

function sendData() {
    const selectedRadio = document.querySelector('input[name="split"]:checked');
    const isCardioChecked = document.getElementById('cardio').checked; // '유산소' 선택 여부 확인

    if (isCardioChecked) {
        window.location.href = 'ExRoutineSelectServlet?split=cardio'; // 유산소로 redirect
    } else if (selectedRadio) {
        const splitValue = selectedRadio.value;
        window.location.href = 'ExRoutineSelectServlet?split=' + splitValue; // 분할 선택
    } else {
        alert("추천받을 루틴을 선택하세요."); // 선택하지 않았을 때
    }
}


</script>
</head>
<body class="exroutine-body">
    <p>하루의 운동 루틴을 랜덤으로 추천해드려요.</p>
    <div class="container">
        <div class="checkbox-group">
            <label for="strength"><input type="radio" id="strength" name="routine" onclick="strength()"> 근력</label>
            <label for="cardio"><input type="radio" id="cardio" name="routine" onclick="cardio()"> 유산소</label>
        </div>
		<hr>
        <div class="checkbox-group">
            <label for="nopart"><input type="radio" id="nopart" name="split" value="nopart" disabled> 무분할</label>
			<label for="twopart"><input type="radio" id="twopart" name="split" value="twopart" disabled> 2분할</label>
			<label for="threepart"><input type="radio" id="threepart" name="split" value="threepart" disabled> 3분할</label>
            
        </div>

        <button class="button" type="button" onclick="sendData()">추천 받기</button>
    </div>
<%@ include file="/chatbot/chatbot.jsp" %>    
</body>
</html>
