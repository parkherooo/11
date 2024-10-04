package signup;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import user.UserBean;
import user.UserMgr;

@WebServlet("/signup/normalSignUp")
public class NormalSignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String userId = request.getParameter("userId");
        String name = request.getParameter("name");
        String pwd = request.getParameter("password");
        String birth = request.getParameter("birth");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String allergy = request.getParameter("allergy");
        float height = Float.parseFloat(request.getParameter("height"));
        float weight = Float.parseFloat(request.getParameter("weight"));
        int gender = Integer.parseInt(request.getParameter("gender"));

        // UserMgr 객체 생성
        UserMgr mgr = new UserMgr();

        // 전화번호 중복 확인
        boolean isPhoneDuplicate = mgr.phoneChk(phone);

        if (isPhoneDuplicate) {
            // 전화번호가 중복될 경우 경고 메시지 출력 후 이전 페이지로 이동
            response.getWriter().println("<script>alert('해당 전화번호로 이미 가입된 아이디가 존재합니다.'); history.back();</script>");
            return;
        }

        // 회원가입 처리
        UserBean user = new UserBean();
        user.setUserId(userId);
        user.setName(name);
        user.setPwd(pwd);
        user.setBirth(birth);
        user.setPhone(phone);
        user.setAddress(address);
        user.setAllergy(allergy);
        user.setHeight(height);
        user.setWeight(weight);
        user.setGender(gender);

        boolean result = mgr.insertUser(user);

        if (result) {
            // 회원가입 성공 시 로그인 페이지로 이동
            response.getWriter().println("<script>alert('회원가입이 완료되었습니다.'); location.href='" + request.getContextPath() + "/login/logIn.jsp';</script>");
        } else {
            // 회원가입 실패 시 경고 메시지 출력 후 이전 페이지로 이동
            response.getWriter().println("<script>alert('회원가입에 실패했습니다.'); history.back();</script>");
        }
    }
}
