package nutritionist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import DB.DBConnectionMgr;

public class nutritionistMgr {
	private DBConnectionMgr pool;

	public nutritionistMgr() {
		pool = DBConnectionMgr.getInstance();
	}

	public void insertRequest(nutritionistBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "insert tblnutritionist(userId, count, calorie, allergy, dontlike, requirement) values(?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getUserId());
			pstmt.setInt(2, bean.getCount());
			pstmt.setInt(3, bean.getCalorie());
			pstmt.setString(4, bean.getAllergy());
			pstmt.setString(5, bean.getDontlike());
			pstmt.setString(6, bean.getRequirement());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}

	public nutritionistBean isRequestExists(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		nutritionistBean bean = null;
		try {
			con = pool.getConnection();
			String sql = "SELECT * FROM tblnutritionist WHERE userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bean = new nutritionistBean();
				bean.setUserId(rs.getString("userId"));
				bean.setCount(rs.getInt("count"));
				bean.setCalorie(rs.getInt("calorie"));
				bean.setAllergy(rs.getString("allergy"));
				bean.setDontlike(rs.getString("dontlike"));
				bean.setRequirement(rs.getString("requirement"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}

	public ArrayList<nutritionistBean> requestList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		ArrayList<nutritionistBean> lists = new ArrayList<>();
		try {
			con = pool.getConnection();
			sql = "select userId, count, calorie, allergy, dontlike, requirement, chk, img from tblnutritionist order by chk asc, ntNum";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				nutritionistBean list = new nutritionistBean();
				list.setUserId(rs.getString("userId"));
				list.setCount(rs.getInt("count"));
				list.setCalorie(rs.getInt("calorie"));
				list.setAllergy(rs.getString("allergy"));
				list.setDontlike(rs.getString("dontlike"));
				list.setRequirement(rs.getString("requirement"));
				list.setChk(rs.getInt("chk"));
				list.setRequirement(rs.getString("requirement"));
				lists.add(list);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return lists;
	}

	public String getMealImage(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		String imagePath = null;
		try {
			con = pool.getConnection();
			sql = "SELECT img FROM tblnutritionist WHERE userId = ? AND chk = 1";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				imagePath = rs.getString("img");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return imagePath;
	}

	public void updateImage(String userId, String imagePath) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "UPDATE tblnutritionist SET img = ? WHERE userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, imagePath);
			pstmt.setString(2, userId);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}

	
	public void deleteResult(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "delete from tblnutritionist where userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
}
