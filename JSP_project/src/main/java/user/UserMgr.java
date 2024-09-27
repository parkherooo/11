package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;
import mypage.freindBean;

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
	//마이페이지 유저 정보
	public UserBean myInfo(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		UserBean bean = new UserBean();
		try {
			con = pool.getConnection();
			sql = "select * from tbluser where userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) { 
				bean.setUserId(rs.getString("userId"));
				bean.setName(rs.getString("name"));
				bean.setPwd(rs.getString("pwd"));
				bean.setBirth(rs.getString("birth"));
				bean.setPhone(rs.getString("phone"));
				bean.setAddress(rs.getString("address"));
				bean.setAllergy(rs.getString("allergy"));
				bean.setHeight(rs.getFloat("height"));
				bean.setWeight(rs.getFloat("weight"));
				bean.setProfile(rs.getString("profile"));
				bean.setGender(rs.getInt("gender"));
				bean.setMsg(rs.getString("msg"));
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
	//알러지 수정
	public boolean updateAllergy(String userId, String Allergy) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update tbluser set allergy = ? where userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, Allergy);
			pstmt.setString(2, userId);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//친구아이디 존재 확인 후 이름 반환
	public String frChk(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		String frname = null;
		try {
			con = pool.getConnection();
			sql = "SELECT name FROM tbluser WHERE userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next())
				frname = rs.getString(1);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return frname;
	}
	
	//친구 추가
	public boolean frPlus(String userId, String frId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert tblfriend values(null,?,?,0)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, frId);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	//친구 요청여부 확인
	public boolean frplusChk(String userId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		boolean flag =false;
		try {
			con = pool.getConnection();
			sql = "select * from tblfriend where friendId = ? and frcheck = 0";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) { 
				flag = true;
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return flag;
	}
	
	
	//친구 요청 리스트
	public Vector<String> frState (String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<String> vlist = new Vector<String>();
		try {
			con = pool.getConnection();
			sql = "select userId from tblfriend where friendId = ? and frcheck = 0";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				String frId = rs.getString(1);
				vlist.addElement(frId);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	
	//친구 수락
	public boolean frOk(String userId, String frId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update tblfriend set frcheck = 1 where friendId = ? and userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, frId);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//친구 요청 삭제
	public boolean frDelete(String userId, String frId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from tblfriend where friendId = ? and userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, frId);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//수락한 친구 리스트
	public Vector<freindBean> myFriend (String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<freindBean> vlist = new Vector<freindBean>();
		try {
			con = pool.getConnection();
			sql = "select num,userId from tblfriend where friendId = ? and frcheck = 1";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				freindBean bean = new freindBean();
				bean.setNum(rs.getInt(1));
				bean.setUserId(rs.getString(2));
				vlist.addElement(bean);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	//수락받은 친구 리스트
	public Vector<freindBean> toMyfriend (String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<freindBean> vlist = new Vector<freindBean>();
		try {
			con = pool.getConnection();
			sql = "select num,friendId from tblfriend where userId = ? and frcheck = 1";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				freindBean bean = new freindBean();
				bean.setNum(rs.getInt(1));
				bean.setFriendId(rs.getString(2));
				vlist.addElement(bean);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	//친구삭제
	public boolean freindDelete(int num) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from tblfriend where num =?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
}
