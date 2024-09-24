package recipe;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;

public class UserAllergyMgr {
	private DBConnectionMgr pool;
	
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


