<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="notice.NoticeMgr" %>
<html>
<head>
    <title>공지사항 작성</title>
   <link rel="stylesheet" href="../css/notice.css">
   <%@ include file="/main/header.jsp" %>
</head>
<body class="noticebody">
<div class="notice-container" >
    <h1 class="notice-h1">공지사항 작성</h1>
    <form action="noticePost" method="post" enctype="multipart/form-data" class="notice-form">

        <label class="notice-label" for="title" >제목</label>
       <input type="text" id="title" name="title" required>
		<label class="notice-label">공지 타입</label>
        <div class="radio-group">
            <label ><input class="notice-input" type="radio" name="noticeType" value="0" required>공지사항</label>
            <label ><input class="notice-input" type="radio" name="noticeType" value="1">이벤트</label>
        </div>
        <br>
        <label class="notice-label" for="content">내용</label>
        <textarea id="content" name="content" rows="15" required></textarea>
		<div> 
		<label class="notice-label" for="image">이미지</label>
        <input class="notice-input" type="file" id="image" name="image" accept="image/*">
        <br>
        <br>
        </div>
       
		
        <button class="noitce-button" type="submit">작성하기</button>
        <button class="noitce-button" type="reset">다시쓰기</button>
    </form>
</div>
	 <%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
