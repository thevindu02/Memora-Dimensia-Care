package Memora.DimensiaCareApplication.dto.response;

import com.google.cloud.Timestamp;
import java.util.List;

public class ForumQuestionDTO {
    private String questionId;
    private Long guardianId;
    private String guardianName;
    private String title;
    private String content;
    private List<String> tags;
    private Long views;
    private Long replies;
    private Boolean isAnswered;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public ForumQuestionDTO() {}

    public ForumQuestionDTO(String questionId, Long guardianId, String guardianName, String title, 
                           String content, List<String> tags, Long views, Long replies, 
                           Boolean isAnswered, Timestamp createdAt, Timestamp updatedAt) {
        this.questionId = questionId;
        this.guardianId = guardianId;
        this.guardianName = guardianName;
        this.title = title;
        this.content = content;
        this.tags = tags;
        this.views = views;
        this.replies = replies;
        this.isAnswered = isAnswered;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public Long getGuardianId() {
        return guardianId;
    }

    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
    }

    public String getGuardianName() {
        return guardianName;
    }

    public void setGuardianName(String guardianName) {
        this.guardianName = guardianName;
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

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public Long getViews() {
        return views;
    }

    public void setViews(Long views) {
        this.views = views;
    }

    public Long getReplies() {
        return replies;
    }

    public void setReplies(Long replies) {
        this.replies = replies;
    }

    public Boolean getIsAnswered() {
        return isAnswered;
    }

    public void setIsAnswered(Boolean isAnswered) {
        this.isAnswered = isAnswered;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    // Custom getter for JSON serialization - returns epoch milliseconds
    @com.fasterxml.jackson.annotation.JsonGetter("createdAt")
    public Long getCreatedAtMillis() {
        return createdAt != null ? createdAt.toDate().getTime() : null;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    // Custom getter for JSON serialization - returns epoch milliseconds
    @com.fasterxml.jackson.annotation.JsonGetter("updatedAt")
    public Long getUpdatedAtMillis() {
        return updatedAt != null ? updatedAt.toDate().getTime() : null;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
