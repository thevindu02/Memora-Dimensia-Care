package Memora.DimensiaCareApplication.dto.request;

public class CaregiverReviewRequest {
    private Long guardianId;
    private Long caregiverId;
    private int rating;
    private String reviewText;

    // Default constructor
    public CaregiverReviewRequest() {}

    // All-args constructor (optional, for convenience)
    public CaregiverReviewRequest(Long guardianId, Long caregiverId, int rating, String reviewText) {
        this.guardianId = guardianId;
        this.caregiverId = caregiverId;
        this.rating = rating;
        this.reviewText = reviewText;
    }

    public Long getGuardianId() {
        return guardianId;
    }

    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
    }

    public Long getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(Long caregiverId) {
        this.caregiverId = caregiverId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    @Override
    public String toString() {
        return "CaregiverReviewRequest{" +
                "guardianId=" + guardianId +
                ", caregiverId=" + caregiverId +
                ", rating=" + rating +
                ", reviewText='" + reviewText + '\'' +
                '}';
    }
}
