package exercise;

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

@WebServlet("/RecordInsertServlet")
public class RecordInsertServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public static final String ENCTYPE = "UTF-8";
    public static int MAXSIZE = 5 * 1024 * 1024;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        MultipartRequest multi = null;
        String imgFileName = null;
        
        String SAVEFOLDER = request.getServletContext().getRealPath("/exercise/images/"); 
        // 파일 저장 폴더가 없으면 생성
        File file = new File(SAVEFOLDER);
        if (!file.exists()) {
            //file.mkdirs();
        	boolean created = file.mkdirs();
            if (created) {
                System.out.println("images 폴더가 생성되었습니다.");
                System.out.println("이미지 경로: " + SAVEFOLDER); 
            } else {
                System.out.println("images 폴더 생성에 실패했습니다.");
            }
        }

        // MultipartRequest를 통해 요청 처리
        try {
            multi = new MultipartRequest(request, SAVEFOLDER, MAXSIZE, ENCTYPE, new DefaultFileRenamePolicy());

            // 폼에서 전달된 값 받기
            String userId = multi.getParameter("userId"); // multi 객체에서 사용자 ID 가져오기
            float height = Float.parseFloat(multi.getParameter("height"));
            float weight = Float.parseFloat(multi.getParameter("weight"));
            float fat = Float.parseFloat(multi.getParameter("fat"));
            float muscle = Float.parseFloat(multi.getParameter("muscle"));
            float percentage = Float.parseFloat(multi.getParameter("percentage"));
            imgFileName = multi.getFilesystemName("img");
            
            
            // ExerciseGoalBean과 ExerciseGoalMgr 객체 생성
            GoalRecordBean bean = new GoalRecordBean();
            GoalRecordMgr mgr = new GoalRecordMgr();

            // bean에 값 설정
            bean.setUserId(userId);
            bean.setHeight(height);
            bean.setWeight(weight);
            bean.setFat(fat);
            bean.setMuscle(muscle);
            bean.setPercentage(percentage);
            bean.setImg(imgFileName);

            // DB에 운동 목표 저장
            mgr.insertRecord(bean);

            // 성공 시 피드백 페이지로 리디렉션
            response.sendRedirect("exercise/setGoal.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
