<%@page import="challenge.ChallengeMgr"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	String userId = request.getParameter("userId");
	int challengeId = Integer.parseInt(request.getParameter("num"));
	ChallengeMgr challmgr = new ChallengeMgr();
%>
<%
if(userId==null){
	 out.println("<script>");
	 out.println("alert('로그인하세요.')");
	 out.println("window.close();");
	 out.println("</script>");
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>챌린지 참여</title>
<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: 'Arial', sans-serif;
        background-color: #f0f0f0;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        padding: 10px;
    }

    h1 {
        text-align: center;
        color: #333;
        margin-bottom: 20px;
    }

    form {
        background-color: #fff;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        width: 100%;
        max-width: 400px;
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    label {
        font-weight: bold;
        margin-bottom: 5px;
        color: #555;
    }

    input[type="text"],
    input[type="file"] {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
        width: 100%;
    }

    button {
        padding: 12px;
        background-color: black;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s;
        width: 48%;
    }

    button[type="reset"] {
        background-color: #f44336;
    }

    button:hover {
        background-color: #0056b3;
    }

    button[type="reset"]:hover {
        background-color: #d32f2f;
    }

    .button-group {
        display: flex;
        justify-content: space-between;
    }

    @media (max-width: 600px) {
        form {
            padding: 15px;
        }

        button {
            width: 100%;
        }

        .button-group {
            flex-direction: column;
            gap: 10px;
        }
    }
</style>
</head>
<body>
 
    <form action="challengeparticipants" method="post" enctype="multipart/form-data">
  	  <h1>챌린지 참여</h1>
        <label for="coment">챌린지 참여 멘트</label>
        <input type="text" id="coment" name="coment" required>
        
        <label for="image">이미지 업로드</label>
        <input type="file" id="image" name="image" accept="image/*">
        
        <div class="button-group">
            <button type="submit">작성하기</button>
            <button type="reset">다시쓰기</button>
        </div>
        
        <input type="hidden" name="challengeId" value="<%=challengeId%>">
        <input type="hidden" name="userId" value="<%=userId%>">
    </form>
</body>
</html>

