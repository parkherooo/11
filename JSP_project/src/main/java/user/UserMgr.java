package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.DBConnectionMgr;

public class UserMgr {
	private DBConnectionMgr pool;
	
	public UserMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 회원가입
	public boolean insertUser(UserBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null; 
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "INSERT INTO tbluser (userId, name, pwd, birth, phone, address, allergy, height, weight, gender) "
	                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getUserId());
            pstmt.setString(2, bean.getName());
            pstmt.setString(3, bean.getPwd());
            pstmt.setString(4, bean.getBirth());
            pstmt.setString(5, bean.getPhone());
            pstmt.setString(6, bean.getAddress());
            pstmt.setString(7, bean.getAllergy());
            pstmt.setFloat(8, bean.getHeight());
            pstmt.setFloat(9, bean.getWeight());
            pstmt.setInt(10, bean.getGender());
            System.out.println("Executing SQL: " + pstmt.toString());
			if(pstmt.executeUpdate()==1)
				flag = true;

		} catch (Exception e) {
			e.printStackTrace();
			// 추가적으로 JSP 페이지에 에러 메시지를 출력
			// System.out.println("<script>alert('회원가입에 실패했습니다. 오류 메시지: " + e.getMessage() + "'); history.back();</script>");
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	// 로그인
	public boolean loginUser(String userId, String pwd) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "SELECT userId FROM tbluser WHERE userId = ? AND pwd = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
            pstmt.setString(2, pwd);
			rs = pstmt.executeQuery();
			if(rs.next())
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}
	
	// ID 중복 체크
	public boolean idChk(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "SELECT userId FROM tbluser WHERE userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next())
				flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}
}
