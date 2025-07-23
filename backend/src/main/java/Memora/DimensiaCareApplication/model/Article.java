
package Memora.DimensiaCareApplication.model;
import java.time.LocalDateTime;

import jakarta.persistence.*;

@Entity
@Table(name = "articles")
public class Article {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long articleId;

    @Column
    private Integer volunteerId;

    @Column
    private Integer categoryId;

    @Column
    private String title;

    @Column
    private String status;

    @Column
    private Boolean draft;

    @Column
    private String tagname;
    @Column
    private String img;
    @Column
    private String firebaseDocId;
    @Column
    private LocalDateTime createdAt;

    public Article() {
        this.createdAt = LocalDateTime.now();
    }

    public Long getArticleId() {
        return articleId;
    }

    public void setArticleId(Long articleId) {
        this.articleId = articleId;
    }

    public Integer getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Integer volunteerId) {
        this.volunteerId = volunteerId;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getDraft() {
        return draft;
    }

    public void setDraft(Boolean draft) {
        this.draft = draft;
    }

    public String getTagname() {
        return tagname;
    }

    public void setTagname(String tagname) {
        this.tagname = tagname;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public String getFirebaseDocId() {
        return firebaseDocId;
    }

    public void setFirebaseDocId(String firebaseDocId) {
        this.firebaseDocId = firebaseDocId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
