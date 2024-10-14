<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ include file="../main/header.jsp" %>
<%@ page import="community.CommunityMgr" %>
<%@ page import="community.CommentsBean" %>
<%@ page import="community.CommentMgr" %>
<%@ page import="community.CommunityBean" %>

<% 
    // 로그인이 되어 있지 않으면 알림 메시지 후 로그인 페이지로 리다이렉트
    if (userId == null || userId.isEmpty()) {
%>
        <script>
            alert("로그인이 필요합니다.");
            window.location.href = "/JSP_project/login/logIn.jsp";  // 로그인 페이지로 이동
        </script>
<%
        return; // 더 이상 실행되지 않도록 리턴
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>게시물 작성</title>
    <link rel="stylesheet" href="css/post_create.css?after">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    
    <script>
        // 자바스크립트 함수로 이미지 추가 버튼 클릭 시 파일 선택 창을 열도록 설정
        function triggerFileInput() {
            document.getElementById("cuImg").click();  // 파일 입력창 열기
        }

        // 파일 선택 후 선택된 이미지 이름을 버튼 대신 표시
        function handleFileSelect(event) {
            const fileInput = event.target;
            const fileName = fileInput.files[0] ? fileInput.files[0].name : "";
            
            if (fileName) {
                document.getElementById("imageLabel").innerText = fileName;
                document.getElementById("imageLabel").style.display = 'block'; // 이미지 라벨 표시
                document.getElementById("image_add_btn").style.display = 'none'; // 이미지 추가 버튼 숨김
            }
        }

        // 폼 제출 시 action 값을 설정하여 제출
        function submitForm(actionValue) {
            document.getElementById("actionInput").value = actionValue;

            // action 값에 따라 폼의 action 속성을 설정
            if (actionValue === 'modify') {
                document.getElementById("postForm").action = "community/updateServlet";
            } else {
                document.getElementById("postForm").action = "community/uploadServlet";
            }

            document.getElementById("postForm").submit(); 
        }
    </script>
</head>
<body>

	<h1 style="text-align:center; margin-top: 100px;">My Community</h1>

    <main class="main_container">
        <div class="post_header">
            <h2>게시물 작성</h2>
        </div>
        <div class="middle_Top">
            <img class="my_photo" src="img/profill.jpg" alt="프로필 사진">
            <span class="my_account"><%= userId %></span>
        </div>

        <!-- 게시물 작성 폼 -->
		<form id="postForm" action="community/uploadServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="userId" value="<%= userId %>">
            <div class="input_box">
                <input type="text" class="title_input" name="title" placeholder="제목을 입력해주세요" required>
                <textarea name="content" placeholder="내용을 입력해주세요.." required></textarea>
            </div>

            <!-- 이미지 추가 버튼 -->
            <div class="image_add">
                <button type="button" id="image_add_btn" class="image_add_btn" onclick="triggerFileInput()">
                    <i class="xi-paperclip"></i> 이미지 추가
                </button>
                <input type="file" id="cuImg" name="cuImg" style="display:none;" onchange="handleFileSelect(event)">
                <span id="imageLabel" style="display:none;"></span> <!-- 파일 선택 후 표시될 라벨 -->
            </div>

            <!-- 수정할 게시물 번호 -->
            <input type="hidden" name="cuNum" value="${cuNum}">

            <!-- action 값을 전달할 숨겨진 필드 -->
            <input type="hidden" id="actionInput" name="action" value="post">

            <!-- 버튼 설정 -->
            <div class="bottom_buttons">
                <button type="button" class="modify_btn" onclick="submitForm('modify')">수정</button>
                <button type="button" class="submit_btn" onclick="submitForm('post')">게시</button>
            </div>
        </form>
    </main>
<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer>
<%@ include file="../main/footer.jsp" %>
</footer>
</html>
