function selectDate(day) {
    const selectedDate = new Date(currentYear, currentMonth, day);
    const formattedDate = selectedDate.toISOString().split('T')[0];
    document.getElementById('selectedDate').value = formattedDate;
    document.querySelector('.exercise-record h4').textContent = `${currentYear}년 ${currentMonth + 1}월 ${day}일의 운동 루틴`;
    loadExerciseData(formattedDate);
}

function loadExerciseData(date) {
    const userId = document.getElementById('userId').value;
    fetch(`GetExerciseServlet?userId=${userId}&selectedDate=${date}`)
        .then(response => response.json())
        .then(data => {
            if(data.exercise) {
                document.getElementById('exercise').value = data.exercise;
            } else {
                document.getElementById('exercise').value = '';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('운동 정보를 불러오는 중 오류가 발생했습니다.');
        });
}

document.getElementById('exerciseForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    
    fetch('SaveExerciseServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(result => {
        if(result === 'success') {
            alert('운동 기록이 저장되었습니다.');
        } else {
            alert('운동 기록 저장에 실패했습니다. 다시 시도해주세요.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('오류가 발생했습니다. 다시 시도해주세요.');
    });
});