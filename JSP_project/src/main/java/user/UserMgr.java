package user;


import java.security.MessageDigest;

import java.io.File;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import com.oreilly.servlet.MultipartRequest;

import javax.servlet.http.HttpSession;

import DB.DBConnectionMgr;
import mypage.freindBean;
import notice.NoticeBean;

public class UserMgr {
	private DBConnectionMgr pool;
	public static final String SAVEFOLDER = "C:\\JSP_project\\JSP_project\\src\\main\\webapp\\img\\profile";
	public static final String ENCODING = "UTF-8";
	public static final int MAXSIZE = 1202*1024*50;
	
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

    ////////////// 소셜 로그인 //////////////////
    // 소셜 사용자 최초 가입 (기본 정보만 저장)
    public boolean insertSocialUser(UserBean bean) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String sql = null; 
        boolean flag = false;
        try {
            con = pool.getConnection();
            sql = "INSERT INTO tbluser (userId, name, loginPlatform) VALUES (?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getUserId());
            pstmt.setString(2, bean.getName());
            pstmt.setString(3, bean.getLoginPlatform()); // 로그인 플랫폼 추가

            if (pstmt.executeUpdate() == 1) {
                flag = true; // 사용자 추가 성공
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        return flag;
    }

    // 추가 정보 입력
    public boolean updateSocialUser(UserBean bean) {
        Connection con = null;
        PreparedStatement pstmt = null;
        String sql = null;
        boolean flag = false;
        try {
            con = pool.getConnection();
            // 추가 정보를 업데이트하는 쿼리
            sql = "UPDATE tbluser SET birth = ?, phone = ?, address = ?, allergy = ?, height = ?, weight = ?, gender = ? WHERE userId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, bean.getBirth());
            pstmt.setString(2, bean.getPhone());
            pstmt.setString(3, bean.getAddress());
            pstmt.setString(4, bean.getAllergy());
            pstmt.setFloat(5, bean.getHeight());
            pstmt.setFloat(6, bean.getWeight());
            pstmt.setInt(7, bean.getGender());
            pstmt.setString(8, bean.getUserId());
            
            if (pstmt.executeUpdate() == 1) {
                flag = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt);
        }
        return flag;
    }

    // 소셜 사용자 정보 존재 확인
    public boolean isSocialUserExist(String userId, String loginPlatform) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        boolean flag = false;
        try {
            con = pool.getConnection();
            sql = "SELECT * FROM tbluser WHERE userId = ? AND loginPlatform = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, loginPlatform);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                flag = true; // 이미 존재하는 사용자
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(con, pstmt, rs);
        }
        return flag;
    }

	// 마이페이지 유저 정보
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
	
	// 알러지 수정
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
	
	// 친구아이디 존재 확인 후 이름 반환
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
	
	// 친구 추가
	public boolean frPlus(String userId, String frId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null; // 기존 요청이 있는지 확인하기 위한 ResultSet
	    String sql = null;
	    boolean flag = false;
	    try {
	        con = pool.getConnection();
	        
	        // 이미 친구 추가 요청이 있는지 확인
	        sql = "SELECT COUNT(*) FROM tblfriend WHERE userId = ? AND friendId = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setString(1, userId);
	        pstmt.setString(2, frId);
	        rs = pstmt.executeQuery();
	        
	        if (rs.next() && rs.getInt(1) == 0) {
	            // 친구 추가 요청이 없는 경우에만 insert 실행
	            sql = "INSERT INTO tblfriend VALUES (null,?,?,0)";
	            pstmt = con.prepareStatement(sql);
	            pstmt.setString(1, userId);
	            pstmt.setString(2, frId);
	            if (pstmt.executeUpdate() == 1) {
	                flag = true;
	            }
	        } else {
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs); // ResultSet도 해제
	    }
	    return flag;
	}

	
	// 친구 요청여부 확인
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
	
	// 친구 요청 리스트
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
	
	// 친구 수락
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
	
	// 친구 요청 삭제
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
	
	// 수락한 친구 리스트
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
	
	// 수락받은 친구 리스트
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
	
	// 친구삭제
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
	
	// 내 프로필 수정
	public boolean myprofileUpdate(MultipartRequest multi) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			String userId = multi.getParameter("userId");
			String introduce = multi.getParameter("introduce");
			String filename = multi.getFilesystemName("image");
			if(filename!=null&&!filename.equals("")) {
			sql = "update tbluser set profile=?, msg=? where userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, filename);
			pstmt.setString(2, introduce);
			pstmt.setString(3, userId);
			} else {
				sql = "update tbluser set msg=? where userId = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, introduce);
				pstmt.setString(2, userId);
			}
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	// 프로필 삭제
	public boolean deleteProfile(MultipartRequest multi) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		String userId = multi.getParameter("userId");
		String filename = multi.getFilesystemName("image");
		boolean flag = false;
		try {
			if (filename != null && !filename.equals("")) {
			    // 파일 업로드 수정
				UserBean bean = myInfo(userId);
				String dbFile = bean.getProfile();
				if(dbFile!=null&&!dbFile.equals("")) {
					//기존에 업로드 파일이 존재
					File f = new File(SAVEFOLDER+dbFile);
					if(f.exists())
						f.delete();
				}
			}
			con = pool.getConnection();
			sql = "update tbluser set profile=null where userId= ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	// 내 정보 수정
	public boolean myinfoUpdate(UserBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "update tbluser set name = ?, phone=?, address=?, birth = ? where userId =?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getName());
			pstmt.setString(2, bean.getPhone());
			pstmt.setString(3, bean.getAddress());
			pstmt.setString(4, bean.getBirth());
			pstmt.setString(5, bean.getUserId());
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	// 내 정보 삭제
	public boolean myinfoDelete(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "delete from tbluser where userId= ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}

}
