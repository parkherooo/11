package community;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/AddCommentServlet")
public class AddCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String newComment = request.getParameter("comment");
        String cuNumStr = request.getParameter("cuNum");
        String userId = (String) request.getSession().getAttribute("userId");

        if (newComment != null && cuNumStr != null) {
            int cuNum = Integer.parseInt(cuNumStr);

            CommentsBean comment = new CommentsBean();
            comment.setComment(newComment);
            comment.setCuNum(cuNum);
            comment.setUserId(userId);

            CommentMgr commentMgr = new CommentMgr();
            try {
                commentMgr.addComment(comment);
                response.setStatus(HttpServletResponse.SC_OK); 
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
        }
    }
}
