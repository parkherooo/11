// 알림 박스를 열고 닫는 기능
function toggleNotificationBox() {
    const notificationBox = document.getElementById('notificationBox');
    if (notificationBox.style.display === 'none' || notificationBox.style.display === '') {
        notificationBox.style.display = 'block';
        fetchNotifications();  // 알림 리스트를 가져와서 업데이트
    } else {
        notificationBox.style.display = 'none';
    }
}

// 알림 목록을 서버에서 가져오는 함수
function fetchNotifications() {
    fetch('/JSP_project/alarm/getNotifications')  // 서버에서 알림 데이터를 가져오는 경로
        .then(response => response.json())
        .then(data => {
            console.log("Received notifications:", data);  // 응답 데이터 확인
            updateNotificationList(data);  // 리스트에 알림 업데이트
        })
        .catch(error => console.error('Error fetching notifications:', error));
}

// 알림 목록을 업데이트하는 함수
function updateNotificationList(alarms) {
    const notificationList = document.getElementById('notificationList');
    
    // notificationList가 존재하는지 확인
    if (!notificationList) {
        console.error('notificationList element not found');
        return;
    }
    
    notificationList.innerHTML = '';  // 기존 알림 목록 초기화

    alarms.forEach(alarm => {
        const li = document.createElement('li');
        li.innerHTML = `
			<a href="../mypage/myPage.jsp?category=친구관리" class="alarm-a">
            <div class="notification-message">${alarm.content}</div>
			
			    <div class="notification-date">${new Date(alarm.a_date).toLocaleString()}</div>
		
            <div class="notification-close" onclick="removeNotification(${alarm.alarm_num}, this)">X</div>
			</a>
			 `;
        notificationList.appendChild(li);  // 새로운 알림 추가
    });

    console.log('Notification list updated with alarms:', alarms);
}

// 알림 삭제 기능 또는 확인 처리
function removeNotification(alarmNum, element) {
    // 서버에 알림 확인 처리 요청 (check_alarm을 1로 업데이트)
    fetch(`/JSP_project/alarm/updateAlarm?alarmNum=${alarmNum}`, {
        method: 'POST'
    })
    .then(response => response.text())
    .then(data => {
        if (data === 'success') {
            // 성공 시 알림 항목을 리스트에서 제거
            element.parentElement.remove();
        } else {
            alert('알림 처리에 실패했습니다.');
        }
    })
    .catch(error => console.error('Error:', error));
}


// 주기적으로 새로운 알림을 확인하는 함수
function checkNewAlarms() {
    setInterval(function() {
        fetch('/JSP_project/alarm/checkNewAlarms')
        .then(response => response.json())
        .then(data => {
            console.log("New alarms received:", data);
            const bellIcon = document.querySelector('.notification-bell');  // 벨 아이콘 선택

            if (data.length > 0) {
                updateNotificationList(data);  // 알림 목록을 업데이트
                bellIcon.classList.add('bell-with-notification');  // 알림이 있으면 색상 변경
            } else {
                bellIcon.classList.remove('bell-with-notification');  // 알림이 없으면 기본 색상으로 변경
            }
        })
        .catch(error => console.error('Error fetching new alarms:', error));
    }, 1000);  // 5초마다 알림 확인
}

