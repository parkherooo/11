package alarm;

import java.util.Date;

public class AlarmBean {

    private int alarm_num;         // 알람 번호 (PRIMARY KEY)
    private String userId;        // 사용자 ID (FOREIGN KEY)
    private String content;       // 알람 내용
    private Date a_date;           // 알람 날짜
    private int check_alarm;       // 알람 확인 여부 (0 = 미확인, 1 = 확인됨)
    
	public int getAlarm_num() {
		return alarm_num;
	}
	public void setAlarm_num(int alarm_num) {
		this.alarm_num = alarm_num;
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
	public Date getA_date() {
		return a_date;
	}
	public void setA_date(Date a_date) {
		this.a_date = a_date;
	}
	public int getCheck_alarm() {
		return check_alarm;
	}
	public void setCheck_alarm(int check_alarm) {
		this.check_alarm = check_alarm;
	}
    	
    	
    }