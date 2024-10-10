package exercise;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import DB.DBConnectionMgr;

public class GoalRecordMgr {
	private DBConnectionMgr pool;


	public GoalRecordMgr() {
		try {
			pool = DBConnectionMgr.getInstance();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	public void insertRecord(GoalRecordBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "insert tblgoalrecord values(null, ?, ?, ?, ?, ?, ?, ?, now())";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1,bean.getUserId());
			pstmt.setFloat(2, bean.getHeight());
			pstmt.setFloat(3, bean.getWeight());
			pstmt.setFloat(4, bean.getFat());
			pstmt.setFloat(5, bean.getMuscle());
			pstmt.setFloat(6, bean.getPercentage());
			pstmt.setString(7, bean.getImg());
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	
	public ArrayList<GoalRecordBean> selectRecord(String userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    ArrayList<GoalRecordBean> records = new ArrayList<>(); // ArrayList 생성
	    try {
	        con = pool.getConnection();
	        sql = "SELECT grDate, height, weight, fat, muscle, percentage, img FROM tblgoalrecord WHERE userId = ? ORDER BY grNum DESC LIMIT 3";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, userId); // userId를 설정
	        rs = pstmt.executeQuery();

	        // 결과를 ArrayList에 저장
	        while (rs.next()) {
	            GoalRecordBean record = new GoalRecordBean();
	            record.setGrDate(rs.getDate("grDate")); // grDate 설정
	            record.setHeight(rs.getFloat("height")); // height 설정
	            record.setWeight(rs.getFloat("weight")); // weight 설정
	            record.setFat(rs.getFloat("fat")); // fat 설정
	            record.setMuscle(rs.getFloat("muscle")); // muscle 설정
	            record.setPercentage(rs.getFloat("percentage")); // percentage 설정
	            record.setImg(rs.getString("img"));
	            records.add(record); // ArrayList에 추가
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	pool.freeConnection(con, pstmt, rs);
	    }
	    return records; // ArrayList 반환
	}

}
