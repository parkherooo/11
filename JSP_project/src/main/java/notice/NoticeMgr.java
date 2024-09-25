package notice;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import DB.DBConnectionMgr;
import DB.MUtil;

public class NoticeMgr {
	private DBConnectionMgr pool;
	public static final String SAVEFOLDER = "C:\\JSP_project\\JSP_project\\src\\main\\webapp\\notice\\notice_img";
	public static final String ENCODING = "UTF-8";
	public static final int MAXSIZE = 1202*1024*50;
	
	public NoticeMgr() {
		pool = DBConnectionMgr.getInstance();
		
	}
	
	//공지사항 작성
	public boolean noticeInsert(HttpServletRequest req) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			File dir = new File(SAVEFOLDER);
			if(!dir.exists())
				dir.mkdirs(); //상위 폴더가 없더라도 생성
				//dir.mkdir();// 상위 폴더가 없으면 생성 불가
			MultipartRequest multi = new MultipartRequest(req,SAVEFOLDER,MAXSIZE,ENCODING, new DefaultFileRenamePolicy());
			String filename = null;
			if(multi.getFilesystemName("image")!=null) {
				//첨부파일
				filename = multi.getFilesystemName("image");
			}
			con = pool.getConnection();
			sql = "insert tblnotice values(null,?,?,?,?,now())";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(multi.getParameter("noticeType")));
			pstmt.setString(2, multi.getParameter("title"));
			pstmt.setString(3, multi.getParameter("content"));
			pstmt.setString(4, filename);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//공지사항 수정
	public boolean noticeUpdate(MultipartRequest multi) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			int nNum = Integer.parseInt(multi.getParameter("nNum"));
			String title = multi.getParameter("title");
			String content = multi.getParameter("content");
			String filename = multi.getFilesystemName("image");
			if(filename!=null&&!filename.equals("")) {
				//파일 업로드 수정
				NoticeBean bean = getNotice(nNum);
				String dbFile = bean.getnImg();
				if(dbFile!=null&&!dbFile.equals("")) {
					//기존에 업로드 파일이 존재
					File f = new File(SAVEFOLDER+dbFile);
					if(f.exists())
						f.delete();
			}
			sql = "update tblnotice set title=?, content=?, nImg=? where nNum = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1,title);
			pstmt.setString(2,content);
			pstmt.setString(3, filename);
			pstmt.setInt(4, nNum);
			} else {
				sql = "update tblnotice set title=?, content=? where nNum = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1,title);
				pstmt.setString(2,content);
				pstmt.setInt(3, nNum);
			}
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
	}
	
	//공지사항 삭제
	public boolean noticeDelete(int nNum) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			NoticeBean bean = getNotice(nNum);
			String filename = bean.getnImg();
			if(filename!=null&&!filename.equals("")) {
				File f = new File(SAVEFOLDER+filename);
				if(f.exists())
					f.delete(); //첨부된 파일 삭제
			}
			con = pool.getConnection();
			sql = "delete from tblnotice where nNum= ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, nNum);
			if(pstmt.executeUpdate()==1) flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return flag;
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
