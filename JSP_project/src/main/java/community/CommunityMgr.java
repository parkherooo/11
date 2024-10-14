package community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommunityMgr {
	private DBConnectionMgr pool;
	
	public CommunityMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	
	// 사용자 이름 불러오기(게시물 작성)
    public String getUserNameById(String userId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String userName = null;

        String sql = "SELECT userName FROM tbluser WHERE userId = ?";  

        try {
            conn = pool.getConnection();  
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);  

            rs = pstmt.executeQuery();

          
            if (rs.next()) {
                userName = rs.getString("userName");  
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt, rs);  
        }

        return userName;  
    }
	
	
	//게시글 작성
	public boolean insertPost(CommunityBean bean) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "INSERT INTO tblcommunity (userId, title, content, cuImg, cuDate, recommend) VALUES (?, ?, ?, ?, NOW(), ?)";
	    boolean success = false;

	    try {
	        conn = pool.getConnection();
	        pstmt = conn.prepareStatement(sql);

	        // userId를 root로 임시 설정
	        pstmt.setString(1, bean.getUserId()); 
	        pstmt.setString(2, bean.getTitle());
	        pstmt.setString(3, bean.getContent());
	        pstmt.setString(4, bean.getCuImg());
	        pstmt.setInt(5, bean.getRecommend());

	        if (pstmt.executeUpdate() == 1) {
	            success = true;
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(conn, pstmt);
	    }
	    return success;
	}
	
	//게시글 수정
	public boolean updatePost(int cuNum, String title, String content, String cuImg) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE tblcommunity SET title = ?, content = ?, cuImg = ? WHERE cuNum = ?";
        boolean success = false;

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, title); 
            pstmt.setString(2, content); 
            pstmt.setString(3, cuImg); 
            pstmt.setInt(4, cuNum); 

            if (pstmt.executeUpdate() == 1) {
                success = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt);
        }

        return success;
    }
	
	
	//게시글 삭제
	 public boolean deletePost(int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        String sql = "DELETE FROM tblcommunity WHERE cuNum = ?";
	        boolean success = false;

	        try {
	            conn = pool.getConnection();  
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, cuNum);  

	            if (pstmt.executeUpdate() == 1) {
	                success = true;
	            }
	        } catch (SQLException e) {
	            e.printStackTrace(); 
	        } finally {
	            pool.freeConnection(conn, pstmt); 
	        }

	        return success;  
	    }
	
	
	 // 좋아요 수 가장 많은 글 4개 가져오기
	 public List<CommunityBean> getTopLikedPosts(int limit) throws Exception {
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    ResultSet rs = null;
		    List<CommunityBean> popularPosts = new ArrayList<>();
		    
		    String sql = "SELECT cuNum, userId, title, recommend, cuDate, cuImg FROM tblcommunity ORDER BY recommend DESC LIMIT ?";

		    try {
		        conn = pool.getConnection();
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, limit);  
		        rs = pstmt.executeQuery();
		        
		        while (rs.next()) {
		            CommunityBean bean = new CommunityBean();
		            bean.setCuNum(rs.getInt("cuNum")); 
		            bean.setUserId(rs.getString("userId"));
		            bean.setTitle(rs.getString("title"));
		            bean.setRecommend(rs.getInt("recommend"));
		            bean.setCuDate(rs.getTimestamp("cuDate"));
		            
		            String imageFileName = rs.getString("cuImg");
		            
		            String imageFilePath = "community/upload/" + imageFileName;
		            bean.setCuImg(imageFilePath); 
		            
		            popularPosts.add(bean);
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    } finally {
		        pool.freeConnection(conn, pstmt, rs);
		    }

		    return popularPosts;
		}

	 
	//게시물 리스트
	 public List<CommunityBean> getPostList() throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        List<CommunityBean> postList = new ArrayList<>();
	        String sql = "SELECT userId, title, cuDate, recommend FROM tblcommunity ORDER BY cuNum DESC";
	        
	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            rs = pstmt.executeQuery();
	            
	            while (rs.next()) {
	                CommunityBean bean = new CommunityBean();
	                bean.setUserId(rs.getString("userId"));
	                bean.setTitle(rs.getString("title"));    
	                bean.setCuDate(rs.getTimestamp("cuDate")); 
	                bean.setRecommend(rs.getInt("recommend")); 
	                postList.add(bean);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            pool.freeConnection(conn, pstmt, rs);
	        }
	        
	        return postList;
	    }
	 
	
	 //총 게시물 수 가져오기
	 public int getTotalPostCount() throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        int totalPosts = 0;

	        String sql = "SELECT COUNT(*) FROM tblcommunity";

	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                totalPosts = rs.getInt(1);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            pool.freeConnection(conn, pstmt, rs);
	        }

	        return totalPosts;
	    }
	 
	 
	 	// 특정 페이지에 맞는 게시물 리스트 가져오기
	    public List<CommunityBean> getPostList2(int pageNum, int postsPerPage) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        List<CommunityBean> postList = new ArrayList<>();
	        
	        int offset = (pageNum - 1) * postsPerPage;
	        
	        String sql = "SELECT cuNum, userId, title, cuDate, recommend FROM tblcommunity ORDER BY cuNum DESC LIMIT ? OFFSET ?";
	        
	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, postsPerPage); 
	            pstmt.setInt(2, offset);       
	            
	            rs = pstmt.executeQuery();
	            
	            while (rs.next()) {
	                CommunityBean bean = new CommunityBean();
	                bean.setCuNum(rs.getInt("cuNum"));
	                bean.setUserId(rs.getString("userId"));
	                bean.setTitle(rs.getString("title"));
	                bean.setCuDate(rs.getTimestamp("cuDate"));
	                bean.setRecommend(rs.getInt("recommend"));
	                postList.add(bean);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            pool.freeConnection(conn, pstmt, rs);
	        }

	        return postList;
	    }
	    
	    
	    public List<CommunityBean> getPostsByTitle(String title, int pageNum, int postsPerPage) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        List<CommunityBean> postList = new ArrayList<>();
	        String sql = "SELECT userId, title, recommend, cuDate FROM tblcommunity WHERE title LIKE ? ORDER BY cuNum DESC LIMIT ?, ?";
	        
	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);            
	            pstmt.setString(1, "%" + title + "%");
	        
	            int startRow = (pageNum - 1) * postsPerPage;
	            pstmt.setInt(2, startRow);
	            pstmt.setInt(3, postsPerPage);
	            
	            rs = pstmt.executeQuery();
	            
	            while (rs.next()) {
	                CommunityBean bean = new CommunityBean();
	                bean.setUserId(rs.getString("userId"));
	                bean.setTitle(rs.getString("title"));
	                bean.setRecommend(rs.getInt("recommend"));
	                bean.setCuDate(rs.getTimestamp("cuDate"));
	                postList.add(bean);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            pool.freeConnection(conn, pstmt, rs);
	        }

	        return postList;
	    }

	    
	    // 제목으로 검색된 게시물의 총 개수 반환
	    public int getTotalPostCountByTitle(String title) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        int totalPosts = 0;
	        String sql = "SELECT COUNT(*) FROM tblcommunity WHERE title LIKE ?";
	        
	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setString(1, "%" + title + "%");
	            
	            rs = pstmt.executeQuery();
	            
	            if (rs.next()) {
	                totalPosts = rs.getInt(1);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            pool.freeConnection(conn, pstmt, rs);
	        }

	        return totalPosts;
	    }

	    
	    // 특정 사용자가 작성한 게시물을 가져오는 메소드
	    public List<CommunityBean> getPostsByUser(String userId) throws Exception {
	        List<CommunityBean> postList = new ArrayList<>();
	        String sql = "SELECT cuNum, title, content, cuImg, cuDate, recommend FROM tblcommunity WHERE userId = ?";

	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        try {
	            // 임시로 userId를 root로 고정
	          
	            System.out.println("임시 userId 설정: " + userId);

	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, userId);
	            System.out.println("DB 쿼리 실행: userId = " + userId);

	            rs = pstmt.executeQuery();
	            while (rs.next()) {
	                CommunityBean bean = new CommunityBean();

	                bean.setCuNum(rs.getInt("cuNum")); 
	                bean.setTitle(rs.getString("title"));
	                bean.setContent(rs.getString("content"));
	                bean.setCuImg(rs.getString("cuImg"));
	                bean.setCuDate(rs.getDate("cuDate"));
	                bean.setRecommend(rs.getInt("recommend"));
	                
	                postList.add(bean);
	            }

	            System.out.println("가져온 게시물 수: " + postList.size());
	        } catch (SQLException e) {
	            e.printStackTrace();
	            throw new Exception("게시물 정보를 가져오는 중 오류가 발생했습니다: " + e.getMessage(), e);
	        } finally {
	            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }

	        return postList;
	    }
	    
	    //하트누르면 1씩 증가
	    public void increaseRecommend(int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE tblcommunity SET recommend = recommend + 1 WHERE cuNum = ?";

	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, cuNum);
	            pstmt.executeUpdate();
	        } finally {
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }
	    }
	       

	    // 좋아요 수 감소
	    public void decreaseRecommend(int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        String sql = "UPDATE tblcommunity SET recommend = recommend - 1 WHERE cuNum = ?";

	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, cuNum);
	            pstmt.executeUpdate();
	        } finally {
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }
	    }


	    public boolean isLikedByUser(String userId, int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        String sql = "SELECT COUNT(*) FROM tbllikes WHERE userId = ? AND cuNum = ?";

	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, userId);
	            pstmt.setInt(2, cuNum);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                return rs.getInt(1) > 0;
	            }
	        } finally {
	            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }
	        return false;
	    }
        
	    // 좋아요 추가
	    public void addLike(String userId, int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        String sql = "INSERT INTO tbllikes (userId, cuNum) VALUES (?, ?)";

	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, userId);
	            pstmt.setInt(2, cuNum);
	            pstmt.executeUpdate();
	        } finally {
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }
	    }
	    
	    
	    
	    //좋아요 감소
	    public void removeLike(String userId, int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        String sql = "DELETE FROM tbllikes WHERE userId = ? AND cuNum = ?";

	        try {
	            conn = pool.getConnection();
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, userId);
	            pstmt.setInt(2, cuNum);
	            pstmt.executeUpdate();
	        } finally {
	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
	        }
	    }
	
	    
	    //인기게시물 클릭시 해당게시물정보
	    public CommunityBean getPostById(int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        CommunityBean post = null;

	        try {
	            conn = pool.getConnection();
	            String sql = "SELECT * FROM tblcommunity WHERE cuNum = ?";
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, cuNum);
	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                post = new CommunityBean();
	                post.setCuNum(rs.getInt("cuNum"));
	                post.setUserId(rs.getString("userId"));
	                post.setTitle(rs.getString("title"));
	                post.setContent(rs.getString("content"));
	                post.setCuImg(rs.getString("cuImg"));
	                post.setCuDate(rs.getDate("cuDate"));
	                post.setRecommend(rs.getInt("recommend"));
	            }
	        } finally {
	            pool.freeConnection(conn, pstmt, rs);
	        }

	        return post;
	    }
	    
	    
	    public CommunityBean getPostDetail(int cuNum) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        CommunityBean post = null;

	        String sql = "SELECT cuNum, userId, title, content, cuDate, recommend, cuImg FROM tblcommunity WHERE cuNum = ?";

	        try {
	            conn = pool.getConnection();  
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setInt(1, cuNum); 

	            rs = pstmt.executeQuery();

	            if (rs.next()) {
	                post = new CommunityBean();
	                post.setCuNum(rs.getInt("cuNum"));
	                post.setUserId(rs.getString("userId"));
	                post.setTitle(rs.getString("title"));
	                post.setContent(rs.getString("content"));
	                post.setCuDate(rs.getTimestamp("cuDate"));
	                post.setRecommend(rs.getInt("recommend"));
	                post.setCuImg(rs.getString("cuImg"));  
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            pool.freeConnection(conn, pstmt, rs); 
	        }

	        return post;
	    }
	    
	    public boolean heartPlus(String userId, int cuNum) {
			Connection con = null;
			PreparedStatement pstmt = null;
			String sql = null;
			ResultSet rs = null;
			boolean heartOn = false;
			try {
				con = pool.getConnection();
				sql = "select heartId, liked from tblheart where userId = ? and cuNum= ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, cuNum);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					int heartId = rs.getInt("heartId");
					int like = rs.getInt("liked");
					
					if(like ==1) {
						sql = "update tblcommunity set recommend = recommend-1 where "
								+ "cuNum = ?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, cuNum);
						pstmt.executeUpdate();
						
						sql = "update tblheart set liked = 0 where heartId = ?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, heartId);
						pstmt.executeUpdate();

					} else {
						sql = "update tblcommunity set recommend = recommend+1 where "
								+ "cuNum = ?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, cuNum);
						pstmt.executeUpdate();
						
						sql = "update tblheart set liked = 1 where heartId = ?";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, heartId);
						if(pstmt.executeUpdate()==1) heartOn = true;
					}
				} else {
					sql = "update tblcommunity set recommend = recommend+1 where "
							+ "cuNum = ?";
					pstmt = con.prepareStatement(sql);
					pstmt.setInt(1, cuNum);
					pstmt.executeUpdate();
					
					sql = "insert tblheart values(null,null,?,?,1)";
					pstmt = con.prepareStatement(sql);
					pstmt.setInt(1, cuNum);
					pstmt.setString(2, userId);
					if(pstmt.executeUpdate()==1) heartOn = true;
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt);
			}
			return heartOn;
		}
		public boolean heartChk(String userId, int cuNum) {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			boolean flag = false;
			try {
				con = pool.getConnection();
				sql = "select liked from tblheart where userId = ? and cuNum = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, userId);
				pstmt.setInt(2, cuNum);
				rs = pstmt.executeQuery();
				if(rs.next()) { 
					if(rs.getInt("liked")==1) flag = true;
				}	
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return flag;
		}
	    
}
