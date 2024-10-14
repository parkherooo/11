<%@page import="mypage.freindBean"%>
<%@page import="java.util.Vector"%>
<%@page import="recipe.UserAllergyMgr"%>
<%@page import="user.UserMgr"%>
<%@page import="user.UserBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    UserBean bean = new UserBean();
    UserMgr mgr = new UserMgr();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>myPage</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="../css/mypage.css">
    <%@ include file="/main/header.jsp" %>
</head>
<%	
	//카테고리 분류
    String category = request.getParameter("category");
	//내정보 가져오기
    bean = mgr.myInfo(userId);
    
	//알러지 정보 가져오기
    UserAllergyMgr allergyMgr = new UserAllergyMgr();
	String[] userAllergies = {"없음"};
	
	//비로그인시 메인으로 이동
    if(userId==null||userId.equals("")){
%>
<script>
       alert("로그인이 필요합니다. 메인 페이지로 이동합니다.");
       window.location.href = "../main/main.jsp"; 
</script>
<%} %>
<body>
<div class="mypage-body">
    <div class="myprofile">
        <table class="profile-table">
            <tr>
                <% if(bean.getProfile() == null || bean.getProfile().equals("")) { %>
			    <th>
			        <img class="profile" alt="빈프로필" src="../img/profile/null_Profile.png?t=<%= System.currentTimeMillis() %>">
			    </th>
				<% } else { %>
				    <th>
				        <img class="profile" alt="프로필" src="../img/profile/<%= bean.getProfile() %>?t=<%= System.currentTimeMillis() %>">
				    </th>
				<% } %>

            </tr>
            <tr>
                <th><h3><%=bean.getName() %>님</h3></th>
            </tr>
            <tr style="margin-bottom: 50px;">
                <%if(bean.getMsg()==null) {%>
                <th>소개글이 없습니다.</th>
                <%} else { %>
                <th><%=bean.getMsg().replace("\n", "<br>") %></th>
                <%} %>
            </tr>
        </table>
    </div>
    
    <div class="mypage-div">
        <div class="mypage-ca">
            <a class="mypage-a <%= (category == null || category.equals("프로필관리")) ? "active" : "" %>" href="myPage.jsp?category=프로필관리">프로필 관리</a>
            <a class="mypage-a <%= (category != null && category.equals("알러지관리")) ? "active" : "" %>" href="myPage.jsp?category=알러지관리">알러지 관리</a>
            <a class="mypage-a <%= (category != null && category.equals("커뮤니티관리")) ? "active" : "" %>" href="../community/Community_Main.jsp">커뮤니티 관리</a>
            <a class="mypage-a <%= (category != null && category.equals("친구관리")) ? "active" : "" %>" href="myPage.jsp?category=친구관리">친구 관리</a>
        </div>
        
        <div class="mypage-info">
            <% if(category == null || category.equals("프로필관리")) { %>
                <h2>회원 정보 수정</h2>
                <form action="mypageProfile" method="post" enctype="multipart/form-data">
	                <div>
	                	<label class="" for="image">프로필 이미지 등록</label>
		       			<input type="file" id="image" name="image" accept="image/*">
				            <% if(bean.getProfile() != null && !bean.getProfile().isEmpty()) { %>
				                <p>현재 이미지: <%= bean.getProfile() %></p>
				            <% } %>  
	                </div>
	                
		            <div>
		                <label class="" for="introduce">소개글</label><br>
		                <%           
		                if(bean.getMsg()==null||bean.getMsg().equals("")){ %>
		                	<input type="text" id="introduce" name="introduce" value="소개글이 없습니다." required><br>
		                <%} else{%>
	      				<input type="text" id="introduce" name="introduce" value="<%= bean.getMsg() %>" required><br>
	      				<%} %>
		            </div>
		            <br>
		       			<button class="mypage-button" name="action" type="submit" value="update">수정하기</button>
		       			<button class="mypage-button" name="action" type="submit" value="delete" style="background-color: RED">사진삭제</button>
		       			<input type="hidden" name="userId" value="<%= userId %>">
	       			
                </form>
                
                <form action="updateUser" method="post">
                    <table>
                        <tr>
                            <td>이름:</td>
                            <td><input type="text" name="name" value="<%=bean.getName() %>" required></td>
                        </tr>
                        <tr>
                            <td>전화번호:</td>
                            <td><input type="text" name="phone" value="<%=bean.getPhone() %>" required></td>
                        </tr>
                        <tr>
                            <td>주소:</td>
                            <td><input type="text" name="address" value="<%=bean.getAddress() %>" required></td>
                        </tr>
                        <tr>
                            <td>생년월일:</td>
                            <td><input type="text" name="birth" value="<%=bean.getBirth() %>" required></td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: right;">
                                <button class="mypage-button" name="action" type="submit" value="update">수정하기</button>
		       					<button class="mypage-button" name="action" type="submit" value="delete" style="background-color: RED">탈퇴하기</button>
                            </td>
                        </tr>
                    </table>
                    <input type="hidden" name="userId" value="<%= userId %>">
                </form>
            <% } else if (category.equals("알러지관리")) { %>
           <div class="allergy">
		    <h3>먹을 수 없는 음식을 선택하세요.</h3><br>
				<form id="allergyForm" class="allergyForm" action="allergyUpdate" method="post">
				    <div>
				        <input type="button" value="견과류" class="allergy-btn" onclick="toggleAllergy(this.value)">
				        <input type="button" value="유제품" class="allergy-btn" onclick="toggleAllergy(this.value)">
				        <input type="button" value="계란" class="allergy-btn" onclick="toggleAllergy(this.value)">
				        <input type="button" value="생선" class="allergy-btn" onclick="toggleAllergy(this.value)">
				        <input type="button" value="갑각류" class="allergy-btn" onclick="toggleAllergy(this.value)">
				    </div>
				    <br>
				    <div class="input-row">
				        <input type="text" id="allergyInput" class="allergy-input" placeholder="음식 직접입력(음식이름을 입력해주셔야 합니다.)">
				        <input type="button" value="추가" class="allergy-plus" onclick="addAllergyFromInput()">
				    </div>
				    
				    <div>
				        <br><h3>기존 알러지</h3><br>
				        <div>
				            <% 
				            if(allergyMgr.selectAllergy(userId)!=null){
				            	 userAllergies=allergyMgr.selectAllergy(userId); 
				            }
				            for (int i = 0; i < userAllergies.length; i++) { %>
				                <input type="button" value="<%= userAllergies[i] %>" class="existing-allergy-btn" onclick="toggleAllergy(this.value)">
				            <% } %>
				        </div>
				        
				        <div>
				            <br><h3>수정 할 알러지</h3><br>
				            <div id="selectedAllergies"></div>
				        </div>
				        <div>
				            <input type="submit" value="수정" class="update-allergy-btn" onclick="updateAllergies()">
				            <input type="hidden" name="selectedAllergies" id="hiddenAllergies">
				            <input type="hidden" name="userId" id="userId" value="<%= session.getAttribute("userId") %>">
				        </div>
				    </div>
				</form>
		
		</div>

<script type="text/javascript">
    // 선택된 알러지를 저장할 배열
    var selectedAllergies = [];

    // 알러지를 토글하는 함수 (추가/삭제)
    function toggleAllergy(allergy) {
    // allergy가 selectedAllergies 배열에 있는지 확인
	    if (selectedAllergies.includes(allergy)) {
	        // 알러지가 배열에 있으면 제거
	        selectedAllergies = selectedAllergies.filter(item => item !== allergy);
	    } else {
	        // 알러지가 배열에 없으면 추가
	        selectedAllergies.push(allergy);
	    }
	    updateAllergyDisplay();
	}


    // 입력된 값을 추가하는 함수
    function addAllergyFromInput() {
        var allergy = document.getElementById("allergyInput").value;
        if (allergy.trim() === "") {
            alert("알러지 이름을 입력해주세요.");
            return;
        }
        toggleAllergy(allergy); // 입력한 값을 토글
        document.getElementById("allergyInput").value = ""; // 입력 필드를 비움
    }

    // 선택된 알러지를 화면에 표시하는 함수
    function updateAllergyDisplay() {
        var allergyContainer = document.getElementById("selectedAllergies");
        allergyContainer.innerHTML = ""; // 기존 내용 초기화

        // 선택된 알러지 배열을 순회하며 버튼으로 추가
        selectedAllergies.forEach(function(allergy) {
            var button = document.createElement("input");
            button.type = "button";
            button.value = allergy;
            button.className = "selected-allergy-btn"; // 버튼 스타일 지정 가능
            button.onclick = function() {
                toggleAllergy(allergy); // 클릭 시 알러지 토글 (제거)
            };
            allergyContainer.appendChild(button);
            
        });
    }

    // 초기화 함수 (기존 알러지 추가)
    function initializeAllergies() {
        <% for (int i = 0; i < userAllergies.length; i++) { %>
            toggleAllergy("<%= userAllergies[i] %>"); // 기존 알러지 추가
        <% } %>
    }
    
    function updateAllergies() {
        // 선택된 알러지 배열을 쉼표로 구분된 문자열로 변환
        document.getElementById("hiddenAllergies").value = selectedAllergies.join(",");
        // 폼을 제출
        document.getElementById("allergyForm").submit();
    }

    // 페이지 로드 시 초기화
    window.onload = initializeAllergies;
</script>

            <% } else if (category.equals("커뮤니티관리")) { %>
           		<form action="">
           			내 게시글 자리
           		</form>
            <% } else if (category.equals("친구관리")) { %>
                <h2>친구 관리</h2>
               	<div>
				    <form action="" method="post">
				        <input type="text" name="friendId" placeholder="친구추가할 사용자의 ID를 입력하세요" style="width: 300px;">
				        <button class="mypage-button" type="submit" class="search" style="color: black; background-color: white;">
				            <i class="fas fa-search"></i>
				        </button>
				    </form>
				        <%
				        String friendId = null;
				        friendId = request.getParameter("friendId");
				        String frname = mgr.frChk(friendId); 
				        if(friendId != null&&friendId.equals(userId)){
				        	out.println("<br>자기 자신을 친구 추가할 수 없습니다.");
				        } else{
				        %>
					   	<div>
					   	 <br>
					   	<%if(frname!=null) {%>
					   	<form action="friendPlus" method="post"> <!-- 추가하기 위한 별도 폼 -->
					   	 	친구이름: <%=frname %>
					   	 	<input type="hidden" name="userId" value="<%= userId %>">
			                <input type="hidden" name="friendId" value="<%= friendId %>">
			                <button class="mypage-button" type="submit">+</button>
			            </form>
					   	<%} else{ %>
					   	검색하신 아이디가 없습니다.
					   	<%} //--else%>
					   	</div>
					   	<%} //--else %>
					   	<form action="FriendAction" method="post">
					   		친구요청<br>
					   		<%
					   			Vector<String>vlist = new Vector<String>();
					   			vlist = mgr.frState(userId);
					   			for(int i=0; i<vlist.size(); i++){
					   		%>
					   		요청 아이디 :<%=vlist.get(i) %>
							<input type="hidden" name="friendId" value="<%= vlist.get(i)%>">
							<input type="hidden" name="userId" value="<%= userId %>">
				            <button class="mypage-button" type="submit" name="action" value="accept">수락</button>
				            <button class="mypage-button" type="submit" name="action" value="delete" style="background-color: red;">삭제</button>
					   		<br>
					   		<br>
					   		<%} %>
					   	</form>
					   	<form action="friendDelete" method="post">
					   	<table>
					   	<tr>
					   		<td>친구 목록</td>
					   	</tr>
					 		  	<%
					   				Vector<freindBean>frlist = new Vector<freindBean>();
					   				frlist = mgr.myFriend(userId);
					   				
					   				Vector<freindBean>tofrlist = new Vector<freindBean>();
					   				tofrlist = mgr.toMyfriend(userId);
					   				
					   				for(int i=0; i<frlist.size();i++){
					   					freindBean frbean = frlist.get(i);
					   			%>
					   		<tr>
					   			
					   			<td><%=frbean.getUserId() %></td>
					   			<td>
						   			<button class="mypage-button" type="button" onclick="viewFriendDiet('<%=frbean.getFriendId() %>')">식단관리</button>
						   			<button class="mypage-button" type="button" onclick="viewFriendExercise('<%=frbean.getFriendId() %>')">운동관리</button>
						   			<button class="mypage-button" name="action" value="delete" type="submit" style="background-color: red;">삭제</button>
						   			<input type="hidden" name="num" value="<%= frbean.getNum()%>">
					   			</td>
					   			</tr>	
					   			<%} for(int i=0; i<tofrlist.size();i++){
					   				freindBean frbean = tofrlist.get(i);
					   			%>
					   			<tr>
					   			<td><%=frbean.getFriendId() %></td>
					   			<td>
						   			<button class="mypage-button" type="button" onclick="viewFriendDiet('<%=frbean.getFriendId() %>')">식단관리</button>
						   			<button class="mypage-button" type="button" onclick="viewFriendExercise('<%=frbean.getFriendId() %>')">운동관리</button>
						   			<button class="mypage-button" name="action" value="delete" type="submit" style="background-color: red;">삭제</button>
						   			<input type="hidden" name="num" value="<%= frbean.getNum()%>">
					   			</td>
					   			</tr>
					   			<%} %>
					   		
					   	</table>
					   	
					   	</form>
				</div>
            <% }%>
        </div>
    </div>
</div>

<%@ include file="/chatbot/chatbot.jsp" %>
</body>
<script>
function viewFriendDiet(friendId) {
    window.location.href = '../diet/friendDiet.jsp?friendId=' + encodeURIComponent(friendId);
}

function viewFriendExercise(friendId) {
    window.location.href = '../exercise/friendExercise.jsp?friendId=' + encodeURIComponent(friendId);
}
</script>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
