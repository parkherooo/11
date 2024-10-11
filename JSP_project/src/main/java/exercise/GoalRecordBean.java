package exercise;

import java.sql.Date;

public class GoalRecordBean {
	private int grNum;
	private String userId;
	private float height;
	private float weight;
	private float fat;
	private float muscle;
	private float percentage;
	private String img;
	private Date grDate;
	
	
	public int getGrNum() {
		return grNum;
	}
	public void setGrNum(int grNum) {
		this.grNum = grNum;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public float getHeight() {
		return height;
	}
	public void setHeight(float height) {
		this.height = height;
	}
	public float getWeight() {
		return weight;
	}
	public void setWeight(float weight) {
		this.weight = weight;
	}
	public float getFat() {
		return fat;
	}
	public void setFat(float fat) {
		this.fat = fat;
	}
	public float getMuscle() {
		return muscle;
	}
	public void setMuscle(float muscle) {
		this.muscle = muscle;
	}
	public float getPercentage() {
		return percentage;
	}
	public void setPercentage(float percentage) {
		this.percentage = percentage;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public Date getGrDate() {
		return grDate;
	}
	public void setGrDate(Date grDate) {
	    this.grDate = grDate;
	}

}
