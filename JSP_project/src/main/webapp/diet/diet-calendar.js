function selectDate(day) {
    const selectedDate = new Date(currentYear, currentMonth, day);
    const formattedDate = selectedDate.toISOString().split('T')[0];
    document.getElementById('selectedDate').value = formattedDate;
    document.querySelector('.diet-record h4').textContent = `${currentYear}년 ${currentMonth + 1}월 ${day}일의 식단`;
    loadDietData(formattedDate);
}

function loadDietData(date) {
    const userId = document.getElementById('userId').value;
    fetch(`GetDietServlet?userId=${userId}&selectedDate=${date}`)
        .then(response => response.json())
        .then(data => {
            if(data.diet) {
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

document.getElementById('dietForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    
    fetch('SaveDietServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(result => {
        if(result === 'success') {
            alert('식단 기록이 저장되었습니다.');
        } else {
            alert('식단 기록 저장에 실패했습니다. 다시 시도해주세요.');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('오류가 발생했습니다. 다시 시도해주세요.');
    });
});

// 칼로리 계산 기능 (선택적)
function calculateTotalCalories() {
    const dietText = document.getElementById('diet').value;
    // 여기에 칼로리 계산 로직 구현
    // 예: 특정 키워드를 기반으로 대략적인 칼로리 계산
    let totalCalories = 0;
    // ... 계산 로직 ...
	const calorieMatches = dietText.match(/\((\d+(?:\.\d+)?)kcal\)/g);
	if(calorieMatches) {
		totalCalories = calorieMatches.reduce((sum, match) => {
			const calories = parseFloat(match.replace(/[^\d.]/g, ''));
			return sum + (isNaN(calories) ? 0 : calories);
		}, 0);
	}
	
    document.getElementById('calories').value = totalCalories.toFixed(1);
}


/*function displaySearchResults(results) {
    const resultsContainer = document.getElementById('searchResults');
    resultsContainer.innerHTML = '';
    results.forEach(food => {
        const foodItem = document.createElement('div');
        foodItem.textContent = `${food.name}: ${food.calories}kcal`;
        foodItem.onclick = () => addFoodToDiet(food);
        resultsContainer.appendChild(foodItem);
    });
}

function addFoodToDiet(food) {
    const dietTextarea = document.getElementById('diet');
    dietTextarea.value += `${food.name} (${food.calories}kcal)\n`;
    calculateTotalCalories();
}*/

// 이벤트 리스너 추가
/*document.getElementById('calories').addEventListener('input', calculateTotalCalories);
document.getElementById('searchButton').addEventListener('click', searchFood);*/