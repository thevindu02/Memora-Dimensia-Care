package Memora.DimensiaCareApplication.dto.request;

public class CreateForumAnswerDTO {
    private String questionId;
    private Long userId; // Changed from volunteerId to userId
    private String content;

    // Constructors
    public CreateForumAnswerDTO() {}

    public CreateForumAnswerDTO(String questionId, Long userId, String content) {
        this.questionId = questionId;
        this.userId = userId;
        this.content = content;
    }

    // Getters and Setters
    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    // Keep for backward compatibility
    public Long getVolunteerId() {
        return userId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.userId = volunteerId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
