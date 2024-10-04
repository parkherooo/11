package community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommentMgr {

    private DBConnectionMgr pool;

    public CommentMgr() {
        pool = DBConnectionMgr.getInstance();
    }

    // 댓글 입력
    public void addComment(CommentsBean comment) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO tblcomments (cuNum, comment, cmDate, userId) VALUES (?, ?, now(), ?)";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, comment.getCuNum());
            pstmt.setString(2, comment.getComment());
            pstmt.setString(3, comment.getUserId());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt);
        }
    }

    // 댓글 삭제
    public void deleteComment(int cmNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM tblcomments WHERE cmNum = ?";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cmNum);

            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt);
        }
    }
    
    
    //댓글 리스트 가져오기
    public List<CommentsBean> getCommentsByPost(int cuNum) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<CommentsBean> commentList = new ArrayList<>();
        String sql = "SELECT * FROM tblcomments WHERE cuNum = ? ORDER BY cmNum DESC";

        try {
            conn = pool.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, cuNum);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CommentsBean comment = new CommentsBean();
                comment.setCmNum(rs.getInt("cmNum"));
                comment.setCuNum(rs.getInt("cuNum"));
                comment.setComment(rs.getString("comment"));
                comment.setCmDate(rs.getDate("cmDate"));
                comment.setUserId(rs.getString("userId"));
                commentList.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            pool.freeConnection(conn, pstmt, rs);
        }

        return commentList;
    }

    
    
}
