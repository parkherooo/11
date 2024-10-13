package diet;
import java.sql.*;
import org.json.simple.JSONObject;
import java.util.logging.Logger;
import java.util.logging.Level;

public class DietMgr {
    private static final String DB_URL = "jdbc:mysql://113.198.238.93/fittime?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";
    private static final Logger logger = Logger.getLogger(DietMgr.class.getName());

    public JSONObject getFriendDiet(String userId, String selectedDate) {
        JSONObject jsonResult = new JSONObject();
        logger.info("Fetching diet for userId: " + userId + " on date: " + selectedDate);

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement("SELECT diet, calorie FROM tblDietaryRecords WHERE userId = ? AND drDate = ?")) {
            
            pstmt.setString(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));
            
            logger.info("Executing query: " + pstmt.toString());
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String diet = rs.getString("diet");
                    int calorie = rs.getInt("calorie");
                    jsonResult.put("diet", diet);
                    jsonResult.put("calories", calorie);
                    logger.info("Data found: diet = " + diet + ", calorie = " + calorie);
                } else {
                    jsonResult.put("message", "No data found for the selected date");
                    logger.info("No data found for userId: " + userId + " on date: " + selectedDate);
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error fetching diet data", e);
            jsonResult.put("error", "데이터를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
        }

        logger.info("Returning result: " + jsonResult.toJSONString());
        return jsonResult;
    }
}