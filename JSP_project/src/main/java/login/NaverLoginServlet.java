package login;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/login/naverLogin")
public class NaverLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clientId = "w345Zx3BXiwPQv_AAe9S"; // 애플리케이션 클라이언트 아이디값
        String clientSecret = "ue0orzDpdm"; // 애플리케이션 클라이언트 시크릿값
        String code = request.getParameter("code");
        String state = request.getParameter("state");
        String redirectURI = URLEncoder.encode("http://localhost/JSP_project/login/naverLogin", "UTF-8");
        String apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
        apiURL += "client_id=" + clientId;
        apiURL += "&client_secret=" + clientSecret;
        apiURL += "&redirect_uri=" + redirectURI;
        apiURL += "&code=" + code;
        apiURL += "&state=" + state;
        
        System.out.println("Naver Login - Code: " + code);
        System.out.println("Naver Login - State: " + state);
        System.out.println("Token Request URL: " + apiURL);

        try {
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            int responseCode = con.getResponseCode();
            BufferedReader br;

            // 로그 응답 코드
            System.out.println("Response Code: " + responseCode);

            if (responseCode == 200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            
            String inputLine;
            StringBuffer res = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                res.append(inputLine);
            }
            br.close();
            
            // 반환된 결과 확인 및 로그 출력
            System.out.println("Response Content: " + res.toString());

            if (responseCode == 200) {
                // 로그인을 성공한 경우 main 페이지로 리다이렉트
                System.out.println("Token obtained successfully!");
                response.sendRedirect("../main/main.jsp");
            } else {
                // 로그인 실패 시 에러 처리 및 로그 출력
                System.out.println("Error in token request. Response: " + res.toString());
                response.sendRedirect("../login/naverLogin?error=true");
            }
        } catch (Exception e) {
            // 예외 발생 시 콘솔에 스택 트레이스 출력
            System.out.println("Exception occurred during token request.");
            e.printStackTrace();
            response.sendRedirect("../login/naverLogin?error=true");
        }
    }
}
