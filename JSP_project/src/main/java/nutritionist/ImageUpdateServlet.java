package nutritionist;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import DB.MUtil;

@WebServlet("/ImageUpdateServlet")
public class ImageUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static final String ENCTYPE = "UTF-8";
	public static int MAXSIZE = 5 * 1024 * 1024;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    
	    MultipartRequest multi = null;
	    String imgFileName = null;

	    String SAVEFOLDER = request.getServletContext().getRealPath("/nutritionist/images/");
	    File file = new File(SAVEFOLDER);
	    if (!file.exists()) {
	        boolean created = file.mkdirs();
	        if (created) {
	            System.out.println("images 폴더가 생성되었습니다.");
	            System.out.println("이미지 경로: " + SAVEFOLDER);
	        } else {
	            System.out.println("images 폴더 생성에 실패했습니다.");
	        }
	    }

	    try {
	        multi = new MultipartRequest(request, SAVEFOLDER, MAXSIZE, ENCTYPE, new DefaultFileRenamePolicy());
	        
	        imgFileName = multi.getFilesystemName("img");
	        System.out.println("업로드된 이미지 파일 이름: " + imgFileName); // 디버깅

	        String userId = multi.getParameter("userId"); // 사용자 ID 가져오기
	        System.out.println("사용자 ID: " + userId); // 디버깅

	        if (imgFileName != null) {
	            // 이미지 경로를 데이터베이스에 업데이트
	            nutritionistMgr nMgr = new nutritionistMgr();
	            nMgr.updateImage(userId, imgFileName); // 이미지 업데이트 메서드 호출
	            System.out.println("이미지 경로 저장: " + imgFileName); // 디버깅
	        } else {
	            System.out.println("이미지가 업로드되지 않았습니다."); // 디버깅
	        }

	        // 성공 시 피드백 페이지로 리디렉션
	        response.sendRedirect("nutritionist/mealPlanList.jsp");

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}
