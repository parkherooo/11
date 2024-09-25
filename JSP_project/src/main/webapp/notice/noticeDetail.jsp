<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="notice.NoticeMgr, notice.NoticeBean" %>
<%
    // NoticeMgr 인스턴스 생성
    NoticeMgr noticeMgr = new NoticeMgr();

	String userId = (String) session.getAttribute("userId");
	int manger = noticeMgr.mangerChk("root");
    // 공지사항 번호 가져오기
    int nNum = Integer.parseInt(request.getParameter("nNum"));
    NoticeBean notice = noticeMgr.getNotice(nNum); // 공지사항 상세 정보 가져오기
%>
<html>
<script>
function confirmDelete(nNum) {
    if (confirm("정말로 이 게시글을 삭제하시겠습니까?")) {
        document.getElementById('deleteForm').nNum.value = nNum;
        document.getElementById('deleteForm').submit();
    }
}
</script>
<head>
	<%@ include file="/main/header.jsp" %>
	<link rel="stylesheet" href="../css/notice.css">
    <title>공지사항 상세 보기</title>
	
</head>
<body class="noicebody">

<div class="noticeD-container">
	<%if(notice.getNoticeType()==0) {%>
	<div class="type">공지사항</div>
	<%} else {%>
	<div class="type">이벤트</div>
	<%} %>
    <h1 class="notice-h1"><%= notice.getTitle() %></h1>
    <div class="date"><%= notice.getnDate() %></div>
    <div class="action-buttons">
        <% if(manger == 1) { %>
            <a class="notice-a" href="noticeUpdate.jsp?nNum=<%= nNum %>">수정</a>
            <a class="notice-a" style="color: #c91b1b;" href="#" onclick="confirmDelete(<%= nNum %>)">삭제</a>

<form id="deleteForm" action="noticeDelete" method="post" style="display: none;">
    <input type="hidden" name="nNum" value="">
</form>

        <% } %>
    </div>
    <hr class="nohr" style="margin-top: 10%; width: 100%">
    <div class="content">  <%= notice.getContent().replace("\n", "<br>") %></div>
    <div class="image-container" >
        <% if (notice.getnImg() != null && !notice.getnImg().isEmpty()) { %>
            <img class="notice-img" src="../notice/notice_img/<%= notice.getnImg() %>" alt="공지사항 이미지" style="max-width: 40%; height: auto;">
        <% } %>
    </div>
    <br>
    <a class="back" href="noticeList.jsp">[목록]</a>
</div>
	 <%@ include file="/chatbot/chatbot.jsp" %>
	 
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
