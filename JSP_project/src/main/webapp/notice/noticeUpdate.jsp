<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="notice.NoticeMgr, notice.NoticeBean" %>
<%
    // NoticeMgr 인스턴스 생성
    NoticeMgr noticeMgr = new NoticeMgr();

    // 공지사항 번호 가져오기
    int nNum = Integer.parseInt(request.getParameter("nNum"));
    NoticeBean notice = noticeMgr.getNotice(nNum); // 공지사항 상세 정보 가져오기
%>
<html>
<head>
    <title>공지사항 수정</title>
    <%@ include file="../main/header.jsp" %>
	<link rel="stylesheet" href="../css/notice.css">
	
</head>
<body class="noicebody">
<div class="notice-container" >
    <h1 class="notice-h1">공지사항 수정</h1>
    <form class="notice-form" action="noticeUpdate" method="post" enctype="multipart/form-data">
        <input type="hidden" name="nNum" value="<%= nNum %>">
        <label class="notice-label">공지사항 타입</label>
        <div style="margin: 10px; auto">
            <b><%= (notice.getNoticeType() == 0) ? "공지사항" : "이벤트" %></b>
        </div>
        <label class="notice-label" for="title">제목</label>
        <input type="text" id="title" name="title" value="<%= notice.getTitle() %>" required>
        
        <label class="notice-label" for="content">내용</label>
        <textarea id="content" name="content" rows="15" required><%= notice.getContent() %></textarea>
        
        <div>
            <label class="notice-label" for="image">이미지</label>
            <input type="file" id="image" name="image" accept="image/*">
            <% if(notice.getnImg() != null && !notice.getnImg().isEmpty()) { %>
                <p>현재 이미지: <%= notice.getnImg() %></p>
            <% } %>
        </div>
       	<div class="button-container">
            <button class="noitce-button" type="submit">수정하기</button>
        </div>
        
    </form>
</div>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
