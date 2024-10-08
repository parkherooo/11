<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="community.CommunityMgr, community.CommunityBean" %>
<%@ page import="community.CommentMgr" %>
<%@ page import="community.CommentsBean" %>
<%@ page import="java.util.List" %>
<%@ include file="../main/header.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    String cuNumParam = request.getParameter("cuNum");
    int cuNum = 0;

    if (cuNumParam != null && !cuNumParam.trim().isEmpty()) {
        try {
            cuNum = Integer.parseInt(cuNumParam);
            System.out.println("Received cuNum: " + cuNum);  
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    } else {
        out.println("<script>alert('잘못된 접근입니다.'); history.back();</script>");
        return;
    }

    CommunityMgr mgr = new CommunityMgr();
    CommunityBean post = null;

    try {
        post = mgr.getPostDetail(cuNum);  
        if (post == null) {
            System.out.println("No post found for cuNum: " + cuNum);  
            out.println("<script>alert('게시물을 찾을 수 없습니다.'); history.back();</script>");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('게시물 정보를 가져오는 중 오류가 발생했습니다.'); history.back();</script>");
        return;
    }

    // 댓글 추가 로직
    String newComment = request.getParameter("comment");
    if (newComment != null && !newComment.trim().isEmpty()) {
        CommentMgr commentMgr = new CommentMgr();
        CommentsBean commentBean = new CommentsBean();
        commentBean.setComment(newComment);
        commentBean.setCuNum(cuNum);
        commentBean.setUserId("root");  // 사용자 ID(임시)
        
        try {
            commentMgr.addComment(commentBean);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 댓글 목록 가져오기
    CommentMgr commentMgr = new CommentMgr();
    List<CommentsBean> commentList = null;
    try {
        commentList = commentMgr.getCommentsByPost(cuNum);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>main_page</title>
    <link rel="stylesheet" href="css/community_main.css?after">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
</head>
<body>
		
	<h1 style="text-align:center; margin-top: 100px;">My Community</h1>

    <div class="main_container">
        <div class="middle_Top">
            <ul>
                <li>
                    <a href="#"><img class="my_photo" src="img/profill.jpg" alt="my_photo"></a>
                </li>
            </ul>
            <ul>
                <li class="my_account">
                    <!-- 동적으로 userId 표시 -->
                    <a href="#" type="text"><%= post.getUserId() %></a>
                </li>
            </ul>
            <ul>
                <li>
                    <a href="#"><img class="dot" src="img/dot.png" alt="dot"></a>
                </li>
            </ul>
        </div>

        <div class="middle_Box">
            <!-- 동적으로 게시물 이미지 표시 -->
            <img class="photo" src="<%= request.getContextPath() %>/community/img/<%= post.getCuImg() %>" alt="photo">	
        </div>

        <div class="middle_review">
            <div class="review_icon">
                <ul class="fixedclear"> 
                    <button class="heartBtn" onclick="addLike()"><i class="xi-heart-o xi-2x"></i></button>
                    <li>
                        <button class="spBubble"><i class="xi-speech-o xi-2x"></i></button>
                    </li>
                    <li>
                        <button class="bookmark"><i class="xi-bookmark-o xi-2x"></i></button>
                    </li>
                </ul>
            </div>

            <div class="comment_part">
                <ul>
                    <li class="like_count">
                        <!-- 좋아요 개수 동적 표시 -->
                        좋아요 <%= post.getRecommend() %>개
                    </li>
                    <div>
                      <span class="user"><%= post.getContent() %></span>
                      <time class="before"><p>작성일: <%= post.getCuDate() != null ? post.getCuDate() : "날짜 없음" %></p>
                      </div>
                </ul>
                <div>
                    <ul class="commentList">
                        <% if (commentList != null && !commentList.isEmpty()) { 
                            for (CommentsBean comment : commentList) { %>
                                <li>
                                    <div>
                                        <span class="user"><%= comment.getUserId() %></span>
                                        <span class="userComment"><%= comment.getComment() %></span>
                                    </div>
                                </li>
                            <% }
                        } else { %>
                            <li>댓글이 없습니다.</li>
                        <% } %>
                    </ul>
                </div>
            </div>
        </div>

        <div class="middle_add_review">
            <ul>
                <li>
                    <img class="smile" src="img/smile.png" alt="smile">
                </li>
            </ul>
            <form method="post">
                <input class="input_review" type="text" name="comment" placeholder="댓글 달기..." required>
                <input type="hidden" name="cuNum" value="<%= cuNum %>">
                <button class="review_upload" type="submit">게시</button>
            </form>
        </div>
    </div>

    <script>
        function deleteComment(cmNum) {
            if (confirm("댓글을 삭제하시겠습니까?")) {
                window.location.href = "?cmNum=" + cmNum + "&cuNum=<%= cuNum %>";
            }
        }
    </script>
<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer>
<%@ include file="../main/footer.jsp" %></footer>
</html>
