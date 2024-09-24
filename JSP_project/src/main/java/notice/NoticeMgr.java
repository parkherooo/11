package notice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import DB.DBConnectionMgr;

public class NoticeMgr {
	private DBConnectionMgr pool;
	public NoticeMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	//공지사항 작성
	public void noticeInsert(NoticeBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "insert tblnotice values(null,?,?,?,?,now())";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, bean.getNoticeType());
			pstmt.setString(2, bean.getTitle());
			pstmt.setString(3, bean.getContent());
			pstmt.setString(4, bean.getnImg());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//공지사항 수정
	public void noticeUpdate(NoticeBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "update tblnotice set title=?, content=?, nImg=? where nNum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getTitle());
			pstmt.setString(2, bean.getContent());
			pstmt.setString(3, bean.getnImg());
			pstmt.setInt(4, bean.getnNum());
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//공지사항 삭제
	public void noticeDelete(int nNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "delete from tblnotice where nNum= ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, nNum);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//전체 리스트
	public Vector<NoticeBean>AllList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		 Vector<NoticeBean>vlist = new Vector<NoticeBean>();
		try {
			con = pool.getConnection();
			sql = "select * from tblnotice";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				NoticeBean bean = new NoticeBean();
				bean.setnNum(rs.getInt(1));
				bean.setNoticeType(rs.getInt(2));
				bean.setTitle(rs.getString(3));
				bean.setContent(rs.getString(4));
				bean.setnImg(rs.getString(5));
				bean.setnDate(rs.getString(6));
				vlist.addElement(bean);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//공지사항 리스트
	public Vector<NoticeBean>noticeList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		 Vector<NoticeBean>vlist = new Vector<NoticeBean>();
		try {
			con = pool.getConnection();
			sql = "select * from tblnotice where noticetype = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, 0);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				NoticeBean bean = new NoticeBean();
				bean.setnNum(rs.getInt(1));
				bean.setNoticeType(rs.getInt(2));
				bean.setTitle(rs.getString(3));
				bean.setContent(rs.getString(4));
				bean.setnImg(rs.getString(5));
				bean.setnDate(rs.getString(6));
				vlist.addElement(bean);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//이벤트리스트
	public Vector<NoticeBean>evntList() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		 Vector<NoticeBean>vlist = new Vector<NoticeBean>();
		try {
			con = pool.getConnection();
			sql = "select * from tblnotice where noticetype = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, 1);
			rs = pstmt.executeQuery();
			while(rs.next()) { 
				NoticeBean bean = new NoticeBean();
				bean.setnNum(rs.getInt(1));
				bean.setNoticeType(rs.getInt(2));
				bean.setTitle(rs.getString(3));
				bean.setContent(rs.getString(4));
				bean.setnImg(rs.getString(5));
				bean.setnDate(rs.getString(6));
				vlist.addElement(bean);
			}	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//공지사항 한개가져오기
	public NoticeBean getNotice(int nNum) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    NoticeBean bean = new NoticeBean();
	    try {
	        con = pool.getConnection();
	        sql = "select * from tblnotice where nNum = ?";
	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, nNum);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            bean.setnNum(rs.getInt(1));
	            bean.setNoticeType(rs.getInt(2));
	            bean.setTitle(rs.getString(3));
	            bean.setContent(rs.getString(4));
	            bean.setnImg(rs.getString(5));
	            bean.setnDate(rs.getString(6));
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }
	    return bean;
	}
	
	// 제목으로 공지사항 검색
    public Vector<NoticeBean> searchByTitle(String search) {
        Vector<NoticeBean> result = new Vector<>();
        // 전체 공지사항 리스트를 가져옴
        Vector<NoticeBean> allNotices = AllList();
        for (NoticeBean bean : allNotices) {
            if (bean.getTitle().toLowerCase().contains(search.toLowerCase())) {
                result.add(bean);
            }
        }
        return result;
    }
    
    //관리자 판단
    public int mangerChk(String userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		int manger = 0;
		try {
			con = pool.getConnection();
			sql = "select manger from tbluser where userId = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs=pstmt.executeQuery();
			if (rs.next()) {
                 manger=rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return manger;
	}

}
