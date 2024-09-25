<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="notice.NoticeMgr" %>
<html>
<head>
    <title>공지사항 작성</title>
    <style>
        body {
            text-align: center;
        }

        .container {
            width: 60%;
            margin: 0 auto;
            padding: 20px; /* 여백 추가 */
        }

        h1 {
            font-size: 24px; /* 제목 크기 */
            margin-bottom: 20px; /* 제목과 폼 사이 여백 */
            text-align: left; /* 제목 왼쪽 정렬 */
        }

        form {
            text-align: left; /* 폼 왼쪽 정렬 */
        }

        label {
            display: block; /* 라벨 블록으로 표시 */
            margin-bottom: 10px; /* 라벨과 입력 필드 사이 여백 */
        }

        input[type="text"], textarea {
            width: 100%; /* 입력 필드와 텍스트영역 너비 100% */
            padding: 10px; /* 여백 추가 */
            margin-bottom: 20px; /* 입력 필드와 다음 요소 사이 여백 */
            border: 1px solid #ccc; /* 테두리 추가 */
            border-radius: 4px; /* 모서리 둥글게 */
        }

        input[type="file"] {
            margin-bottom: 20px; /* 파일 선택 버튼과 다음 요소 사이 여백 */
        }

        .radio-group {
            margin-bottom: 20px; /* 라디오 버튼 그룹과 다음 요소 사이 여백 */
        }

        button {
            padding: 10px 15px; /* 버튼 여백 */
            color: white; /* 버튼 글자색 */
            background-color: black; /* 버튼 배경색 */
            border: none; /* 버튼 테두리 제거 */
            border-radius: 4px; /* 모서리 둥글게 */
            cursor: pointer; /* 커서 포인터 변경 */
            font-size: 16px; /* 버튼 글자 크기 */
        }

        button:hover {
            background-color: #0056b3; /* 버튼 호버 시 색상 변경 */
        }
    </style>
</head>
<body>

<div class="container" >
    <h1>공지사항 작성</h1>
    <form action="noticePost" method="post" enctype="multipart/form-data">
        <label for="title">제목</label>
        <input type="text" id="title" name="title" required>
		<label>공지 타입</label>
        <div class="radio-group">
            <label><input type="radio" name="noticeType" value="0" required> 공지사항</label>
            <label><input type="radio" name="noticeType" value="1"> 이벤트</label>
        </div>
        
        <label for="content">내용</label>
        <textarea id="content" name="content" rows="15" required></textarea>
		<div> 
		<label for="image">이미지</label>
        <input type="file" id="image" name="image" accept="image/*">
        </div>
       
		
        <button type="submit">작성하기</button>
        <button type="reset">다시쓰기</button>
    </form>
</div>
	 <%@ include file="/chatbot/chatbot.jsp" %>
</body>
</html>
