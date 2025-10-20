package Memora.DimensiaCareApplication.dto.response;

import java.time.LocalDateTime;

public class CaregiverReviewResponse {
    private Long reviewId;
    private String guardianName;
    private int rating;
    private String reviewText;
    private LocalDateTime createdAt;

    public CaregiverReviewResponse(Long reviewId, String guardianName, int rating, String reviewText, LocalDateTime createdAt) {
        this.reviewId = reviewId;
        this.guardianName = guardianName;
        this.rating = rating;
        this.reviewText = reviewText;
        this.createdAt = createdAt;
    }

    // Getters and setters
    public Long getReviewId() { return reviewId; }
    public void setReviewId(Long reviewId) { this.reviewId = reviewId; }
    public String getGuardianName() { return guardianName; }
    public void setGuardianName(String guardianName) { this.guardianName = guardianName; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
