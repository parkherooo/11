package alarm;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mypage.freindBean;

@WebServlet("/alarm/FriendRequestServlet")
public class FriendRequestServlet extends HttpServlet {
    private DBConnectionMgr pool;

    @Override
    public void init() throws ServletException {
        pool = DBConnectionMgr.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청에서 friendId 파라미터를 가져옴
        String friendId = request.getParameter("friendId");
        String userId = (String) request.getSession().getAttribute("userId");  // 로그인된 사용자 ID 가져오기

        // friendId가 null이거나 비어있으면 에러 처리
        if (friendId == null || friendId.isEmpty()) {
            response.getWriter().println("친구 요청을 보낼 사용자를 선택하세요.");
            return;
        }

        // 친구 요청 데이터 추가
        freindBean friendRequest = new freindBean();
        friendRequest.setUserId(userId);     // 친구 요청을 보낸 사용자
        friendRequest.setFriendId(friendId); // 친구 요청을 받은 사용자

        try {
            // 친구 요청의 num 값 설정 (num > 0인 경우 친구 요청이 성공적)
            friendRequest.setNum(1);

            // 알림 추가
            addAlarm(friendId, "새로운 친구 요청이 도착했습니다.");

            response.getWriter().println("친구 요청이 " + friendId + "에게 전송되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("친구 요청 처리 중 오류가 발생했습니다.");
        }
    }

 // 알림 추가 메서드
    private void addAlarm(String friendId, String content) throws Exception {
        System.out.println("알림 추가 중... friendId: " + friendId + ", content: " + content);  // 로그 추가

        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO tblalarm (userId, content, a_date, check_alarm) VALUES (?, ?, NOW(), 0)";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, friendId);  // 친구 요청을 받은 사용자 ID
            pstmt.setString(2, content);   // 알림 내용

            int result = pstmt.executeUpdate();  // 쿼리 실행
            System.out.println("알림 추가 결과: " + result);  // 추가된 행 수를 로그로 출력
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt);
        }
    }
}
