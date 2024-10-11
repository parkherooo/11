<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<html>
<head>
    <title>레시피 상세 보기</title>
    <style>
        .step img {
            max-width: 100%; /* 이미지가 너무 크지 않게 조정 */
            height: auto;
        }
    </style>
</head>
<body>

<h1><%= request.getAttribute("title") %></h1>
<h2>재료</h2>
<p><%= request.getAttribute("ingredients") %></p>
<h2>조리 방법</h2>
<div>
    <%= request.getAttribute("instructions") %>
</div>
<a href="recipeCrawler">목록으로 돌아가기</a>
</body>
</html>
