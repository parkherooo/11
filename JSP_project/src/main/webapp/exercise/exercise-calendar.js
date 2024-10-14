// 전역 함수로 정의
function selectDate(day) {
    selectExerciseDate(day);
}

function selectExerciseDate(day) {
    const selectedDate = new Date(currentYear, currentMonth, day);
    selectedDate.setHours(0, 0, 0, 0);
    const formattedDate = selectedDate.toISOString().split('T')[0];
    document.getElementById('selectedDate').value = formattedDate;
    document.querySelector('.exercise-record h4').textContent = `${currentYear}년 ${currentMonth + 1}월 ${day}일의 운동 루틴`;
    
    console.log('Selected Date:', formattedDate);
    console.log('Hidden field value:', document.getElementById('selectedDate').value);
    loadExerciseData(formattedDate);
}

function loadExerciseData(date) {
    const userId = document.getElementById('userId').value;
    console.log('Loading exercise data for userId:', userId, 'and date:', date);
    
    fetch(`GetExerciseServlet?userId=${encodeURIComponent(userId)}&selectedDate=${encodeURIComponent(date)}`)
        .then(response => response.text())
        .then(text => {
            console.log('Server response:', text);
            return JSON.parse(text);
        })
        .then(data => {
            const exerciseTextarea = document.getElementById('exercise');

            if (data.exercise) {
                exerciseTextarea.value = data.exercise;
                exerciseTextarea.placeholder = '';
            } else {
                exerciseTextarea.value = '';
                exerciseTextarea.placeholder = "운동 루틴을 자유롭게 기입해 주세요";
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('운동 정보를 불러오는 중 오류가 발생했습니다: ' + error.message);
        });
}

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('exerciseForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            console.log('Form Data:');

            for (let [key, value] of formData.entries()) {
                console.log(key, value);
            }
            if (!formData.get('exercise') || !formData.get('selectedDate')) {
                alert('모든 필드를 채워주세요.');
                return;
            }

            fetch('SaveExerciseServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(formData)
            })
                .then(response => response.text())
                .then(message => {
                    alert(message);
                    if (message.includes("성공적으로 저장")) {
                        this.reset();
                        updateCalendar();
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('오류가 발생했습니다. 다시 시도해주세요.');
                });
        });
    }
});

function deleteExercise() {
    const selectedDate = document.getElementById('selectedDate').value;
    const userId = document.getElementById('userId').value;

    if (!selectedDate) {
        alert('삭제할 날짜가 선택되지 않았습니다.');
        return;
    }

    if (confirm(`운동 기록을 삭제하시겠습니까?`)) {
        fetch(`DeleteExerciseServlet?userId=${encodeURIComponent(userId)}&selectedDate=${encodeURIComponent(selectedDate)}`, {
            method: 'POST',
        })
        .then(response => response.text())
        .then(message => {
            alert(message);
            if (message.includes("성공적으로 삭제")) {
                document.getElementById('exercise').value = '';
                updateCalendar();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('운동 기록을 삭제하는 중 오류가 발생했습니다. 다시 시도해주세요.');
        });
    }
}