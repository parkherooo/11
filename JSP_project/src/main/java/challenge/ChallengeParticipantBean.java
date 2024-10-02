package challenge;

public class ChallengeParticipantBean {
    private int participantId;
    private int challengeId;
    private String userId;
    private String joinDate;
    private String coment; 
    private String img; 
    private int heart;
    public int getParticipantId() {
        return participantId;
    }

    public void setParticipantId(int participantId) {
        this.participantId = participantId;
    }

    public int getChallengeId() {
        return challengeId;
    }

    public void setChallengeId(int challengeId) {
        this.challengeId = challengeId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getJoinDate() {
        return joinDate;	
    }

    public void setJoinDate(String joinDate) {
        this.joinDate = joinDate;
    }

	public String getComent() {
		return coment;
	}

	public void setComent(String coment) {
		this.coment = coment;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public int getHeart() {
		return heart;
	}

	public void setHeart(int heart) {
		this.heart = heart;
	}

    
}
