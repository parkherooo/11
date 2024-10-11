<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="community.CommunityMgr" %>
<%@ page import="community.CommunityBean" %>
<%@ include file="../main/header.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String cuNumStr = request.getParameter("cuNum");
    int cuNum = 0;

    if (cuNumStr != null && !cuNumStr.trim().isEmpty()) {
        cuNum = Integer.parseInt(cuNumStr);
    }

    CommunityMgr mgr = new CommunityMgr();
    CommunityBean post = null;

    // 게시물 정보 가져오기
    if (cuNum != 0) {
        try {
            post = mgr.getPostDetail(cuNum); 
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>게시물 수정 및 삭제</title>
    <link rel="stylesheet" href="css/post_create.css?after">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <script>
        // 어떤 버튼을 클릭했는지에 따라 action을 설정
        function submitForm(actionValue) {
            var form = document.getElementById("postForm");
            document.getElementById("actionInput").value = actionValue; // action 값을 설정
            form.submit();
        }
    </script>
</head>
<body>
	<h1 style="text-align:center; margin-top: 100px;">My Community</h1>

    <main class="main_container">
        <div class="post_header">
            <button class="close_btn"><i class="xi-close"></i></button>
            <h2>게시물 수정 및 삭제</h2>
        </div>
        <div class="middle_Top">
            <img class="my_photo" src="img/profill.jpg" alt="프로필 사진">
            <span class="my_account"><%= userId %></span>
        </div>

        <!-- 게시물 수정 및 삭제 폼 -->
        <% if (post != null) { %>
           <form id="postForm" method="post" enctype="multipart/form-data" action="PostManagementServlet">
               <!-- 게시물 번호 전달 -->
               <input type="hidden" name="cuNum" value="<%= cuNum %>" />
               <!-- 기존 이미지 파일 이름 유지 -->
               <input type="hidden" name="existingCuImg" value="<%= post.getCuImg() != null ? post.getCuImg() : "" %>" />
               <!-- 어떤 액션인지 구분하기 위한 hidden input -->
               <input type="hidden" id="actionInput" name="action" value="" />

               <!-- 제목 입력칸 -->
               <div class="input_box">
                   <input type="text" class="title_input" name="title" value="<%= post.getTitle() != null ? post.getTitle() : "" %>" placeholder="제목을 입력해주세요" required>
               </div>

               <!-- 내용 입력칸 -->
               <div class="input_box">
                   <textarea name="content" placeholder="내용을 입력해주세요.." required><%= post.getContent() != null ? post.getContent() : "" %></textarea>
               </div>

               <!-- 이미지 추가 -->
               <div class="image_add">
                   <label for="cuImg" class="image_add_btn">
                       <i class="xi-paperclip"></i> 이미지 추가
                   </label>
                   <input type="file" id="cuImg" name="cuImg" accept="image/*" style="display: none;">
                   
                   <!-- 기존 이미지 파일 이름 표시 -->
                   <% if (post.getCuImg() != null && !post.getCuImg().isEmpty()) { %>
                       <div class="existing-image">
                           <p>현재 이미지 파일 이름: <%= post.getCuImg() %></p>
                       </div>
                   <% } %>
               </div>

               <!-- 수정 및 삭제 버튼 -->
               <div class="bottom_buttons">
                   <button type="button" class="modify_btn" onclick="submitForm('modify')">수정</button>
                   <button type="button" class="submit_btn" onclick="submitForm('delete')">삭제</button>
               </div>
           </form>
        <% } else { %>
            <p>해당 게시물 정보를 찾을 수 없습니다.</p>
        <% } %>
    </main>
<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer>
<%@ include file="../main/footer.jsp" %></footer>
</html>
