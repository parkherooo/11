package alarm;

import java.util.Date;

public class AlarmBean {

    private int alarmNum;         // 알람 번호 (PRIMARY KEY)
    private String userId;        // 사용자 ID (FOREIGN KEY)
    private String content;       // 알람 내용
    private Date aDate;           // 알람 날짜
    private int checkAlarm;       // 알람 확인 여부 (0 = 미확인, 1 = 확인됨)
    	
    	 public int getAlarmNum() {
    	        return alarmNum;
    	    }

    	    public void setAlarmNum(int alarmNum) {
    	        this.alarmNum = alarmNum;
    	    }

    	    public String getUserId() {
    	        return userId;
    	    }

    	    public void setUserId(String userId) {
    	        this.userId = userId;
    	    }

    	    public String getContent() {
    	        return content;
    	    }

    	    public void setContent(String content) {
    	        this.content = content;
    	    }

    	    public Date getaDate() {
    	        return aDate;
    	    }

    	    public void setaDate(Date aDate) {
    	        this.aDate = aDate;
    	    }

    	    public int getCheckAlarm() {
    	        return checkAlarm;
    	    }

    	    public void setCheckAlarm(int checkAlarm) {
    	        this.checkAlarm = checkAlarm;
    	    }
    }