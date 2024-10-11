<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="exercise.GoalRecordMgr"%>
<%@page import="exercise.ExerciseGoalBean"%>
<%@page import="exercise.ExerciseGoalMgr"%>
<%@page import="exercise.GoalRecordBean"%>
<jsp:useBean id="goalBean" class="exercise.ExerciseGoalBean" scope="session"/>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/main/header.jsp" %>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/setgoal.css">
<script type="text/javascript">
function send() {
	// 로그인 상태 확인
    var isLoggedIn = <%= session.getAttribute("userId") != null ? "true" : "false" %>; // 세션에 로그인 정보가 있으면 true

    if (!isLoggedIn) {
        alert("로그인 후 이용 가능합니다.");
        window.location.href = "/JSP_project/login/logIn.jsp";
    } else {
        document.frm.submit();
    }
}

function send2() {
    // 로그인 상태 확인
    var isLoggedIn = <%= session.getAttribute("userId") != null ? "true" : "false" %>;

    if (!isLoggedIn) {
        alert("로그인 후 이용 가능합니다.");
        window.location.href = "/JSP_project/login/logIn.jsp"; // 로그인 페이지로 이동
    } else {
        document.frm2.submit();
    }
}
function send3() {
    // form의 action을 동적으로 설정
    var form = document.getElementById('goalForm');
    form.action = "/JSP_project/ExGoalDeleteServlet"; // 삭제할 때의 action URL

    // form 전송
    form.submit();
}
function openModal(src) {
    var modal = document.getElementById("imageModal");
    var modalImg = document.getElementById("modalImage");

    modal.style.display = "block";
    modalImg.src = src; // 클릭한 이미지의 경로를 모달 이미지로 설정
}

function closeModal() {
    var modal = document.getElementById("imageModal");
    modal.style.display = "none";
}

