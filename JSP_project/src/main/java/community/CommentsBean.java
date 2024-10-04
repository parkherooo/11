package community;

import java.util.Date;

public class CommentsBean {
    private int cmNum;
    private int cuNum;
    private String comment;
    private Date cmDate;
    private String userId;

    public int getCmNum() {
        return cmNum;
    }

    public void setCmNum(int cmNum) {
        this.cmNum = cmNum;
    }

    public int getCuNum() {
        return cuNum;
    }

    public void setCuNum(int cuNum) {
        this.cuNum = cuNum;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Date getCmDate() {
        return cmDate;
    }

    public void setCmDate(Date cmDate) {
        this.cmDate = cmDate;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}
