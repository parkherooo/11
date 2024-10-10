function selectDate(day) {
	const selectedDate = new Date(currentYear, currentMonth, day);
	const formattedDate = selectedDate.toISOString().split('T')[0];
	document.getElementById('selectedDate').value = formattedDate;
	document.querySelector('.diet-record h4').textContent = `${currentYear}년 ${currentMonth + 1}월 ${day}일의 식단`;
	
	console.log('Selected Date:', formattedDate);
	console.log('Hidden field value:', document.getElementById('selectedDate').value);
	loadDietData(formattedDate);
	
	
}

function loadDietData(date) {
	const userId = document.getElementById('userId').value;
	fetch(`GetDietServlet?userId=${userId}&selectedDate=${date}`)
		.then(response => response.json())
		.then(data => {
			if (data.diet) {
				document.getElementById('diet').value = data.diet;
				document.getElementById('calories').value = data.calories || '';
			} else {
				document.getElementById('diet').value = '';
				document.getElementById('calories').value = '';
			}
		})
		.catch(error => {
			console.error('Error:', error);
			alert('식단 정보를 불러오는 중 오류가 발생했습니다.');
		});
}

document.addEventListener('DOMContentLoaded', function() {
	const caloriesInput = document.getElementById('calories');
	    
	    // 입력 값이 변경될 때마다 정수로 반올림
	    caloriesInput.addEventListener('change', function() {
	        this.value = Math.round(this.value);
	    });

	    // 입력 중에도 소수점 입력을 방지
	    caloriesInput.addEventListener('input', function() {
	        this.value = this.value.replace(/\D/g, '');
	    });
		
	const form = document.getElementById('dietForm');
	if (form) {
		form.addEventListener('submit', function(e) {
			e.preventDefault();

			const formData = new FormData(this);
			console.log('Form Data:');

			// FormData 내용 로깅
			for (let [key, value] of formData.entries()) {
				console.log(key, value);
			}
			if (!formData.get('diet') || !formData.get('selectedDate') || !formData.get('calories')) {
				alert('모든 필드를 채워주세요.');
				return;
			}

			fetch('SaveDietServlet', {
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
				const dietTextarea = document.getElementById('diet');
				        if (dietTextarea) {
				            dietTextarea.addEventListener('input', calculateTotalCalories);
				        }
		});
	}
});

// 칼로리 계산 기능
function calculateTotalCalories() {
    const dietText = document.getElementById('diet').value;
    let totalCalories = 0;
    
    const calorieMatches = dietText.match(/\((\d+(?:\.\d+)?)kcal\)/g);
    if (calorieMatches) {
        totalCalories = calorieMatches.reduce((sum, match) => {
            const calories = parseFloat(match.replace(/[^\d.]/g, ''));
            return sum + (isNaN(calories) ? 0 : calories);
        }, 0);
    }

    // 반올림하여 정수로 변환
    totalCalories = Math.round(totalCalories);

    // 결과를 정수로 설정
    document.getElementById('calories').value = totalCalories;
}