</script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="setgoal-body">

	<p class="setgoal-p">오늘의 운동 목표를 설정해보세요.</p>
	<form id="goalForm" action="/JSP_project/ExGoalInsertServlet" method="post" name="frm" class="container">
		<input type="hidden" name="userId" value="<%= userId %>">
		<%
				ExerciseGoalMgr Emgr = new ExerciseGoalMgr();
				ExerciseGoalBean bean = Emgr.selectGoal(userId);
	            request.setAttribute("bean", bean);
    			bean = (ExerciseGoalBean)request.getAttribute("bean");
				%>
		<div class="form-group">
			<small>*운동 목표는 하나만 등록 가능합니다.</small>
			<div class="form-row">
				<label for="title">나의 운동 목표 기간</label>
				<label>시작:</label> 
				<% if(bean.getSdate()==null){ %>
				<input type="Date" id="sdate" name="sdate">
				<%} else{ %>
				<span><%=bean.getSdate() %></span>
				<% } %>
				
				<span>~</span> 
				
				<label>끝:</label>
				<% if(bean.getEdate()==null){ %>
				<input type="Date" id="edate" name="edate">
				<%} else{ %>
				<span><%=bean.getEdate() %></span>
				<% } %>
			</div>
		</div>
		<hr />
		<div class="form-group">
			<div class="form-row">
				<label for="title">나의 목표 몸무게</label>
				<% if(bean.getGoalweight()==null){ %>
				<input type="text" id="goalweight" name="goalweight">
				<%} else{ %>
				<span><%=bean.getGoalweight() %></span>
				<% } %>
				<label> kg</label>
			</div>
		</div>
		<hr />
		<label for="title">나의 다짐</label>
		<div class="form-group">
			<% if(bean.getMypromise()==null){ %>
			<textarea id="mypromise" name="mypromise" placeholder="내용을 입력하세요."rows="5"></textarea>
			<%} else{ %>
				<span><%=bean.getMypromise() %></span>
			<% } %>
		</div>
		<div class="form-group" style="text-align: right;">
		<% if(bean.getSdate()==null && bean.getEdate()==null && bean.getGoalweight()==null && bean.getMypromise()==null){ %>
			<input type="button" value="설정" id="set" onclick="send()">
		<%} else{ %>
                <input type="button" value="삭제" id="del" onclick="send3()">
		<% } %>
		</div>
	</form>
	
	<form action="/JSP_project/RecordInsertServlet" method="post" name="frm2" enctype="multipart/form-data" >
	<input type="hidden" name="userId" value="<%= userId %>">
		<div class="form-inbody">
			<div class="form-group">
				<h3>인바디 기록</h3>
				<div class="form-row">
					<label for="height">키:</label> <input type="text" id="height"
						name="height"> <label for="height"> cm</label>
				</div>
				<div class="form-row">
					<label for="weight">몸무게:</label> <input type="text" id="weight"
						name="weight"> <label for="weight"> kg</label>
				</div>
				<div class="form-row">
					<label for="fat">체지방량:</label> <input type="text"
						id="fat" name="fat"> <label
						for="fat"> kg</label>
				</div>
				<div class="form-row">
					<label for="muscle">골격근량:</label> <input type="text"
						id="muscle" name="muscle"> <label for="muscle">
						kg</label>
				</div>
				<div class="form-row">
					<label for="percentage">체지방률:</label> <input type="text"
						id="percentage" name="percentage"> <label
						for="percentage"> %</label>
				</div>
				<div class="form-row">
					<label for="img">눈바디:&nbsp;&nbsp;</label> <input type="file"
						id="img" name="img" accept="image/*">
				</div>
				<input type="button" value="저장" onclick="send2()">
			</div>
			<div class="inbody-section">
				<div class="inbody-header">
					<h3>나의 인바디 변화</h3>
					<small>*최근 3개의 기록만 표시됩니다.</small>
					<% GoalRecordMgr Gmgr = new GoalRecordMgr();
					ArrayList<GoalRecordBean> records = Gmgr.selectRecord(userId);
					request.setAttribute("records", records); %>
				</div>
				<div class="inbody-images">
    				<div class="image-box">
				        <% if (records != null && records.size() > 2) { %>
    			    	<img src="/JSP_project/exercise/images/<%= records.get(2).getImg() %>" alt="이미지" onclick="openModal(this.src)">
    				    <% } %>
    				</div>
    				<div class="image-box">
        				<% if (records != null && records.size() > 1) { %>
       	 				<img src="/JSP_project/exercise/images/<%= records.get(1).getImg() %>" alt="이미지" onclick="openModal(this.src)">
        				<% } %>
    				</div>
   				 <div class="image-box">
    	 	   			<% if (records != null && records.size() > 0) { %>
        				<img src="/JSP_project/exercise/images/<%= records.get(0).getImg() %>" alt="이미지" onclick="openModal(this.src)">
        				<% } %>
    			</div>
			</div>

			<!-- 모달 창 -->
		<div id="imageModal" class="modal">
    		<span class="close" onclick="closeModal()">&times;</span>
    		<img class="modal-content" id="modalImage">
		</div>


				<!-- 차트를 표시할 캔버스 -->
				<canvas id="weightChart" width="300" height="50"></canvas>
				<canvas id="fmpChart" width="300" height="80"></canvas>
				<script>
				// JSP에서 JavaScript로 데이터 전달
				var records = [
    				<% for (int i = records.size() - 1; i >= 0; i--) { %>
        				{
            				date: '<%= records.get(i).getGrDate().toString() %>',
            				height: <%= records.get(i).getHeight() %>,
         		    		weight: <%= records.get(i).getWeight() %>,
            				fat: <%= records.get(i).getFat() %>,
            				muscle: <%= records.get(i).getMuscle() %>,
            				percentage: <%= records.get(i).getPercentage() %>
        				}<% if (i > 0) { %>,<% } %>
    				<% } %>
				];

				// 날짜별 데이터를 추출
				var labels = records.map(record => record.date);
				var heightData = records.map(record => record.height);
				var weightData = records.map(record => record.weight);
				var fatData = records.map(record => record.fat);
				var muscleData = records.map(record => record.muscle);
				var percentageData = records.map(record => record.percentage);

				// 차트를 그릴 함수 정의
				function createChart(ctx, label, data, borderColor) {
    				return new Chart(ctx, {
        				type: 'line',
        				data: {
            				labels: labels,
            				datasets: [{
                				label: label,
                				data: data,
                				borderColor: borderColor,
                				fill: false
            				}]
        				},
        				options: {
            				responsive: true,
            				scales: {
            		    		x: {
                    				title: {
                        				display: true,
                        				text: '날짜'
                    					}
                					},
                				y: {
                    				title: {
                        				display: true,
                        				text: ''
                    					}
                					}
            					}
        					}
    					});
					}
				function createfmpChart(ctx) {
				    return new Chart(ctx, {
				        type: 'line',
				        data: {
				            labels: labels,
				            datasets: [
				                {
				                    label: '체지방량(kg)',
				                    data: fatData,
				                    borderColor: 'rgba(255, 99, 132, 1)', // 빨간색
				                    fill: false
				                },
				                {
				                    label: '근육량(kg)',
				                    data: muscleData,
				                    borderColor: 'rgba(75, 192, 192, 1)', // 청록색
				                    fill: false
				                },
				                {
				                    label: '체지방률(%)',
				                    data: percentageData,
				                    borderColor: 'rgba(255, 165, 0, 1)', // 주황색
				                    fill: false
				                }
				            ]
				        },
				        options: {
				            responsive: true,
				            scales: {
				                x: {
				                    title: {
				                        display: true,
				                        text: '날짜'
				                    }
				                },
				                y: {
				                    title: {
				                        display: true,
				                        text: ''
				                    }
				                }
				            }
				        }
				    });
				}
				// 각 차트를 개별 캔버스에 생성
				var weightCtx = document.getElementById('weightChart').getContext('2d');
				createChart(weightCtx, '몸무게(kg)', weightData, 'rgba(54, 162, 235, 1)');
	
				var fmpCtx = document.getElementById('fmpChart').getContext('2d');
				createfmpChart(fmpCtx);
				
				</script>
 				</div>
			</div>
		</div>
	</form>
<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
