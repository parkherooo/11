<%@page import="challenge.ChallengeBean"%>
<%@page import="challenge.ChallengeMgr"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 요청으로부터 challengeId 파라미터를 받아옴
    int challengeId = Integer.parseInt(request.getParameter("num"));

    // 챌린지 정보를 가져옴
    ChallengeMgr challmgr = new ChallengeMgr();
    ChallengeBean challenge = challmgr.getChallengeDetail(challengeId);

    LocalDate today = LocalDate.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    LocalDate startDate = LocalDate.parse(challenge.getStartDate(), formatter);
    LocalDate endDate = LocalDate.parse(challenge.getEndDate(), formatter);

    String status;
    String statusClass;
    
    if (startDate.isAfter(today)) {
        status = "대기중";
        statusClass = "status-waiting";
    } else if (endDate.isBefore(today)) {
        status = "마감";
        statusClass = "status-closed";
    } else {
        status = "진행중";
        statusClass = "status-in-progress";
    }
    int count = challmgr.countChallenge(challengeId); 
%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/main/header.jsp" %>
    <meta charset="UTF-8">
    <title><%= challenge.getChallengeName() %><%=challenge.getChallengeId() %></title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
        }

        a {
            color: green;
            text-align: right;
            text-decoration: none;
            font-weight: bold; /* 참가 단어를 굵게 */
        }

        .challenge-detail-container {
            width: 60%;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .challenge-title {
            font-size: 2.5rem;
            color: #333;
            text-align: center;
            margin-bottom: 40px; /* 위아래 간격을 40px로 늘림 */
            font-weight: bold;
        }

        .challenge-status {
            font-size: 1.2rem;
            margin-bottom: 30px; /* 위아래 간격을 30px로 늘림 */
            text-align: center;
        }

        .challenge-status .status-waiting {
            color: #f0ad4e; /* 대기중 상태는 노란색 */
            font-weight: bold;
        }

        .challenge-status .status-in-progress {
            color: #5bc0de; /* 진행중 상태는 파란색 */
            font-weight: bold;
        }

        .challenge-status .status-closed {
            color: #d9534f; /* 마감 상태는 빨간색 */
            font-weight: bold;
        }

        .challenge-info {
            font-size: 1.1rem;
            margin-bottom: 30px; /* 위아래 간격을 30px로 늘림 */
        }

        .challenge-info span {
            font-weight: bold;
        }

        .challenge-description {
            font-size: 1rem;
            line-height: 1.8; /* 줄 간격을 1.8로 늘림 */
            margin-top: 30px; /* 위아래 간격을 30px로 늘림 */
        }

        .challenge-description h3 {
            margin-bottom: 20px; /* 설명 제목과 본문 사이 간격 */
        }

        .participation-container {
            text-align: right; /* 오른쪽 정렬 추가 */
            margin: 40px 0; /* 위아래 간격을 40px로 늘림 */
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 40px; /* 위 간격을 40px로 늘림 */
        }

        .back-link a {
            text-decoration: none;
            color: black;
        }

    </style>
</head>
<body>
<div class="challenge-detail-container">
    <h1 class="challenge-title"><%= challenge.getChallengeName() %></h1>

    <div class="challenge-status">
        상태: <span class="<%= statusClass %>"><%= status %></span>
    </div>
    
    <div class="participation-container"> <!-- 참여 버튼을 포함하는 div -->
    	<% if ("진행중".equals(status) && userId != null && !userId.equals("")) { %>
        <a href="challengeParticipation.jsp?num=<%=challenge.getChallengeId()%>">참가</a>
    	<% } %>
    </div>
	
	<div>
		<span>참가 인원 : <%=count%></span>
	</div>
    
    <div class="challenge-info">
        <span>시작일:</span> <%= challenge.getStartDate() %><br>
        <span>종료일:</span> <%= challenge.getEndDate() %><br>
    </div>

    <div class="challenge-description">
        <h3>챌린지 설명</h3>
        <p><%= challenge.getDescription() %></p>
    </div>
	
	<div>
		<h3>목표</h3>
		<b><%=challenge.getGoal() %></b>
	</div>

    <div class="back-link">
        <a href="challengeList.jsp">[목록]</a>
    </div>
</div>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
