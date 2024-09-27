package user;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.http.HttpSession;

import DB.DBConnectionMgr;

public class UserMgr {
	private DBConnectionMgr pool;
	
	public UserMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 비밀번호 암호화 (SHA-256 해시 생성) 
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
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
            
            // 비밀번호를 해싱하여 저장
            String hashedPassword = hashPassword(bean.getPwd());
            pstmt.setString(3, hashedPassword);
            
            pstmt.setString(4, bean.getBirth());
            pstmt.setString(5, bean.getPhone());
            pstmt.setString(6, bean.getAddress());
            pstmt.setString(7, bean.getAllergy());
            pstmt.setFloat(8, bean.getHeight());
            pstmt.setFloat(9, bean.getWeight());
            pstmt.setInt(10, bean.getGender());
			if(pstmt.executeUpdate()==1)
				flag = true;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	// 로그인
	public boolean loginUser(String userId, String pwd, HttpSession session) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    boolean flag = false;
	    try {
	        con = pool.getConnection();
	        // 입력된 비밀번호를 해싱
	        String hashedPassword = hashPassword(pwd);
	        // 이름과 사용자 ID를 가져옴
	        sql = "SELECT name FROM tbluser WHERE userId = ? AND pwd = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.setString(2, hashedPassword);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            String name = rs.getString("name");
	            // 로그인 성공 시 세션에 이름 저장
	            session.setAttribute("userId", userId);
	            session.setAttribute("name", name);
	            flag = true; // 로그인 성공
	        }
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
	
	// 전화번호 중복 체크
    public boolean phoneChk(String phone) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        boolean flag = false;
        try {
            con = pool.getConnection();
            sql = "SELECT phone FROM tbluser WHERE phone = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, phone);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                flag = true; // 중복된 전화번호가 존재
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return flag;
    }
    
    // 아이디 찾기
    public String findUserId(String name, String phone) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String foundId = null;

        try {
            con = pool.getConnection();
            String sql = "SELECT userId FROM tbluser WHERE name = ? AND phone = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, phone);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                foundId = rs.getString("userId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        
        return foundId;
    }
    
 // 비밀번호 재설정
    public boolean resetPassword(String userId, String newPassword) {
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean isSuccess = false;

        try {
            con = pool.getConnection();
            String hashedPwd = hashPassword(newPassword);
            String sql = "UPDATE tbluser SET pwd = ? WHERE userId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, hashedPwd);
            pstmt.setString(2, userId);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                isSuccess = true;
            } else {
                System.out.println("Password reset failed: No rows updated.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        return isSuccess;
    }


}
