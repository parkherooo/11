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
    <title>공지사항 상세 보기</title>
    <style>
        body {
            text-align: center;
        }
		.type{
			text-align: left;
		}
		
        .container {
            width: 50%;
            margin: 0 auto;
            padding: 20px; /* 여백 추가 */
        }

        h1 {
            font-size: 36px; /* 제목 크기 */
            margin-bottom: 20px; /* 제목과 본문 사이 여백 */
            text-align: left; /* 제목 왼쪽 정렬 */
             
        }
        hr{
        	margin-top: 10%;
        }

        .date {
            font-size: 14px; /* 날짜 글자 크기 */
            color: gray; /* 날짜 색상 */
            margin-bottom: 20px; /* 날짜와 본문 사이 여백 */
            text-align: left;
        }

        .content {
            font-size: 20px; /* 본문 글자 크기 */
            line-height: 1.5; /* 줄 간격 */
            text-align: left; /* 본문 왼쪽 정렬 */
            margin-bottom: 10%;
        }

        .back{
            color: black; /* 버튼 글자색 */
            border: none; /* 버튼 테두리 제거 */
            cursor: pointer; /* 커서 포인터 변경 */
            font-size: 16px; /* 버튼 글자 크기 */
        }

        .back:hover {
           background-color: #f1f1f1;
        }
        a {
        	text-align:right;
            margin: 0 10px;
            font-size: 18px;
            color: black; /* 글자 색상 검정 */
            text-decoration: none; /* 밑줄 제거 */
        }
        a:hover {
            background-color: #f1f1f1;
        }
        .action-buttons {
            display: flex;
            justify-content: flex-end; /* 오른쪽 정렬 */
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container">
	<%if(notice.getNoticeType()==0) {%>
	<div class="type">공지사항</div>
	<%} else {%>
	<div class="type">이벤트</div>
	<%} %>
    <h1><%= notice.getTitle() %></h1>
    <div class="date"><%= notice.getnDate() %></div>
    <div class="action-buttons">
        <% if(manger == 1) { %>
            <a href="noticeUpdate.jsp?nNum=<%= nNum %>">수정</a>
            <a style="color: #c91b1b;" href="#" onclick="confirmDelete(<%= nNum %>)">삭제</a>

<form id="deleteForm" action="noticeDelete" method="post" style="display: none;">
    <input type="hidden" name="nNum" value="">
</form>

        <% } %>
    </div>
    <hr>
    <div class="content"><%= notice.getContent() %></div>
    <a class="back" href="noticeList.jsp">[목록]</a>
</div>
	 <%@ include file="/chatbot/chatbot.jsp" %>
</body>
</html>
