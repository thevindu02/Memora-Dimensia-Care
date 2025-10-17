package Memora.DimensiaCareApplication.dto.request;

import java.util.List;

public class CreateForumQuestionDTO {
    private Long guardianId;
    private String title;
    private String content;
    private List<String> tags;

    // Constructors
    public CreateForumQuestionDTO() {}

    public CreateForumQuestionDTO(Long guardianId, String title, String content, List<String> tags) {
        this.guardianId = guardianId;
        this.title = title;
        this.content = content;
        this.tags = tags;
    }

    // Getters and Setters
    public Long getGuardianId() {
        return guardianId;
    }

    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
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
}
