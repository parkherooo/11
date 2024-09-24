<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fit Time - Diet</title>
<link rel="stylesheet" href="diet-page.css">
<script src="calendar-script.js"></script>
</head>
<body>
	<header>
		<h1>Fit Time.</h1>
		<nav>
			<ul>
				<li><a href="#">Recipe</a></li>
				<li class="dropdown"><a href="#" class="active">Diet</a>
					<ul class="dropdown-content">
						<li><a href="#">식단 기록</a></li>
						<li><a href="#">하루 권장 칼로리</a></li>
					</ul></li>
				<li><a href="#">Exercise</a></li>
				<li><a href="#">Community</a></li>
				<li><a href="#">Notice</a></li>
			</ul>
		</nav>
		<button class="login-btn">Login</button>
	</header>

	<main class="diet-page">
		<h2>Diet</h2>
		<div class="content-wrapper">
			<div class="calendar-wrapper">
			<div class="calendar">
				<div class="calendar-header">
					<button id="prevMonth">&lt;</button>
					<h3 id="calendarTitle"></h3>
					<button id="nextMonth">&gt;</button>
				</div>
				<table>
					<thead>
						<tr>
							<th>Su</th>
							<th>Mo</th>
							<th>Tu</th>
							<th>We</th>
							<th>Th</th>
							<th>Fr</th>
							<th>Sa</th>
						</tr>
					</thead>
					<tbody id="calendarBody">
						<tr>
							<td colspan="7" style="text-align: center; padding: 20px;">
								캘린더를 불러오는데 문제가 발생했습니다. 페이지를 새로고침 하거나 나중에 다시 시도해주세요.</td>
						</tr>

					</tbody>
				</table>
			</div>
		</div>
		<div class="diet-form-wrapper">
			<form class="diet-record" action="SaveDietServlet" method="post">
				<h4>오늘의 식단</h4>
				<input type="hidden" id="userId" name="userId" value="">
				<input type="hidden" id="selectedDate" name="selectedDate" value="">
				<div class="meal-input">
					<label for="breakfast">아침식단:</label>
					<textarea id="breakfast" name="breakfast"></textarea>
				</div>
				<div class="meal-input">
					<label for="lunch">점심식단:</label>
					<textarea id="lunch" name="lunch"></textarea>
				</div>
				<div class="meal-input">
					<label for="dinner">저녁식단:</label>
					<textarea id="dinner" name="dinner"></textarea>
				</div>
				<div class="total-calories">
					<label for="calories">총 칼로리 계산:</label> <input type="number"
						id="calories" name="calories">
				</div>
				<div class="form-actions">
					<button type="reset">취소</button>
					<button type="submit">저장</button>
				</div>
			</form>
		</div>
		</div>
	</main>
	
	<%-- <script>
	// 페이지 로드 시 로그인 상태 확인
	window.onload = function() {
	    if (!isLoggedIn()) {
	        alert("로그인을 먼저 실행해주세요.");
	        window.location.href = 'login.jsp';
	    }
	}

	// 로그인 상태 확인 함수 (서버에서 세션 정보를 확인하는 API가 필요함)
	function isLoggedIn() {
	    // 여기에 서버에 로그인 상태를 확인하는 AJAX 요청을 구현
	    // 예시: return 서버응답;
	    return <%= session.getAttribute("userId") != null %>;
	}

	// 폼 제출 전 로그인 상태 재확인
	document.querySelector('.diet-record').addEventListener('submit', function(e) {
	    if (!isLoggedIn()) {
	        e.preventDefault();
	        alert("로그인 세션이 만료되었습니다. 다시 로그인해주세요.");
	        window.location.href = 'login.jsp';
	    }
	});
	</script> --%>

	<!-- <script src="script.js"></script> -->
</body>
</html>