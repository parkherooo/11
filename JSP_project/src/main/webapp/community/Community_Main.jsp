<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="community.CommunityMgr" %>
<%@ page import="community.CommentsBean" %>
<%@ page import="community.CommentMgr" %>
<%@ page import="community.CommunityBean" %>
<%@ page import="java.util.List" %>
<%@ include file="../main/header.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

CommunityMgr mgr = new CommunityMgr();
CommentMgr commentMgr = new CommentMgr();


// 댓글 삭제 처리 로직
String cmNumStr = request.getParameter("cmNum");
if (cmNumStr != null && !cmNumStr.trim().isEmpty()) {
    int cmNum = Integer.parseInt(cmNumStr);
    try {
        commentMgr.deleteComment(cmNum);
    } catch (Exception e) {
        e.printStackTrace();
    }
}

// 게시물 목록 가져오기
List<CommunityBean> postList = null;
try {
    postList = mgr.getPostsByUser(userId);  // 이미 선언된 userId 사용
} catch (Exception e) {
    e.printStackTrace();
}

// 댓글 추가 로직
String newComment = request.getParameter("comment");
String cuNumStr = request.getParameter("cuNum");

if (newComment != null && !newComment.isEmpty() && cuNumStr != null) {
    int cuNum = Integer.parseInt(cuNumStr);

    // 댓글을 추가할 CommentsBean 객체 생성
    CommentsBean comment = new CommentsBean();
    comment.setComment(newComment);
    comment.setCuNum(cuNum);
    comment.setUserId(userId);  // 이미 선언된 userId 사용

    try {
        commentMgr.addComment(comment);
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>main_page</title>
    <link rel="stylesheet" href="css/community_main.css?after">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">

</head>
<body>
	<h1 style="text-align:center; margin-top: 100px;">My Community</h1>
    <!-- 게시물 목록 출력 -->
    <%
        if (postList != null && !postList.isEmpty()) {
            for (CommunityBean post : postList) {
    %>
                <!-- 각 게시물마다 별도의 main_container -->
                <div class="main_container">
                    <div class="middle_Top">
                        <ul>
                            <li><a href="#"><img class="my_photo" src="img/profill.jpg" alt="my_photo"></a></li>
                        </ul>
                        <ul>
                            <li class="my_account">
                                <a href="#" type="text">
                                    <!-- 세션에서 가져온 userId 표시 -->
                                    <%= (String)session.getAttribute("userId") != null ? (String)session.getAttribute("userId") : "root" %>
                                </a>
                            </li>
                        </ul>
                        <ul>
                            <li><a href="post_update.jsp?cuNum=<%= post.getCuNum() %>"><img class="dot" src="img/수정아이콘.png" alt="dot"></a></li>
                        </ul>
                    </div>

                    <div class="middle_Box">
                        <div class="post_item">
                            <img class="photo" src="upload/<%= post.getCuImg() != null ? post.getCuImg() : "default.png" %>" alt="photo" />
                        </div>
                    </div>

                    <div class="middle_review">
                        <div class="review_icon">
                            <ul class="fixedclear"> 
                                <form method="post" action="UpdateRecommendServlet">
                                    <input type="hidden" name="cuNum" value="<%= post.getCuNum() %>" />
                                    <button class="heartBtn" type="submit" onclick="toggleHeart(this)">
                                        <i class="xi-heart-o xi-2x"></i>
                                    </button>
                                </form>
                                <li><button class="spBubble"><i class="xi-speech-o xi-2x"></i></button></li>
                                <li><button class="bookmark"><i class="xi-bookmark-o xi-2x"></i></button></li>
                            </ul>
                        </div>
                        <div class="comment_part">
                            <ul>
                                <li class="like_count">
                                <p>좋아요 <%= post.getRecommend() %>개</p>
                                </li>
                                 <div>
                                 <span class="user"><%= post.getContent() %></span>
                                 <time class="before"><p>작성일: <%= post.getCuDate() != null ? post.getCuDate() : "날짜 없음" %></p>
                                 </div>
                            </ul>
                 
                             
                              <div>                        
                            <!-- 댓글 표시 영역 -->
                            <ul class="commentList">
                                <ul>
                                    <%
                                        // 현재 게시물에 대한 댓글 목록 가져오기
                                        List<CommentsBean> commentList = commentMgr.getCommentsByPost(post.getCuNum());
                                        if (commentList != null && !commentList.isEmpty()) {
                                            for (CommentsBean comment : commentList) {
                                    %>
                                        <li>
                                            <div>
                                                <span class="user"><%= comment.getUserId() %></span>
                                                <span class="userComment"><%= comment.getComment() %></span>
                                                <button class="deleteBtn" onclick="deleteComment(<%= comment.getCmNum() %>)">삭제</button>
                                            </div>
                                        </li>
                                    <%
                                            }
                                        }
                                    %>
                                </ul>
                             </ul>                  
                            </div>
                        </div>
                    </div>
                  

                    <div class="middle_add_review">                             
                        <!-- 댓글 입력 폼 -->
                        <form method="post">
                            <ul>
                                <li><img class="smile" src="img/smile.png" alt="smile"></li>
                            </ul>
                            <input class="input_review" type="text" name="comment" placeholder="댓글 달기..." required />
                            <input type="hidden" name="cuNum" value="<%= post.getCuNum() %>" />
                            <button class="review_upload" type="submit">게시</button>
                        </form>
                    </div>
                </div>
                
    <%
            }
        } else {
    %>
            <p>게시물이 없습니다.</p>
    <%
        }
    %>

    <script>
        function toggleHeart(button) {
            var heartIcon = button.querySelector('i');

            // 현재 상태가 redHeart인지 확인하여 클래스 토글
            if (heartIcon.classList.contains('redHeart')) {
                heartIcon.classList.remove('redHeart');
                heartIcon.classList.add('xi-heart-o');
            } else {
                heartIcon.classList.remove('xi-heart-o');
                heartIcon.classList.add('redHeart');
            }
        }

        // 댓글 삭제 요청 처리
        function deleteComment(cmNum) {
            if (confirm("댓글을 삭제하시겠습니까?")) {
                window.location.href = "?cmNum=" + cmNum;
            }
        }
        
        //게시물 삭제
        function deletePost(cuNum) {
            if (confirm("게시물을 삭제하시겠습니까?")) {
                window.location.href = "DeletePostServlet?cuNum=" + cuNum;
            }
        }

    </script>
<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer>
<%@ include file="../main/footer.jsp" %></footer>
</html>
