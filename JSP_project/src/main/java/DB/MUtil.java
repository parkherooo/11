package DB;

import javax.servlet.http.HttpServletRequest;

public class MUtil {
	public static int paresInt(HttpServletRequest request, String name) {
		return Integer.parseInt(request.getParameter(name));
	}
}

