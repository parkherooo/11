package community;

import java.util.Date;

public class CommunityBean {
    private int cuNum;
    private String userId;
    private String title;
    private String content;
    private String cuImg;
    private Date cuDate;
    private int recommend;

    public int getCuNum() {
        return cuNum;
    }

    public void setCuNum(int cuNum) {
        this.cuNum = cuNum;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCuImg() {
        return cuImg;
    }

    public void setCuImg(String cuImg) {
        this.cuImg = cuImg;
    }

    public Date getCuDate() {
        return cuDate;
    }

    public void setCuDate(Date cuDate) {
        this.cuDate = cuDate;
    }

    public int getRecommend() {
        return recommend;
    }

    public void setRecommend(int recommend) {
        this.recommend = recommend;
    }
}
