<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fit Time</title>
<link rel="stylesheet" href="../css/main.css">
<script>
    function findId() {
        const name = document.getElementById("name").value.trim();
        const phone = document.getElementById("phone").value.trim();
        
        // 유효성 검사 (기본적인 이름 및 전화번호 확인)
        if (name === "" || phone === "") {
            alert("이름과 전화번호를 모두 입력해주세요.");
            return false;
        }
        document.getElementById("findIdForm").submit();
    }
</script>
</head>
<body>
<%@ include file="../main/header.jsp" %>
    <section class="find-id-section">
        <h1>아이디 찾기</h1>
        <form id="findIdForm" action="findId" method="post" class="find-id-form">
            <input type="text" id="name" name="name" placeholder="이름 입력" required><br>
            <input type="text" id="phone" name="phone" placeholder="전화번호 입력 (예: 01012345678)" required><br>
            <button type="button" class="find-id-btn" onclick="findId()">아이디 찾기</button>
            <div class="options">
                <a href="../signup/signUp.jsp">회원가입</a> | <a href="findId.jsp">아이디 찾기</a> | <a href="findPwd.jsp">비밀번호 찾기</a>
            </div>
        </form>
        <div class="result-message" id="resultMessage">
            <% 
                String foundId = (String) request.getAttribute("foundId");
                String loginPlatform = (String) request.getAttribute("loginPlatform");
                boolean searchPerformed = request.getAttribute("searchPerformed") != null;

                if (searchPerformed) {
                    if (foundId != null && !foundId.isEmpty()) {
                        if (loginPlatform != null) {
            %>
                            <p>등록하신 아이디는 <%= foundId %>입니다.<br> 해당 아이디는 <%= loginPlatform %> 로그인으로 가입된 계정입니다.</p>
            <% 
                        } else {
            %>
                            <p>등록하신 아이디는 <%= foundId %>입니다.</p>
            <% 
                        }
                    } else {
            %>
                        <p>아이디를 찾을 수 없습니다.</p>
            <% 
                    }
                }
            %>
        </div>
    </section>
<%@ include file="../chatbot/chatbot.jsp" %>
<%@ include file="../main/footer.jsp" %>
</body>
</html>
