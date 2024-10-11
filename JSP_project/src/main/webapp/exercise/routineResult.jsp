<%@page import="exercise.ExerciseRoutineBean"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    List<ExerciseRoutineBean> routineList = (List<ExerciseRoutineBean>) request.getAttribute("routineList");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/main/header.jsp" %>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/routineResult.css">
<script>
function reloadPage() {
    location.reload(); // 페이지 새로고침
}
function goBack() {
    window.history.back(); // 이전 페이지로 돌아가기
}
</script>
</head>
<body class="result-body">
    <h1>오늘의 추천 루틴!</h1>
    <button class="button" type="button" onclick="goBack()">이전으로</button>
    <button class="button" type="button" onclick="reloadPage()">다른 루틴</button>
    <div class="r-container">
        <%
            if (routineList != null && !routineList.isEmpty()) {
                for (ExerciseRoutineBean routine : routineList) {
                    String exerciseLink = routine.getExerciseLink();
                    String videoId = exerciseLink.substring(exerciseLink.indexOf("v=") + 2);
                    String embedLink = "https://www.youtube.com/embed/" + videoId;
        %>
                    <div class="exercise-container">
                        <iframe src="<%= embedLink %>" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                        <h3><%= routine.geteName() %></h3>
                        <p>운동 방법: <%= routine.getExercise() %></p>
                    </div>
        <%
                }//--for
            }%>
    </div>
<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
