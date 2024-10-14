package login;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import user.UserMgr;
import user.UserBean;

@WebServlet("/login/naverLogin")
public class NaverLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserMgr userMgr = new UserMgr();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        // 네이버 로그인 콜백으로 전달된 액세스 토큰 수신
        String accessToken = request.getParameter("accessToken");
        String loginPlatform = "NAVER"; // 로그인 플랫폼 설정
        
        if (accessToken != null && !accessToken.isEmpty()) {
            try {
                // 네이버 사용자 정보 요청
                String apiURL = "https://openapi.naver.com/v1/nid/me";
                URL url = new URL(apiURL);
                HttpURLConnection con = (HttpURLConnection) url.openConnection();
                con.setRequestMethod("GET");
                con.setRequestProperty("Authorization", "Bearer " + accessToken);

                int responseCode = con.getResponseCode();
                if (responseCode == 200) {
                    BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
                    StringBuilder responseBuilder = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        responseBuilder.append(line);
                    }
                    br.close();

                    // JSON 파싱 및 사용자 정보 추출
                    String responseBody = responseBuilder.toString();

                    // JSON 문자열 수동 파싱
                    String naverUserId = extractValue(responseBody, "email");
                    String naverName = extractValue(responseBody, "name");

                    if (naverUserId != null && naverName != null) {
                        // 사용자가 다른 소셜 플랫폼으로 가입되어 있는지 확인
                        if (userMgr.isSocialUserExist(naverUserId, "KAKAO")) {
                        	// 이미 KAKAO로 가입된 사용자라면 경고 메시지 표시
                            response.setContentType("text/html; charset=UTF-8");
                            response.getWriter().write("<script>alert('이미 카카오 계정으로 가입되어 있습니다. 해당 계정으로 로그인해주세요.'); location.href='" + request.getContextPath() + "/login/logIn.jsp';</script>");
                            return;
                        }
                        
                        // 현재 플랫폼으로 사용자가 존재하는 경우
                        if (userMgr.isSocialUserExist(naverUserId, loginPlatform)) {
                            // 세션 설정 및 메인 페이지로 이동
                            request.getSession().setAttribute("userId", naverUserId);
                            request.getSession().setAttribute("name", naverName);
                            request.getSession().setAttribute("loginPlatform", loginPlatform);
                            response.sendRedirect(request.getContextPath() + "/main/main.jsp");
                        } else {
                            // 사용자가 존재하지 않으면 새로 등록하고 추가 정보 입력 페이지로 이동
                            UserBean user = new UserBean();
                            user.setUserId(naverUserId);
                            user.setName(naverName);
                            user.setLoginPlatform(loginPlatform);
                            userMgr.insertSocialUser(user);

                            request.getSession().setAttribute("userId", naverUserId);
                            request.getSession().setAttribute("name", naverName);
                            request.getSession().setAttribute("loginPlatform", loginPlatform);
                            response.sendRedirect(request.getContextPath() + "/login/additionalInfo.jsp");
                        }
                    } else {
                        System.out.println("Failed to extract email or name from response.");
                        response.sendRedirect(request.getContextPath() + "/login/logIn.jsp?error=naver_login_failed");
                    }
                } else {
                    System.out.println("Failed to get user info. Response Code: " + responseCode);
                    response.sendRedirect(request.getContextPath() + "/login/logIn.jsp?error=naver_login_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/login/logIn.jsp?error=naver_login_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login/logIn.jsp?error=naver_login_failed");
        }
    }

    // JSON 문자열에서 특정 키의 값을 추출하는 메서드
    private String extractValue(String jsonString, String key) {
        String value = null;
        String keyPattern = "\"" + key + "\":\"(.*?)\"";
        Pattern pattern = Pattern.compile(keyPattern);
        Matcher matcher = pattern.matcher(jsonString);
        if (matcher.find()) {
            value = matcher.group(1);
            try {
                // 유니코드 문자열을 직접 변환
                value = decodeUnicodeSequence(value);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return value;
    }

    // 유니코드 시퀀스를 디코딩하는 메서드 추가
    private String decodeUnicodeSequence(String unicodeString) {
        StringBuilder result = new StringBuilder();
        int len = unicodeString.length();
        for (int i = 0; i < len; i++) {
            char ch = unicodeString.charAt(i);
            if (ch == '\\' && i + 5 < len && unicodeString.charAt(i + 1) == 'u') {
                // 유니코드 형식인 경우 처리
                String hex = unicodeString.substring(i + 2, i + 6);
                try {
                    int unicode = Integer.parseInt(hex, 16);
                    result.append((char) unicode);
                    i += 5;
                } catch (NumberFormatException e) {
                    result.append(ch);
                }
            } else {
                result.append(ch);
            }
        }
        return result.toString();
    }
}
