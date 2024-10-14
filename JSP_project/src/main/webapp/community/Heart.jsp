<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="community.CommunityMgr, community.CommunityBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../main/header.jsp" %>


<%
	request.setCharacterEncoding("UTF-8");
	
    // 날짜 포맷 설정
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");

    // 검색어 설정
    String searchTitle = request.getParameter("searchTitle");

    // 페이지 관련 설정
    int postsPerPage = 5;  
    int pageNum = 1;       

    if (request.getParameter("page") != null) {
        pageNum = Integer.parseInt(request.getParameter("page"));
    }

    CommunityMgr mgr = new CommunityMgr();
    List<CommunityBean> postList = null;
    int totalPosts = 0; // 전체 게시물 수
    
    try {
        if (searchTitle != null && !searchTitle.trim().isEmpty()) {
            // 제목을 기준으로 검색된 게시물 리스트
            postList = mgr.getPostsByTitle(searchTitle, pageNum, postsPerPage);
            totalPosts = mgr.getTotalPostCountByTitle(searchTitle);
        } else {
            // 제목을 검색하지 않은 경우 전체 게시물 리스트
            postList = mgr.getPostList2(pageNum, postsPerPage);
            totalPosts = mgr.getTotalPostCount();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    // 전체 페이지 수 계산
    int totalPages = (int) Math.ceil((double) totalPosts / postsPerPage);
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>게시물 목록</title>
    <link rel="stylesheet" href="css/Heart.css">
    <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
</head>
<body>


<main class="main_container">
    <!-- 인기글 섹션 -->
    <section class="popular-section">
    <h2>인기글</h2>
    <div class="popular-list">
        <%
            List<CommunityBean> popularPosts = null;
            try {
                popularPosts = mgr.getTopLikedPosts(4);  // 상위 4개의 인기 게시물 가져오기
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (popularPosts != null) {
                for (CommunityBean post : popularPosts) {
        %>
                    <div class="popular-item">
                        <!-- 게시물 클릭 시 cuNum을 URL 파라미터로 전달 -->
                        <a href="<%= request.getContextPath() %>/community/postDetail.jsp?cuNum=<%= post.getCuNum() %>">
                            <!-- 이미지가 존재할 경우 이미지 출력 -->
                            <% if (post.getCuImg() != null && !post.getCuImg().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= post.getCuImg() %>" style="width: 250px; height: 250px;">
                            <% } else { %>
                                <img src="<%= request.getContextPath() %>/community/upload/default-image.jpg" alt="기본 이미지" style="width: 100px; height: 100px;">
                            <% } %>
                            <div class="popular-item-info">
                                <p>작성자: <%= post.getUserId() %></p>
                                <p>제목: <%= post.getTitle() %></p>
                            </div>
                            <button type="submit" class="heart-button" style="border: none; background: white; width: 40px; font-size: 16px; color: red;">
                                    ♥<%= post.getRecommend() %>
                                </button>
                        </a>
                       
                                
                         
                    </div>
        <%
                }
            } else {
        %>
            <p>인기글이 없습니다.</p>
        <%
            }
        %>
    </div>
</section>


    <!-- 게시물 리스트 섹션 -->
    <section class="list-section">
        <div class="noticesearch-container">
            <form action="" method="get">
                <input type="text" name="searchTitle" placeholder="제목을 입력하세요" value="<%= (searchTitle != null) ? searchTitle : "" %>">
                <button class="notice-btn" type="submit">
                  <i class="fas fa-search"></i>
                </button>
            </form>
        </div>

        <!-- 게시물 리스트 동적 출력 -->
        <!-- 게시물 리스트 동적 출력 -->
<table class="notice-table">
    <!-- 테이블 헤더 -->
    <thead>
        <tr>
            <th>작성자</th>
            <th>제목</th>
            <th>좋아요 수</th>
            <th class="date">날짜</th>
        </tr>
    </thead>

    <!-- 게시물 데이터 출력 -->
    <tbody>
        <%
            if (postList != null) {
                for (CommunityBean post : postList) {
        %>
            <tr>
                <!-- 게시물 클릭 시 상세 페이지로 이동 -->
                <td><a href="<%= request.getContextPath() %>/community/postDetail.jsp?cuNum=<%= post.getCuNum() %>"><%= post.getUserId() %></a></td>
                <td><a href="<%= request.getContextPath() %>/community/postDetail.jsp?cuNum=<%= post.getCuNum() %>"><%= post.getTitle() %></a></td>
                <td><a href="<%= request.getContextPath() %>/community/postDetail.jsp?cuNum=<%= post.getCuNum() %>"><%= post.getRecommend() %></a></td>
                <td class="date"><a href="<%= request.getContextPath() %>/community/postDetail.jsp?cuNum=<%= post.getCuNum() %>"><%= sdf.format(post.getCuDate()) %></a></td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="4">게시물이 없습니다.</td>
            </tr>
        <%
            }
        %>
    </tbody>
</table>
        

        <!-- 페이지네이션 -->
        <div class="noticepagination">
            <%
                // 페이지 번호 출력
                for (int i = 1; i <= totalPages; i++) {
                    if (i == pageNum) {
            %>
                        <a href="?page=<%= i %>" class="active"><%= i %></a>
            <%
                    } else {
            %>
                        <a href="?page=<%= i %>"><%= i %></a>
            <%
                    }
                }
            %>
        </div>
    </section>
</main>
<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer>
<%@ include file="../main/footer.jsp" %></footer>
</html>