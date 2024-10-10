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
<link rel="stylesheet" href="../css/main.css">
<style>

/* 	main.diet-page {
    padding: 2rem 0; /* 상하 여백 추가 */
}
* /
body {
	font-family: Arial, sans-serif;
	line-height: 1.6;
	color: #333;
	background-color: #ffffff; /* 흰색으로 변경 */
}

/* 메인 컨텐츠 영역 스타일 */
.diet-page {
	max-width: 1200px;
	margin: 2rem auto;
	padding: 0 1rem;
	background-color: #ffffff;
}

/* 메인 제목 스타일 */
.diet-page h2 {
	font-size: 2rem;
	margin-bottom: 1rem;
	padding-top: 240px;
	clear: both;
}

.content-wrapper {
	display: flex;
	justify-content: space-between;
	gap: 2rem;
	width: 100%;
	max-width: 1200px; /* 전체 콘텐츠의 최대 너비 설정 */
	margin: 0 auto; /* 중앙 정렬 */
}

.calendar-wrapper, .diet-form-wrapper {
	background-color: #ffffff;
	border-radius: 8px;
	padding: 1rem;
	border: 1px solid #000;
	box-shadow: none;
	width: 48%; /* 캘린더와 식단 입력 폼의 너비 */
}

.calendar-wrapper {
	flex: 0.75;
}

.diet-form-wrapper {
	flex: 1.25;
}

.food-search {
	width: 100%; /* 식품 검색 섹션 전체 너비 사용 */
	margin-top: 20px;
}

.search-container {
	display: flex;
	align-items: center;
	gap: 10px; /* 입력 필드와 버튼 사이의 간격 */
}

.calendar-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 1rem;
}

/* 캘린더 헤더 버튼 스타일 */
.calendar-header button {
	background: none;
	border: none;
	font-size: 1.2rem;
	cursor: pointer;
}

/* 캘린더 테이블 스타일 */
.calendar table {
	width: 100%;
	border-collapse: collapse;
}

/* 캘린더 셀 스타일 */
.calendar th, .calendar td {
	text-align: center;
	padding: 0.5rem;
	border: 1px solid #e0e0e0;
}

/* 활성화된 캘린더 셀 스타일 */
.calendar td.active {
	background-color: #4CAF50;
	color: white;
}

/* 선택 가능한 캘린더 셀 스타일 */
.calendar td.selectable {
	cursor: pointer;
}

/* 선택 가능한 캘린더 셀 호버 스타일 */
.calendar td.selectable:hover {
	background-color: #f0f0f0;
}

/* 선택된 캘린더 셀 스타일 */
.calendar td.selected {
	background-color: #4CAF50;
	color: white;
}

/* 다이어트 기록 제목 스타일 */
.diet-record h4 {
	margin-bottom: 1rem;
}

/* 식사 입력 영역 스타일 */
.meal-input {
	margin-bottom: 1rem;
}

.meal-input label {
	display: block;
	margin-bottom: 0.5rem;
}

.meal-input textarea {
	width: calc(100% - 18px);
	height: 60px;
	padding: 0.5rem;
	border: 1px solid #ddd;
	border-radius: 4px;
	resize: none;
}

/* 총 칼로리 입력 영역 스타일 */
.total-calories {
	display: flex;
	align-items: center;
	margin-bottom: 1rem;
}

.total-calories label {
	margin-right: 10px;
}

.total-calories input {
	width: 100px;
	padding: 0.5rem;
	border: 1px solid #ddd;
	border-radius: 4px;
	margin-right: 5px;
}

.total-calories span {
	font-size: 15px;
	color: #333;
}

/* 폼 액션 버튼 영역 스타일 */
.form-actions {
	display: flex;
	justify-content: flex-end;
	gap: 1rem;
}

/* 폼 액션 버튼 공통 스타일 */
.form-actions button {
	padding: 0.5rem 2rem;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

/* 제출 버튼 스타일 */
.form-actions button[type="submit"] {
	background-color: #4CAF50;
	color: white;
}

/* 리셋 버튼 스타일 */
.form-actions button[type="reset"] {
	background-color: #f0f0f0;
	color: #333;
}

#searchResults table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 20px;
	border: 1px solid #ddd; /* 테이블 외곽선 추가 */
}

#searchResults th, #searchResults td {
	border: 1px solid #ddd; /* 셀 테두리 추가 */
	padding: 10px;
	text-align: left;
}

#searchResults th {
	background-color: #f2f2f2;
	font-weight: bold;
}

#searchResults tr:nth-child(even) {
	background-color: #f9f9f9;
}

#searchResults tr:hover {
	background-color: #f5f5f5;
}

#foodSearchInput {
	flex-grow: 1;
	padding: 10px;
}

#searchButton {
	padding: 10px;
	background-color: #4CAF50;
	color: white;
	border: none;
	cursor: pointer;
	white-space: nowrap;
}

#searchButton:hover {
	background-color: #45a049;
}

.form-actions button[type="reset"] {
	background-color: #f44336;
	color: white;
}

@media ( max-width : 768px) {
	.content-wrapper {
		flex-direction: column;
	}
}
</style>
</head>
<body>
	<%@ include file="../main/header.jsp"%>

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
				<form class="diet-record" id="dietForm" method="post">
					<h4>오늘의 식단</h4>
					<input type="hidden" id="userId" name="userId"
						value="<%=session.getAttribute("userId")%>"> <input
						type="hidden" id="selectedDate" name="selectedDate" value="">
					<input type="hidden" id="sugar" name="sugar" value="0"> 		
					<input type="hidden" id="carbohydrate" name="carbohydrate" value="0">
					<input type="hidden" id="protein" name="protein" value="0">
					<input type="hidden" id="fat" name="fat" value="0">
					<div class="meal-input">
						<label for="diet">오늘의 식단:</label>
						<textarea id="diet" name="diet" rows="6"
							placeholder="오늘 하루 동안 먹은 음식을 자유롭게 기록해주세요."></textarea>
					</div>
					<div class="total-calories">
						<label for="calories">총 칼로리:</label> <input type="number"
							id="calories" name="calories" step="1" required> <span>kcal</span>
					</div>
					<div class="form-actions">
						<button type="reset">취소</button>
						<button type="submit">저장</button>
					</div>
				</form>
			</div>
		</div>
		<div class="food-search">
			<h3>식품 영양분석 API 검색(성분은 모두 1회 제공량 기준입니다.)</h3>
			<div class="search-container">
				<input type="text" id="foodSearchInput" placeholder="검색어를 입력하세요.">
				<button id="searchButton">검색</button>
			</div>
			<h3>식품명을 클릭 시 오늘의 식단에 추가됩니다.</h3>
			<div id="searchResults"></div>
		</div>
	</main>

	<%@ include file="/chatbot/chatbot.jsp"%>
	<%@ include file="../main/footer.jsp"%>
	<script src="../diet/common-calendar.js"></script>
	<script src="../diet/diet-calendar.js"></script>
	<script src="dietsearch-script.js"></script>
</body>
</html>