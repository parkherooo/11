package challenge;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import DB.DBConnectionMgr;

public class ChallengeMgr {
	private DBConnectionMgr pool;
	public static final String SAVEFOLDER = "C:\\JSP_project\\JSP_project\\src\\main\\webapp\\challenge\\challenge_img";
	public static final String ENCODING = "UTF-8";
	public static final int MAXSIZE = 1202*1024*50;
	public ChallengeMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	//챌린지 insert
	public boolean challengeInsert (ChallengeBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "insert tblchallenge values(null,?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getChallengeName());
			pstmt.setString(2, bean.getDescription());
			pstmt.setString(3, bean.getStartDate());
			pstmt.setString(4, bean.getEndDate());
			pstmt.setString(5, bean.getGoal());

			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//챌린지 list
	public Vector<ChallengeBean> challengeList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<ChallengeBean> vlist = new Vector<ChallengeBean>();
		try {
			con = pool.getConnection();
			sql = "select * from tblchallenge order by startDate desc";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				ChallengeBean bean = new ChallengeBean();
				bean.setChallengeId(rs.getInt(1));
				bean.setChallengeName(rs.getString(2));
				bean.setDescription(rs.getString(3));
				bean.setStartDate(rs.getString(4));
				bean.setEndDate(rs.getString(5));
				bean.setGoal(rs.getString(6));
				vlist.addElement(bean);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//검색어 리스트
	public Vector<ChallengeBean> searchChallengeList(String search) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		
        Vector<ChallengeBean> vlist = new Vector<>();
        try {
        	con = pool.getConnection();
            sql = "SELECT * FROM tblchallenge WHERE challengeName LIKE ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, "%" + search + "%"); // 검색어 필터링
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ChallengeBean bean = new ChallengeBean();
                bean.setChallengeName(rs.getString("challengeName"));
                bean.setStartDate(rs.getString("startDate"));
                bean.setEndDate(rs.getString("endDate"));
                // 기타 필요한 정보 설정
                vlist.add(bean);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vlist;
    }
	    
	// 총 챌린지 개수를 반환하는 메서드
    public int getTotalChallenges(String search) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int totalChallenges = 0;
        String sql = null;
        try {
        	con = pool.getConnection();

            sql = "SELECT COUNT(*) FROM tblchallenge";
            if (search != null && !search.isEmpty()) {
                sql += " WHERE challengeName LIKE ?"; // 검색 조건 추가
            }

            pstmt = con.prepareStatement(sql);

            if (search != null && !search.isEmpty()) {
                pstmt.setString(1, "%" + search + "%"); // 검색어 포함 설정
            }

            rs = pstmt.executeQuery();

            if (rs.next()) {
                totalChallenges = rs.getInt(1); // 결과에서 총 개수 추출
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalChallenges; // 총 챌린지 개수 반환
    }
    
    //챌린지 한개 가져오기
    public ChallengeBean getChallengeDetail(int challengeId) {
    	Connection con = null;
 	    PreparedStatement pstmt = null;
 	    ResultSet rs = null;
 	    String sql = null;
        ChallengeBean bean = new ChallengeBean();
        try {
            con = pool.getConnection();
            // challengeId에 해당하는 챌린지를 조회하는 SQL 쿼리
            sql = "SELECT * FROM tblchallenge WHERE challengeId = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, challengeId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
            	bean.setChallengeId(rs.getInt(1));
            	bean.setChallengeName(rs.getString(2));
            	bean.setDescription(rs.getString(3));
            	bean.setStartDate(rs.getString(4));
            	bean.setEndDate(rs.getString(5));
            	bean.setGoal(rs.getString(6));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bean; 
    }
    
    //챌린지 참가 인원 계산
    public int countChallenge (int challengeId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		int count = 0;
		try {
			con = pool.getConnection();
			sql = "select count(userId) from tblchallengeparticipants where challengeId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, challengeId);
			rs = pstmt.executeQuery();
			if(rs.next()) { 
				count = rs.getInt(1);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return count;
	}
	
	//챌린지 참가
    public boolean challengeParticpants(MultipartRequest multi) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			File dir = new File(SAVEFOLDER);
			if(!dir.exists())
				dir.mkdirs(); //상위 폴더가 없더라도 생성
				//dir.mkdir();// 상위 폴더가 없으면 생성 불가
			
			String filename = null;
			if(multi.getFilesystemName("image")!=null) {
				//첨부파일
				filename = multi.getFilesystemName("image");
			}
			con = pool.getConnection();
			sql = "insert tblchallengeparticipants values(null,?,?,now(),?,?,0)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(multi.getParameter("challengeId")));
			pstmt.setString(2, multi.getParameter("userId"));
			pstmt.setString(3, multi.getParameter("coment"));
			pstmt.setString(4, filename);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
    
    //챌린지 참가한 사람들 리스트
    public Vector<ChallengeParticipantBean> userChallengeList(int challengeId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<ChallengeParticipantBean> vlist = new Vector<ChallengeParticipantBean>();
		try {
			con = pool.getConnection();
			sql = "select * from tblchallengeparticipants where challengeId = ? order by heart desc";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, challengeId);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				ChallengeParticipantBean bean = new ChallengeParticipantBean();
				bean.setParticipantId(rs.getInt("participantId"));
				bean.setChallengeId(rs.getInt("challengeId"));
				bean.setUserId(rs.getString("userId"));
				bean.setJoinDate(rs.getString("joinDate"));
				bean.setComent(rs.getString("coment"));
				bean.setImg(rs.getString("img"));
				bean.setHeart(rs.getInt("heart"));
				vlist.addElement(bean);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	public void heartPlus(int participantId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "update tblchallengeparticipants set heart = heart+1 where "
					+ "participantId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, participantId);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
}
