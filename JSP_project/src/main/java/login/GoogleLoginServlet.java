package login;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserBean;
import user.UserMgr;

import org.json.JSONObject;

@WebServlet("/login/googleLogin")
public class GoogleLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserMgr userMgr = new UserMgr();
    
    private static final String CLIENT_ID = "836482052470-id0fefcrsaem3numcbn25sjbmbju3r5j.apps.googleusercontent.com";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Google ID Token을 받는다.
        String idTokenString = request.getParameter("idToken");
        
        try {
            // Google의 OAuth2 토큰 정보 검증 URL
            String validationUrl = "https://oauth2.googleapis.com/tokeninfo?id_token=" + idTokenString;
            URL url = new URL(validationUrl);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            int responseCode = con.getResponseCode();
            if (responseCode == 200) {
                BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
                StringBuilder responseBuilder = new StringBuilder();
                String inputLine;

                while ((inputLine = in.readLine()) != null) {
                    responseBuilder.append(inputLine);
                }
                in.close();
                
                // JSON 문자열 파싱
                String responseBody = responseBuilder.toString();
                JSONObject json = new JSONObject(responseBody);
                
                // 이메일 및 사용자 이름 추출
                String userId = json.getString("email"); // 이메일 주소를 userId로 사용
                String name = json.getString("name"); // 사용자 이름
                String loginPlatform = "GOOGLE";
                
                UserBean userBean = new UserBean();
                userBean.setUserId(userId); // 이메일을 userId로 사용
                userBean.setName(name);
                userBean.setLoginPlatform(loginPlatform);

                // 사용자 존재 여부 확인 및 저장
                if (userMgr.isSocialUserExist(userId, loginPlatform)) {
                    request.getSession().setAttribute("userId", userId);
                    request.getSession().setAttribute("name", name);
                    request.getSession().setAttribute("loginPlatform", loginPlatform);
                    response.sendRedirect(request.getContextPath() + "/main/main.jsp");
                } else {
                    userMgr.insertSocialUser(userBean);
                    request.getSession().setAttribute("userId", userId);
                    request.getSession().setAttribute("name", name);
                    request.getSession().setAttribute("loginPlatform", loginPlatform);
                    response.sendRedirect(request.getContextPath() + "/login/additionalInfo.jsp");
                }
            } else {
                System.out.println("Failed to validate ID token. Response Code: " + responseCode);
                response.sendRedirect(request.getContextPath() + "/login/logIn.jsp?error=google_login_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login/logIn.jsp?error=google_login_failed");
        }
    }
}
