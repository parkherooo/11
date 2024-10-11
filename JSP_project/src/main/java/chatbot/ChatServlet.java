package chatbot;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;
import org.json.JSONObject;

@WebServlet("/ChatServlet")
public class ChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	String question = request.getParameter("question");

        // OpenAI GPT API 호출
        String gptResponse = callOpenAIGPTAPI(question);

        // 응답을 클라이언트로 전송
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write(gptResponse);
    }

    private String callOpenAIGPTAPI(String question) {
        String apiKey = "";  // OpenAI에서 발급받은 API 키
        String endpoint = "https://api.openai.com/v1/chat/completions";
        String gptResponse = "";

        try {
        	Thread.sleep(1000);
            URL url = new URL(endpoint);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + apiKey);
            conn.setRequestProperty("Content-Type", "application/json");

            // GPT API에 보낼 요청 데이터
            JSONObject jsonRequest = new JSONObject();
            jsonRequest.put("model", "gpt-3.5-turbo");
            jsonRequest.put("messages", new JSONObject[]{ new JSONObject().put("role", "user").put("content", question) });
            jsonRequest.put("max_tokens", 500);

            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            os.write(jsonRequest.toString().getBytes());
            os.flush();
            os.close();

            // GPT의 응답 읽기
            int responseCode = conn.getResponseCode();
            if (responseCode == 429) {
                gptResponse = "요청이 너무 많습니다. 잠시 후에 다시 시도해 주세요.";
            } else {
                // 응답 읽기
                Scanner scanner = new Scanner(conn.getInputStream());
                while (scanner.hasNext()) {
                    gptResponse += scanner.nextLine();
                }
                scanner.close();

            // 응답에서 텍스트 추출
            JSONObject jsonResponse = new JSONObject(gptResponse);
            gptResponse = jsonResponse.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content");
            }
        } catch (Exception e) {
            e.printStackTrace();
            gptResponse = "API 호출 중 오류가 발생했습니다.";
        }

        return gptResponse;
    }
}
