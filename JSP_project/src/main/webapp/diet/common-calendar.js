let currentYear, currentMonth;

function initCalendar() {
    const today = new Date();
	today.setHours(0, 0, 0, 0);
    currentYear = today.getFullYear();
    currentMonth = today.getMonth();
    updateCalendar();
    
    document.getElementById('prevMonth').addEventListener('click', () => changeMonth(-1));
    document.getElementById('nextMonth').addEventListener('click', () => changeMonth(1));
}

function updateCalendar() {
    const calendarTitle = document.getElementById('calendarTitle');
    const calendarBody = document.getElementById('calendarBody');
    
    calendarTitle.textContent = `${currentYear}년 ${currentMonth + 1}월`;
    
    const firstDay = new Date(currentYear, currentMonth, 1);
    const lastDay = new Date(currentYear, currentMonth + 1, 0);
    
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

document.addEventListener('DOMContentLoaded', initCalendar);