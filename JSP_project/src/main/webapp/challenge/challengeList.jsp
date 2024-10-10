<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDate"%>
<%@page import="challenge.ChallengeBean"%>
<%@page import="java.util.Vector"%>
<%@page import="challenge.ChallengeMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
    // 현재 페이지 번호를 가져오고, 기본값은 1로 설정
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int itemsPerPage = 10; // 페이지당 아이템 수
    int startIdx = (currentPage - 1) * itemsPerPage; // 시작 인덱스

    String search = request.getParameter("search") != null ? request.getParameter("search").trim() : "";
    ChallengeMgr challmgr = new ChallengeMgr();
    Vector<ChallengeBean> vlist;

    // 검색어가 있는 경우 필터링된 리스트 가져오기
    if (!search.isEmpty()) {
        vlist = challmgr.searchChallengeList(search); // 검색 메서드 추가
    } else {
        vlist = challmgr.challengeList(); // 검색어가 없으면 전체 리스트 가져오기
    }
    int totalItems = challmgr.getTotalChallenges(search); // 전체 챌린지 개수
    int totalPages = (int) Math.ceil(totalItems / (double) itemsPerPage); // 전체 페이지 수 계산
%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/main/header.jsp" %>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <title>Challenge List</title>
    <style>
        body {
            position: relative;
			top:200px;
        }
		h1 {
            text-align: center; /* h1 태그 가운데 정렬 */
        }
        .challenge-container {
            width: 80%;
            margin: 20px auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
		
        .challenge-title {
            font-size: 2rem;
            color: #333;
            text-align: center;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .noticesearch-container {
            text-align: center;
            margin-bottom: 20px;
        }

        .noticesearch-container input[type="text"] {
            width: 300px;
            padding: 10px;
            font-size: 1rem;
            border: none;
        }

        .noticesearch-container button {
            border: none;
            background-color:white;
            padding: 10px 15px;
            color: black;
            font-size: 1rem;
            cursor: pointer;
        }

        table {
            width: 60%;
            margin: 0 auto; /* 테이블 가운데 정렬 */
            border-collapse: collapse; /* 테이블 간격 없애기 */
        }

        table th, table td {
            padding: 12px 15px;
            text-align: center; /* 테이블 데이터 가운데 정렬 */
        }

        table th {
            background-color: #f2f2f2;
            color: #333;
        }

        table td {
            background-color: #fff;
        }

        table td:nth-child(1) {
            font-weight: bold;
        }

        a {
            color: black; /* 검은색 글자 */
            text-decoration: none; /* 밑줄 제거 */
        }

        .pagination {
            text-align: center;
            margin: 20px 0;
        }

        .pagination a {
            color: black;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            margin: 0 5px;
        }
         .pagination a.active{
          text-decoration: underline;
         }
        .status-waiting {
            color: #f0ad4e;
            font-weight: bold;
        }

        .status-in-progress {
            color: #5bc0de;
            font-weight: bold;
        }

        .status-closed {
            color: #d9534f;
            font-weight: bold;
        }
        form{
			width: 80%;
            margin: 20px auto;
        }
    </style>
</head>

<body>
<h1>Challenge</h1>
<img alt="" src="challenge_img/challenge.png" style="width: 20%; height: auto; display: block; margin: 0 auto;"> <!-- 가운데 정렬 -->
<div class="noticesearch-container">
    <form action="challengeList.jsp" method="get">
        <input type="text" name="search" placeholder="검색어 입력" value="<%= search %>">
        <button class="notice-btn" type="submit">
            <i class="fas fa-search"></i>
        </button>
        <%if(userId!=null) {%>
       	<b><a href="challengeInsert.jsp" style="margin-left: 30%; color: green;">작성</a></b>
       	<%} %>
    </form>
  
</div>
<table>
	<tr>
    	<td>진행 상태</td>
    	<td><b>챌린지 명</b></td>
    	<td><b>날짜</b></td>
    	<td><b>참여인원</b></td>
    </tr>
    <%
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for (int i = 0; i < vlist.size(); i++) {
            ChallengeBean bean = vlist.get(i);
            LocalDate startDate = LocalDate.parse(bean.getStartDate(), formatter);
            LocalDate endDate = LocalDate.parse(bean.getEndDate(), formatter);

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
    %>
    
    <tr>
        <td class="<%= statusClass %>"><%= status %> </td>
        <td><a href="challengeDetail.jsp?num=<%=bean.getChallengeId()%>"><%= bean.getChallengeName() %></a> </td>
        <td ><%= bean.getStartDate() %> ~ <%= bean.getEndDate() %></td>
        <td><%=challmgr.countChallenge(bean.getChallengeId()) %>명</td>
    </tr>
    <% } %>
</table>

<div class="pagination">
    <% if (currentPage > 1) { %>
        <a href="?page=<%= currentPage - 1 %>&search=<%= search %>">이전</a>
    <% } %>
    
    <% for (int i = 1; i <= totalPages; i++) {
    	 String linkStyle = (i == currentPage) ? "text-decoration: underline;" : "";  	%>
    	
        <a href="?page=<%= i %>&search=<%= search %>" style="<%= linkStyle %>"><%= i %></a>
    <% } %>
    
    <% if (currentPage < totalPages) { %>
        <a href="?page=<%= currentPage + 1 %>&search=<%= search %>">다음</a>
    <% } %>
    <div><br><a href="challengeList.jsp">[목록]</a></div>

</div>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
