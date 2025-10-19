package Memora.DimensiaCareApplication.dto;

public class UpdateTaskStatusDTO {
    private String status; // PENDING, IN_PROGRESS, COMPLETED, SKIPPED, CANCELLED
    private String skipReason; // Required if status is SKIPPED

    // Constructors
    public UpdateTaskStatusDTO() {
    }

    public UpdateTaskStatusDTO(String status, String skipReason) {
        this.status = status;
        this.skipReason = skipReason;
    }

    // Getters and Setters
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSkipReason() {
        return skipReason;
    }

    public void setSkipReason(String skipReason) {
        this.skipReason = skipReason;
    }
}
