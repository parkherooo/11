package alarm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import community.DBConnectionMgr;

public class AlarmMgr {
	private DBConnectionMgr pool;

	public AlarmMgr() {
	    pool = DBConnectionMgr.getInstance();
	}
	
	 // 알림 추가 메소드
	 public void addAlarm(String userId, String content) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        String sql = "INSERT INTO tblalarm (userId, content, a_date, check_alarm) VALUES (?, ?, NOW(), 0)";

	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, userId);  // 친구 요청을 받은 사용자 ID
	            pstmt.setString(2, content);  // 알림 내용

	            pstmt.executeUpdate();  // 쿼리 실행
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            pool.freeConnection(conn, pstmt);  // 자원 해제
	        }
	    }
	
    // 알람 중복 확인 메소드
    public boolean isAlarmExists(String friendId, String content) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean exists = false;

        try {
            conn = pool.getConnection();
            String sql = "SELECT COUNT(*) FROM alarm WHERE receiverId = ? AND content = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, friendId);
            pstmt.setString(2, content);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                exists = rs.getInt(1) > 0; // 알람이 존재하는지 여부
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
        	pool.freeConnection(conn, pstmt, rs); 
        }

        return exists;
    }
    

    // 사용자 ID로 알림 목록을 가져오는 메소드
    public List<AlarmBean> getAlarms(String userId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AlarmBean> alarmList = new ArrayList<>();
        String sql = "SELECT * FROM tblalarm WHERE userId = ? AND check_alarm = 0";

        try {
            conn = pool.getConnection();  // DB 연결
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                AlarmBean alarm = new AlarmBean();
                alarm.setAlarm_num(rs.getInt("alarm_num"));
                alarm.setUserId(rs.getString("userId"));
                alarm.setContent(rs.getString("content"));
                alarm.setA_date(rs.getDate("a_date"));
                alarm.setCheck_alarm(rs.getInt("check_alarm"));
                alarmList.add(alarm);  // 알림 리스트에 추가
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt, rs);  // 자원 해제
        }

        return alarmList;
    }

    // 알림 확인 상태를 업데이트하는 메소드
    public void checkAlarm(int alarm_num) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE tblalarm SET check_alarm = 1 WHERE alarm_num = ?";

        try {
            conn = pool.getConnection();  // DB 연결
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, alarm_num);
            
            pstmt.executeUpdate();  // 알림 확인 상태 업데이트
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt);  // 자원 해제
        }
    }
    
    
    public List<AlarmBean> getUnreadAlarms(String userId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AlarmBean> alarmList = new ArrayList<>();
        String sql = "SELECT * FROM tblalarm WHERE userId = ? AND check_alarm = 0"; // 확인되지 않은 알림만 가져옴

        try {
            conn = pool.getConnection();  // DB 연결
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                AlarmBean alarm = new AlarmBean();
                alarm.setAlarm_num(rs.getInt("alarm_num"));
                alarm.setUserId(rs.getString("userId"));
                alarm.setContent(rs.getString("content"));
                alarm.setA_date(rs.getDate("a_date"));
                alarm.setCheck_alarm(rs.getInt("check_alarm"));
                alarmList.add(alarm);  // 새로운 알림을 리스트에 추가
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt, rs);
        }

        return alarmList;
    }

    
    
    
    // 알림을 삭제메소드
    public boolean deleteAlarm(int alarm_num) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM tblalarm WHERE alarm_num = ?";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, alarm_num);
            
            int result = pstmt.executeUpdate();  // 삭제된 행의 수를 반환
            return result > 0;  // 삭제가 성공하면 true 반환
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            pool.freeConnection(conn, pstmt);
        }
    }
    
    //알림 읽음 처리 메서드
    public boolean markAsRead(int alarm_num) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE tblalarm SET check_alarm = 1 WHERE alarm_num = ?";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, alarm_num);

            int result = pstmt.executeUpdate();
            return result > 0;  
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            pool.freeConnection(conn, pstmt);
        }
    }
    
    // 새로운 알림이 있는지 확인하는 메소드
    public int getUnreadAlarmCount(String userId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int unreadCount = 0;
        String sql = "SELECT COUNT(*) FROM tblalarm WHERE userId = ? AND check_alarm = 0"; // 읽지 않은 알림의 개수를 가져옴

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                unreadCount = rs.getInt(1); // 읽지 않은 알림의 개수를 저장
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt, rs);
        }

        return unreadCount;
    }
    
      
    // 알림을 데이터베이스에서 가져오는 메소드
    public List<AlarmBean> getNotifications(String userId) throws Exception {
        List<AlarmBean> notifications = new ArrayList<>();
        String sql = "SELECT * FROM tblalarm WHERE userId = ? AND check_alarm = 0";

        try (Connection conn = pool.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                AlarmBean alarm = new AlarmBean();
                alarm.setAlarm_num(rs.getInt("alarm_num"));
                alarm.setUserId(rs.getString("userId"));
                alarm.setContent(rs.getString("content"));
                alarm.setA_date(rs.getDate("a_date"));
                alarm.setCheck_alarm(rs.getInt("check_alarm"));
                notifications.add(alarm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return notifications;
    }

    
    // 확인되지 않은 알림을 가져오는 메소드
    public List<AlarmBean> getUnseenAlarms(String userId) throws Exception {
        List<AlarmBean> unseenAlarms = new ArrayList<>();
        String sql = "SELECT * FROM tblalarm WHERE userId = ? AND check_alarm = 0";
        
        try (Connection conn = pool.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AlarmBean alarm = new AlarmBean();
                alarm.setAlarm_num(rs.getInt("alarm_num"));
                alarm.setUserId(rs.getString("userId"));
                alarm.setContent(rs.getString("content"));
                alarm.setA_date(rs.getDate("a_date"));
                alarm.setCheck_alarm(rs.getInt("check_alarm"));
                unseenAlarms.add(alarm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return unseenAlarms;
    }
    
    // 알림의 check_alarm 값을 1로 업데이트하는 메서드
    public boolean updateCheckAlarm(int alarmNum) throws Exception {
        String sql = "UPDATE tblalarm SET check_alarm = 1 WHERE alarm_num = ?";
        try (Connection conn = pool.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, alarmNum);
            int updatedRows = pstmt.executeUpdate();  // 업데이트된 행의 수 반환
            return updatedRows > 0;  // 업데이트 성공 여부 반환
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
    