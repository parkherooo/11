// 현재 표시 중인 년도와 월을 저장하는 변수
let currentYear, currentMonth;

// 페이지 로드 시 실행되는 함수
window.onload = function() {
    const today = new Date();
    currentYear = today.getFullYear();
    currentMonth = today.getMonth();
    updateCalendar();
    
    // 이전 달, 다음 달 버튼에 이벤트 리스너 추가
    document.getElementById('prevMonth').addEventListener('click', () => changeMonth(-1));
    document.getElementById('nextMonth').addEventListener('click', () => changeMonth(1));
};

// 달력 업데이트 함수
function updateCalendar() {
    const calendarTitle = document.getElementById('calendarTitle');
    const calendarBody = document.getElementById('calendarBody');
    
    // 달력 제목 업데이트
    calendarTitle.textContent = `${currentYear}년 ${currentMonth + 1}월`;
    
    // 현재 월의 첫 날과 마지막 날 구하기
    const firstDay = new Date(currentYear, currentMonth, 1);
    const lastDay = new Date(currentYear, currentMonth + 1, 0);
    
    // 달력 본문 생성
    let dateString = '';
    let dayCount = 1;
    
    for (let i = 0; i < 6; i++) {
        dateString += '<tr>';
        for (let j = 0; j < 7; j++) {
            if ((i === 0 && j < firstDay.getDay()) || dayCount > lastDay.getDate()) {
                dateString += '<td></td>';
            } else {
                dateString += `<td class="selectable" onclick="selectDate(${dayCount})">${dayCount}</td>`;
                dayCount++;
            }
        }
        dateString += '</tr>';
        if (dayCount > lastDay.getDate()) break;
    }
    
    calendarBody.innerHTML = dateString;
}

// 월 변경 함수
function changeMonth(delta) {
    currentMonth += delta;
    if (currentMonth < 0) {
        currentMonth = 11;
        currentYear--;
    } else if (currentMonth > 11) {
        currentMonth = 0;
        currentYear++;
    }
    updateCalendar();
}

// 날짜 선택 함
function selectDate(day) {
    // 이전에 선택된 날짜의 클래스 제거
    const prevSelected = document.querySelector('.selected');
    if (prevSelected) {
        prevSelected.classList.remove('selected');
    }
    
	// 선택된 날짜를 hidden input에 설정
	    const selectedDate = new Date(currentYear, currentMonth, day);
		const formattedDate = selectedDate.toISOString().split('T')[0];
	    document.getElementById('selectedDate').value = formattedDate;

	    // 선택된 날짜 표시 (예: 폼의 제목 변경)
	    document.querySelector('.diet-record h4').textContent = `${currentYear}년 ${currentMonth + 1}월 ${day}일의 식단`;	
		
		// 선택된 날짜의 기존 식단 데이터를 불러오는 AJAX 요청
		   const userId = document.getElementById('userId').value; // 사용자 ID를 가져옵니다.
		   fetch(`GetDietServlet?userId=${userId}&selectedDate=${formattedDate}`)
		       .then(response => response.json())
		       .then(data => {
		           if(Object.keys(data).length > 0) {
		               // 데이터가 있으면 폼에 채웁니다.
		               document.getElementById('breakfast').value = data.breakfast || '';
		               document.getElementById('lunch').value = data.lunch || '';
		               document.getElementById('dinner').value = data.dinner || '';
		               document.getElementById('calories').value = data.calories || '';
		           } else {
		               // 데이터가 없으면 폼을 초기화합니다.
		               document.getElementById('breakfast').value = '';
		               document.getElementById('lunch').value = '';
		               document.getElementById('dinner').value = '';
		               document.getElementById('calories').value = '';
		           }
		       })
		       .catch(error => {
		           console.error('Error:', error);
		           alert('식단 정보를 불러오는 중 오류가 발생했습니다.');
		       });
	
	}

	// 폼 제출 처리
	document.querySelector('.diet-record').addEventListener('submit', function(e) {
	    e.preventDefault();
	    
	    const formData = new FormData(this);
	    
	    fetch('SaveDietServlet', {
	        method: 'POST',
	        body: formData
	    })
	    .then(response => response.text())
	    .then(result => {
	        if(result === 'success') {
	            alert('식단이 성공적으로 저장되었습니다.');
	        } else {
	            alert('식단 저장에 실패했습니다. 다시 시도해주세요.');
	        }
	    })
	    .catch(error => {
	        console.error('Error:', error);
	        alert('오류가 발생했습니다. 다시 시도해주세요.');
	    });
	});
