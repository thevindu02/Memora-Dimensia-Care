package Memora.DimensiaCareApplication.dto;

import java.util.List;

public class ArticleDTO {
    private String id; // Firestore document ID
    private String title;
    private String content;
    private String author;
    private int authorId; // Postgres user ID
    private List<String> images; // URLs or paths to images

    public ArticleDTO() {
    }

    public ArticleDTO(String id, String title, String content, String author, int authorId, List<String> images) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.author = author;
        this.authorId = authorId;
        this.images = images;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public int getAuthorId() {
        return authorId;
    }

    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }
}
