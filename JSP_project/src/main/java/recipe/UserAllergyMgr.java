package recipe;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;

public class UserAllergyMgr {
	private DBConnectionMgr pool;
	//알러지 ,으로 나눠서 배열로 가져오기
	public UserAllergyMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	public String[] selectAllergy(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		String[] allergies = null;
		try {
			con = pool.getConnection();
			sql = "select allergy from tbluser where userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs=pstmt.executeQuery();
			if (rs.next()) {
                String allergyStr = rs.getString("allergy");
               
                if(allergyStr.equals("")) {
                	allergyStr="없음";
                }
                allergies = allergyStr.split(","); 
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return allergies;
	}
	
}


