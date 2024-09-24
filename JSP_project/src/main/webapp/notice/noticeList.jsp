<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="notice.NoticeMgr, java.util.Vector, notice.NoticeBean" %>
<%
	// NoticeMgr 인스턴스 생성
	NoticeMgr noticeMgr = new NoticeMgr();
	
	// 전체 공지사항 리스트
	Vector<NoticeBean> allList = noticeMgr.AllList();
	
	// 검색어 가져오기
	String search = request.getParameter("search");
	
	Vector<NoticeBean> filteredList;
	
	//관리자 확인
	String userId = (String) session.getAttribute("userId");
	int manger = noticeMgr.mangerChk("root");
%>
<html>
<head>
    <title>공지사항 목록</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* 전체 페이지 가운데 정렬 */
        body {
            text-align: center;
        }

        /* 카테고리 및 검색 부분 왼쪽 정렬 */
        .header {
            width: 60%;
            margin: 0 auto;
            text-align: left;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .insert{
     	  	width: 80%;
        	text-align: right; /* 오른쪽 정렬 */
        }

        /* 카테고리 링크 가로 정렬 */
        .categories {
            display: inline-block;
        }

        a {
            margin: 0 10px;
            font-size: 18px;
            color: black; /* 글자 색상 검정 */
            text-decoration: none; /* 밑줄 제거 */
        }

        a:hover {
            background-color: #f1f1f1;
        }

        /* 검색 폼 */
        .search-container {
            display: inline-block;
        }

        .search-container input {
            padding: 5px;
            font-size: 16px;
            border: none;
        }

        button {
            border: none;
            background: none;
            cursor: pointer;
            font-size: 20px; /* 아이콘 크기 증가 */
        }

        /* 게시글 테이블 스타일 */
        table {
            width: 60%;
            margin: 20px auto;
            border-collapse: collapse;
        }

        td {
            padding: 20px;
            border-bottom: 1px solid #ccc;
        }

        hr {
            width: 60%;
            margin: 10px auto;
        }

        .date-column {
            text-align: right; /* 오른쪽 정렬 */
        }

        .pagination {
        margin: 20px auto;
        display: flex;
        justify-content: center;
	    }
	
	    .pagination a {
	        text-decoration: none; /* 밑줄 제거 */
	        padding: 10px 20px; /* 여백 추가 */
	        color: black; /* 글자 색상 검정색 */
	        font-size: 14px; /* 글자 크기 줄임 */
	    }
	
	    .pagination .active {
	        font-weight: bold; /* 현재 페이지 글씨 두껍게 */
	    }
    </style>
</head>
<div class="header">
    <div class="categories">
        <a href="noticeList.jsp?category=전체">전체</a>
        <a href="noticeList.jsp?category=공지사항">공지사항</a>
        <a href="noticeList.jsp?category=이벤트">이벤트</a>
    </div>

    <div class="search-container">
        <form action="noticeList.jsp" method="get">
            <input type="text" name="search" placeholder="검색어 입력" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button type="submit">
                <i class="fas fa-search"></i>
            </button>
        </form>
    </div>
</div>
<div class="insert">
	<%if(manger==1) {%><a href="noticeInsert.jsp">게시글 작성</a><%} %>
</div>
<body>
<%
    // 검색어가 있을 경우 검색된 리스트를 가져옴
    if (search != null && !search.trim().isEmpty()) {
        filteredList = noticeMgr.searchByTitle(search);
    } else {
        filteredList = allList; // 검색어가 없으면 전체 리스트
    }

    // 카테고리별로 필터링
    String category = request.getParameter("category");
    if (category == null || category.equals("전체")) {
%>
<table>
    <%
        // 페이지네이션 변수 설정
        int pageSize = 10; // 페이지당 게시글 수
        int totalPosts = filteredList.size(); // 총 게시글 수
        int totalPages = (int) Math.ceil((double) totalPosts / pageSize); // 총 페이지 수

        // 현재 페이지 번호 가져오기
        int currentPage = 1; // 기본값
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            currentPage = Integer.parseInt(pageParam);
        }

        // 현재 페이지의 시작 인덱스와 끝 인덱스 계산
        int startIndex = (currentPage - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalPosts);

        for (int i = startIndex; i < endIndex; i++) {
            NoticeBean bean = filteredList.get(i);
    %>
    <tr>
        <td>
            <%
            if (bean.getNoticeType() == 0) { %>
                공지사항
            <% } else { %>
                이벤트
            <% } %>
        </td>
        <td><a href="noticeDetail.jsp?nNum=<%= bean.getnNum() %>"><%= bean.getTitle() %></a></td>
        <td class="date-column"><%= bean.getnDate() %></td>
    </tr>
    <%
        }
    %>
</table>

<!-- 페이지네이션 -->
	<div class="pagination">
    <%
        // 이전 페이지 링크
        if (currentPage > 1) {
            int prevPage = currentPage - 1;
    %>
        <a href="noticeList.jsp?category=<%= category != null ? category : "전체" %>&search=<%= search != null ? search : "" %>&page=<%= prevPage %>">이전</a>
    <%
        }

        // 페이지 번호 링크 생성
        for (int i = 1; i <= totalPages; i++) {
            if (i == currentPage) {
    %>
                <a class="active"><%= i %></a>
    <%
            } else {
    %>
                <a href="noticeList.jsp?category=<%= category != null ? category : "전체" %>&search=<%= search != null ? search : "" %>&page=<%= i %>"><%= i %></a>
    <%
            }
        }

        // 다음 페이지 링크
        if (currentPage < totalPages) {
            int nextPage = currentPage + 1;
    %>
            <a href="noticeList.jsp?category=<%= category != null ? category : "전체" %>&search=<%= search != null ? search : "" %>&page=<%= nextPage %>">다음</a>
    <%
        }
    %>
	</div>
	<a href="noticeList.jsp">[목록]</a>
	<%
	    } else if (category.equals("공지사항")) {
	%>
	<table>
	    <%
	        for (NoticeBean bean : filteredList) {
	            if (bean.getNoticeType() == 0) { // 공지사항만 필터링
	    %>
	    <tr>
	        <td>공지사항</td>
	        <td><a href="noticeDetail.jsp?nNum=<%= bean.getnNum() %>"><%= bean.getTitle() %></a></td>
	        <td class="date-column"><%= bean.getnDate() %></td>
	    </tr>
	    <%
	            }
	        }
	    %>
	</table>
	<%
	    } else if (category.equals("이벤트")) {
	%>
	<table>
	    <%
	        for (NoticeBean bean : filteredList) {
	            if (bean.getNoticeType() == 1) { // 이벤트만 필터링
	    %>
	    <tr>
	        <td>이벤트</td>
	        <td><a href="noticeDetail.jsp?nNum=<%= bean.getnNum() %>"><%= bean.getTitle() %></a></td>
	        <td class="date-column"><%= bean.getnDate() %></td>
	    </tr>
	    <%
	            }
	        }
	    %>
	</table>
	<%
	    }
	%>

</body>
</html>
