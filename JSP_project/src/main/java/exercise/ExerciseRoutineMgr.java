package exercise;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import DB.DBConnectionMgr;

public class ExerciseRoutineMgr {
private DBConnectionMgr pool;
	
	public ExerciseRoutineMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	// 1,2,3,4 하나씩 랜덤으로
	public List<ExerciseRoutineBean> noPart() {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    List<ExerciseRoutineBean> routineList = new ArrayList<>();
	    
	    try {
	        con = pool.getConnection();
	        sql = "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 1 ORDER BY RAND() LIMIT 1) UNION "
	        		+ "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 2 ORDER BY RAND() LIMIT 1) UNION "
	        		+ "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 3 ORDER BY RAND() LIMIT 1) UNION "
	        		+ "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 4 ORDER BY RAND() LIMIT 1)";

	        pstmt = con.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        // 결과를 처리하고, ExerciseRoutineBean에 저장
	        while (rs.next()) {
	            ExerciseRoutineBean bean = new ExerciseRoutineBean();
	            bean.seteName(rs.getString("eName"));
	            bean.setExercise(rs.getString("exercise"));
	            bean.setExerciseLink(rs.getString("exerciselink"));
	            
	            routineList.add(bean);  // 리스트에 추가
	        }
	      
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }
	    
	    return routineList;
	}
	
	
	// (가슴,등,어깨) 선택해서 랜덤 2, 하체 랜덤 2
	public List<ExerciseRoutineBean> twoPart() {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    List<ExerciseRoutineBean> routineList = new ArrayList<>();
	    
	    try {
	        con = pool.getConnection();
	        int randomENum = (int)(Math.random() * 3) + 1;  // 1, 2, 3 중 랜덤 선택
	        
	        sql = "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = ? ORDER BY RAND() LIMIT 2) UNION "
	        		+ "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 4 ORDER BY RAND() LIMIT 2)";

	        pstmt = con.prepareStatement(sql);
	        pstmt.setInt(1, randomENum);
	        
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ExerciseRoutineBean bean = new ExerciseRoutineBean();
	            bean.seteName(rs.getString("eName"));
	            bean.setExercise(rs.getString("exercise"));
	            bean.setExerciseLink(rs.getString("exerciselink"));
	            
	            routineList.add(bean);  // 리스트에 추가
	        }
	      
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }
	    
	    return routineList;
	}
	
	// (가슴,등) 랜덤2, 하체 랜덤2
	public List<ExerciseRoutineBean> threePart() {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    List<ExerciseRoutineBean> routineList = new ArrayList<>();
	    
	    try {
	        con = pool.getConnection();
	        sql = "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 1 ORDER BY RAND() LIMIT 1) UNION "
	        		+ "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 2 ORDER BY RAND() LIMIT 1) UNION"
	        		+ "(SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 4 ORDER BY RAND() LIMIT 2)";

	        pstmt = con.prepareStatement(sql);
	        
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ExerciseRoutineBean bean = new ExerciseRoutineBean();
	            bean.seteName(rs.getString("eName"));
	            bean.setExercise(rs.getString("exercise"));
	            bean.setExerciseLink(rs.getString("exerciselink"));
	            
	            routineList.add(bean);  // 리스트에 추가
	        }
	      
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }
	    
	    return routineList;
	}
	
	//유산소 5
	public List<ExerciseRoutineBean> cardio() {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    List<ExerciseRoutineBean> routineList = new ArrayList<>();
	    
	    try {
	        con = pool.getConnection();
	        sql = "SELECT eName, exercise, exerciselink FROM tblexerciseroutine WHERE eNum = 5 ORDER BY RAND() LIMIT 4";

	        pstmt = con.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ExerciseRoutineBean bean = new ExerciseRoutineBean();
	            bean.seteName(rs.getString("eName"));
	            bean.setExercise(rs.getString("exercise"));
	            bean.setExerciseLink(rs.getString("exerciselink"));
	            
	            routineList.add(bean);  // 리스트에 추가
	        }
	      
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        pool.freeConnection(con, pstmt, rs);
	    }
	    
	    return routineList;
	}
}
