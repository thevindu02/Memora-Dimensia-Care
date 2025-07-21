package Memora.DimensiaCareApplication.dto;

public class ArticleDTO {
    private String articleId; // Firestore document ID
    private Long volunteerId; // from PostgreSQL
    private boolean draft;
    private String status;
    private String title;
    private String summary;
    private String content;
    private String articleImg;

    public ArticleDTO() {
    }

    public ArticleDTO(String articleId, Long volunteerId, boolean draft, String status, String title, String summary,
            String content, String articleImg) {
        this.articleId = articleId;
        this.volunteerId = volunteerId;
        this.draft = draft;
        this.status = status;
        this.title = title;
        this.summary = summary;
        this.content = content;
        this.articleImg = articleImg;
    }

    public String getArticleId() {
        return articleId;
    }

    public void setArticleId(String articleId) {
        this.articleId = articleId;
    }

    public Long getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.volunteerId = volunteerId;
    }

    public boolean isDraft() {
        return draft;
    }

    public void setDraft(boolean draft) {
        this.draft = draft;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getArticleImg() {
        return articleImg;
    }

    public void setArticleImg(String articleImg) {
        this.articleImg = articleImg;
    }
}
