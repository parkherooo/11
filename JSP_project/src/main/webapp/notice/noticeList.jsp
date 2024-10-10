<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="notice.NoticeMgr, java.util.Vector, notice.NoticeBean" %>
<%@ include file="../main/header.jsp" %>
<%
    
    // 전체 공지사항 리스트
    Vector<NoticeBean> allList = noticeMgr.AllList();
    
    // 검색어 가져오기
    String search = request.getParameter("search");
    
    Vector<NoticeBean> filteredList;
    
    String category = request.getParameter("category");
    
%>
<html>
<head>
    <title>공지사항 목록</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../css/notice.css">


</head>


<body class="noticebody" style="position: relative; top: 200px;">
<h1>Notice</h1>
<div class="noticeheader">
    <div class="noticecategories">
	    <a class="notice-a <%= (category == null || category.equals("전체")) ? "active" : "" %>" href="noticeList.jsp?category=전체">전체</a>
	    <a class="notice-a <%= (category != null && category.equals("공지사항")) ? "active" : "" %>" href="noticeList.jsp?category=공지사항">공지사항</a>
	    <a class="notice-a <%= (category != null && category.equals("이벤트")) ? "active" : "" %>" href="noticeList.jsp?category=이벤트">이벤트</a>
	</div>

    <div class="noticesearch-container">
        <form action="noticeList.jsp" method="get">
            <input type="text" name="search" placeholder="검색어 입력" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button class="notice-btn" type="submit">
                <i class="fas fa-search"></i>
            </button>
        </form>
    </div>
</div>
<div class="noticeinsert">
    <%if(manger==1) {%><a class="notice-a" href="noticeInsert.jsp">게시글 작성</a><%} %>
</div>
<%
    // 검색어가 있을 경우 검색된 리스트를 가져옴
    if (search != null && !search.trim().isEmpty()) {
        filteredList = noticeMgr.searchByTitle(search);
    } else {
        filteredList = allList; // 검색어가 없으면 전체 리스트
    }

    // 카테고리별로 필터링
    if (category != null && !category.equals("전체")) {
        Vector<NoticeBean> categoryFilteredList = new Vector<>();
        for (NoticeBean bean : filteredList) {
            if ((category.equals("공지사항") && bean.getNoticeType() == 0) || 
                (category.equals("이벤트") && bean.getNoticeType() == 1)) {
                categoryFilteredList.add(bean);
            }
        }
        filteredList = categoryFilteredList; // 필터링된 리스트로 업데이트
    }
%>
<table class="notice-table">
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
        <td class="notice-td">
            <%
            if (bean.getNoticeType() == 0) { %>
                공지사항
            <% } else { %>
                이벤트
            <% } %>
        </td>
        <td class="notice-td"><a class="notice-a" href="noticeDetail.jsp?nNum=<%= bean.getnNum() %>"><%= bean.getTitle() %></a></td>
        <td class="notice-td"><%= bean.getnDate() %></td>
    </tr>
    <%
        }
    %>
</table>

<!-- 페이지네이션 -->
<div class="noticepagination">
    <%
        // 이전 페이지 링크
        if (currentPage > 1) {
            int prevPage = currentPage - 1;
    %>
        <a class="notice-a" href="noticeList.jsp?category=<%= category != null ? category : "전체" %>&search=<%= search != null ? search : "" %>&page=<%= prevPage %>">이전</a>
    <%
        }

        // 페이지 번호 링크 생성
        for (int i = 1; i <= totalPages; i++) {
            if (i == currentPage) {
    %>
                <a class="notice-a active"><%= i %></a>
    <%
            } else {
    %>
                <a class="notice-a" href="noticeList.jsp?category=<%= category != null ? category : "전체" %>&search=<%= search != null ? search : "" %>&page=<%= i %>"><%= i %></a>
    <%
            }
        }

        // 다음 페이지 링크
        if (currentPage < totalPages) {
            int nextPage = currentPage + 1;
    %>
            <a class="notice-a" href="noticeList.jsp?category=<%= category != null ? category : "전체" %>&search=<%= search != null ? search : "" %>&page=<%= nextPage %>">다음</a>
    <%
        }
    %>
</div>
<div class="noticepagination">
    <a class="notice-a" href="noticeList.jsp">[목록]</a>
</div>

<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer>
<%@ include file="../main/footer.jsp" %></footer>
</html>
