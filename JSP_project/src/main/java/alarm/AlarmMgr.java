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
	
	 // 알림 저장
    public void addAlarm(AlarmBean alarm) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO tblalarm (userId, content, a_date, check_alarm) VALUES (?, ?, NOW(), 0)";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, alarm.getUserId());
            pstmt.setString(2, alarm.getContent());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt);
        }
    }

    // 특정 사용자의 읽지 않은 알림 조회
    public List<AlarmBean> getUnreadAlarms(String userId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<AlarmBean> alarmList = new ArrayList<>();
        String sql = "SELECT * FROM tblalarm WHERE userId = ? AND check_alarm = 0 ORDER BY a_date DESC";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                AlarmBean alarm = new AlarmBean();
                alarm.setAlarmNum(rs.getInt("alarm_num"));
                alarm.setUserId(rs.getString("userId"));
                alarm.setContent(rs.getString("content"));
                alarm.setaDate(rs.getDate("a_date"));
                alarm.setCheckAlarm(rs.getInt("check_alarm"));
                alarmList.add(alarm);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt, rs);
        }
        return alarmList;
    }

    // 알림 읽음 처리
    public void markAsRead(int alarmNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE tblalarm SET check_alarm = 1 WHERE alarm_num = ?";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, alarmNum);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt);
        }
    }

}
