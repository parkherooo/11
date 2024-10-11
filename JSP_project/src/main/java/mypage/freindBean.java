package mypage;
import alarm.AlarmMgr;

public class freindBean {
	private int num;
	private String userId;
	private String friendId;
	private int frcheck;
	
	public int getNum() {
		return num;
	}
	public void setNum(int num) throws Exception {
	    this.num = num;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getFriendId() {
		return friendId;
	}
	public void setFriendId(String friendId) {
		this.friendId = friendId;
	}
	public int getFrcheck() {
		return frcheck;
	}
	public void setFrcheck(int frcheck) {
		this.frcheck = frcheck;
	}
	
	
}
