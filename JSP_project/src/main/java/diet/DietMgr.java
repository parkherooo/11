package diet;

import java.sql.*;
import org.json.simple.JSONObject;

public class DietMgr {
    private static final String DB_URL = "jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    public JSONObject getFriendDiet(String userId, String selectedDate) {
        JSONObject jsonResult = new JSONObject();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement("SELECT diet, calorie FROM tblDietaryRecords WHERE userId = ? AND drDate = ?")) {
            
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    jsonResult.put("diet", rs.getString("diet"));
                    jsonResult.put("calories", rs.getInt("calorie"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResult.put("error", "데이터를 불러오는 중 오류가 발생했습니다.");
        }

        return jsonResult;
    }
}