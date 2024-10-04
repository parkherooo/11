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
    <meta charset="UTF-8">
    <title>Fit Time</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 20px;
        }
        .container {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
        }
        .exercise-container {
            margin: 10px;
            border: 1px solid #ccc;
            padding: 10px;
            width: 300px; /* Adjust width as needed */
        }
        h1{
			text-align: center;
			margin-bottom: 50px;
		}
		.button {
			background-color: black;
			color: white;
			padding: 10px 10px;
			margin: 0 10px 20px 10px;
			border: none;
			border-radius: 5px;
			cursor: pointer;
		}
		.button:hover{
		background-color: darkgrey;
		}
    </style>
<script>
function reloadPage() {
    location.reload(); // 페이지 새로고침
}
function goBack() {
    window.history.back(); // 이전 페이지로 돌아가기
}
</script>
</head>
<body>
    <h1>오늘의 추천 루틴!</h1>
    <button class="button" type="button" onclick="goBack()">이전으로</button>
    <button class="button" type="button" onclick="reloadPage()">다른 루틴</button>
    <div class="container">
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
</body>
</html>
