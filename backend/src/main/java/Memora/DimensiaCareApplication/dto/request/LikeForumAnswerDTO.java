package Memora.DimensiaCareApplication.dto.request;

public class LikeForumAnswerDTO {
    private String answerId;
    private Long guardianId;

    // Constructors
    public LikeForumAnswerDTO() {}

    public LikeForumAnswerDTO(String answerId, Long guardianId) {
        this.answerId = answerId;
        this.guardianId = guardianId;
    }

    // Getters and Setters
    public String getAnswerId() {
        return answerId;
    }

    public void setAnswerId(String answerId) {
        this.answerId = answerId;
    }

    public Long getGuardianId() {
        return guardianId;
    }

    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
    }
}
