package Memora.DimensiaCareApplication.dto.response;

import com.google.cloud.Timestamp;

public class ForumAnswerDTO {
    private String answerId;
    private String questionId;
    private Long volunteerId;
    private String volunteerName; // Fetched from MySQL users table
    private String volunteerRole; // Fetched from MySQL users table
    private String content;
    private Long likes;
    private Boolean isLikedByCurrentUser; // For guardian UI
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public ForumAnswerDTO() {}

    public ForumAnswerDTO(String answerId, String questionId, Long volunteerId, String volunteerName, 
                         String volunteerRole, String content, Long likes, Boolean isLikedByCurrentUser,
                         Timestamp createdAt, Timestamp updatedAt) {
        this.answerId = answerId;
        this.questionId = questionId;
        this.volunteerId = volunteerId;
        this.volunteerName = volunteerName;
        this.volunteerRole = volunteerRole;
        this.content = content;
        this.likes = likes;
        this.isLikedByCurrentUser = isLikedByCurrentUser;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getAnswerId() {
        return answerId;
    }

    public void setAnswerId(String answerId) {
        this.answerId = answerId;
    }

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

    public String getVolunteerName() {
        return volunteerName;
    }

    public void setVolunteerName(String volunteerName) {
        this.volunteerName = volunteerName;
    }

    public String getVolunteerRole() {
        return volunteerRole;
    }

    public void setVolunteerRole(String volunteerRole) {
        this.volunteerRole = volunteerRole;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Long getLikes() {
        return likes;
    }

    public void setLikes(Long likes) {
        this.likes = likes;
    }

    public Boolean getIsLikedByCurrentUser() {
        return isLikedByCurrentUser;
    }

    public void setIsLikedByCurrentUser(Boolean isLikedByCurrentUser) {
        this.isLikedByCurrentUser = isLikedByCurrentUser;
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
