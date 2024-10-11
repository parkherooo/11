package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserBean;
import user.UserMgr;

@WebServlet("/login/updateSocialUser")
public class UpdateSocialUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private UserMgr userMgr = new UserMgr();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
        // 폼으로부터 전달된 추가 정보 수집
        String userId = request.getParameter("userId");
        String birth = request.getParameter("birth");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String allergy = request.getParameter("allergy");
        float height = Float.parseFloat(request.getParameter("height"));
        float weight = Float.parseFloat(request.getParameter("weight"));
        int gender = Integer.parseInt(request.getParameter("gender"));
        
        // 추가 정보를 UserBean에 설정
        UserBean bean = new UserBean();
        bean.setUserId(userId);
        bean.setBirth(birth);
        bean.setPhone(phone);
        bean.setAddress(address);
        bean.setAllergy(allergy);
        bean.setHeight(height);
        bean.setWeight(weight);
        bean.setGender(gender);

        // DB에 추가 정보 업데이트
        boolean isUpdated = userMgr.updateSocialUser(bean);

        // 업데이트 성공 시 메인 페이지로 이동
        if (isUpdated) {
            response.sendRedirect("../main/main.jsp");
        } else {
            response.sendRedirect("additionalInfo.jsp?error=true");
        }
    }
}

