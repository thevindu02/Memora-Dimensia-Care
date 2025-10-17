package Memora.DimensiaCareApplication.dto.request;

public class CreateForumAnswerDTO {
    private String questionId;
    private Long volunteerId;
    private String content;

    // Constructors
    public CreateForumAnswerDTO() {}

    public CreateForumAnswerDTO(String questionId, Long volunteerId, String content) {
        this.questionId = questionId;
        this.volunteerId = volunteerId;
        this.content = content;
    }

    // Getters and Setters
    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public Long getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.volunteerId = volunteerId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
