<%@page import="challenge.ChallengeParticipantBean"%>
<%@page import="java.util.Vector"%>
<%@page import="challenge.ChallengeBean"%>
<%@page import="challenge.ChallengeMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    int challengeId = Integer.parseInt(request.getParameter("num"));
    ChallengeMgr challmgr = new ChallengeMgr();
    ChallengeBean challenge = challmgr.getChallengeDetail(challengeId);
    int count = challmgr.countChallenge(challengeId); 

    // 페이지네이션 관련 변수
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int itemsPerPage = 10; // 페이지당 게시글 수
    Vector<ChallengeParticipantBean> vlist = challmgr.userChallengeList(challengeId);
    int totalItems = vlist.size(); // 총 게시글 수
    int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage); // 총 페이지 수

    // 현재 페이지에 대한 인덱스 계산
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = Math.min(startIndex + itemsPerPage, totalItems);

    // 현재 페이지에 해당하는 데이터 리스트
    Vector<ChallengeParticipantBean> currentPageList = new Vector<>();
    for (int i = startIndex; i < endIndex; i++) {
        currentPageList.add(vlist.get(i));
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%@ include file="/main/header.jsp" %>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }

        .challenge-container {
            width: 60%;
            margin: 30px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        h3 {
            text-align: center;
            font-size: 2rem;
            margin-bottom: 20px;
            color: #333;
        }

        .challenge-info, .challenge-description {
            margin-bottom: 20px;
            font-size: 1.1rem;
        }

        .challenge-info span {
            font-weight: bold;
            color: #444;
        }

        .challenge-description h3 {
            margin-bottom: 10px;
            font-size: 1.3rem;
            color: #444;
        }

        .challenge-description p {
            line-height: 1.6;
        }

        .challenge-goal {
            font-size: 1.2rem;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .participant-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
        }

        .participant-table th, .participant-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        .participant-table img {
            max-width: 100px;
            height: auto;
            border-radius: 10px;
        }

        .participant-table td {
            vertical-align: middle;
        }

        .heart-button {
            background: none;
            border: none;
            cursor: pointer;
            color: #d9534f;
            font-size: 1.2rem;
        }

        .heart-button:hover {
            color: #c9302c;
        }

        .join-button {
            display: inline-block;
            background-color: #5bc0de;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 1.1rem;
            border: none;
            cursor: pointer;
            margin-top: 20px;
            text-align: center;
        }

        .join-button:hover {
        }

        .participant-count {
            margin-top: 10px;
            text-align: center;
        }

        .pagination {
            text-align: center;
            margin: 20px 0;
        }

        .pagination a {
            margin-top: 20px;
            padding: 8px 12px;
            color: black;
            text-decoration: none;
        }
    </style>

</head>
<body>
<%
    if(userId == null) {
        out.println("<script>");
        out.println("alert('로그인하세요.');");
        out.println("</script>");
        response.sendRedirect("../main/main.jsp");
    }
%>
<script>
    function openChallengeForm() {
        var challengeId = <%= challengeId %>;
        var userId = "<%= userId %>";

        // 새 창을 400x500 크기로 열고, 참여 폼을 보여주는 페이지로 이동
        window.open("challengeform.jsp?num=" + encodeURIComponent(challengeId) + "&userId=" + encodeURIComponent(userId),
            "Challenge Participation",
            "width=400,height=500");
    }
</script>
<div class="challenge-container">
    <h3><%= challenge.getChallengeName() %></h3>

    <div class="participant-count">
        참가 인원: <%= count %>명
    </div>

    <div class="challenge-info">
        <span>시작일:</span> <%= challenge.getStartDate() %><br>
        <span>종료일:</span> <%= challenge.getEndDate() %><br>
    </div>

    <div class="challenge-description">
        <h3>챌린지 설명</h3>
        <p><%= challenge.getDescription() %></p>
    </div>

    <div class="challenge-goal">
        목표: <%= challenge.getGoal() %>
    </div>

    <div>
        <button class="join-button" onclick="openChallengeForm()">챌린지 참여하기</button>
    </div>

    <table class="participant-table">
        <thead>
            <tr>
                <th>인증샷</th>
                <th>참가자</th>
                <th>한마디</th>
                <th>참여 날짜</th>
                <th>좋아요</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (ChallengeParticipantBean bean : currentPageList) {
        %>
            <tr>
                <td>
                    <% if (bean.getImg() != null && !bean.getImg().isEmpty()) { %>
                        <img class="participant-image" src="../challenge/challenge_img/<%= bean.getImg() %>" alt="챌린지 이미지">
                    <% } %>
                </td>
                <td><%= bean.getUserId() %></td>
                <td><%= bean.getComent() %></td>
                <td><%= bean.getJoinDate() %></td>
                <td>
                    <form action="heartPlus" method="post">
                        <input type="hidden" name="challengeId" value="<%= request.getParameter("num") %>">
                        <input type="hidden" name="participantId" value="<%= bean.getParticipantId() %>">
                        <button type="submit" class="heart-button">
                            ♥<%= bean.getHeart() %>
                        </button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="pagination">
        <%
            if (currentPage > 1) {
        %>
            <a href="?num=<%= challengeId %>&page=<%= currentPage - 1 %>">이전</a>
        <%
            }
            for (int i = 1; i <= totalPages; i++) {
                if (i == currentPage) {
        %>
                    <strong><%= i %></strong>
        <%
                } else {
        %>
                    <a href="?num=<%= challengeId %>&page=<%= i %>"><%= i %></a>
        <%
                }
            }
            if (currentPage < totalPages) {
        %>
            <a href="?num=<%= challengeId %>&page=<%= currentPage + 1 %>">다음</a>
        <%
            }
        %>
        <div style="margin-top: 30px;">
        	<a href="challengeList.jsp">[목록]</a>
        </div>
    </div>
</div>

</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
