package exercise;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;

public class ExerciseGoalMgr {
	private DBConnectionMgr pool;
	
	public ExerciseGoalMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// insert tblexercisegoal values(null, userId, goalweight, sdate, edate, mypromise)
	public void insertGoal(ExerciseGoalBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "insert tblexercisegoal values(null, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getUserId());
			pstmt.setString(2, bean.getGoalweight());
			pstmt.setString(3, bean.getSdate());
			pstmt.setString(4, bean.getEdate());
			pstmt.setString(5, bean.getMypromise());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	// select goalweight, sdate, edate, inbody, mypromise from tblexercisegoal where userId=?
	public ExerciseGoalBean selectGoal(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		ExerciseGoalBean bean = new ExerciseGoalBean();
		try {
			con = pool.getConnection();
			sql = "select goalweight, sdate, edate, mypromise from tblexercisegoal where userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				bean.setGoalweight(rs.getString(1));
				bean.setSdate(rs.getString(2));
				bean.setEdate(rs.getString(3));
				bean.setMypromise(rs.getString(4));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
	
	// delete from tblexercisegoal where userId = ?
	public void deleteGoal(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "delete from tblexercisegoal where userId = ?";
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
