package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.ArticleDTO;
import Memora.DimensiaCareApplication.dto.ArticleDetailDTO;
import Memora.DimensiaCareApplication.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/articles")
@CrossOrigin(origins = "*")
public class ArticleController {
    @Autowired
    private ArticleService articleService;

    /**
     * Add a new article. For volunteer articles, authorId is required and will be
     * used to fetch
     * volunteer name and profilePic from PostgreSQL. Fields supported: title,
     * summary, content, images, status, draft, profilePic.
     *
     * @param article ArticleDTO (see ArticleDTO.java for all fields)
     * @return update time string
     */
    @PostMapping
    public String addArticle(@RequestBody ArticleDTO article) throws Exception {
        return articleService.addArticle(article);
    }

    @GetMapping("/{id}")
    public ArticleDTO getArticle(@PathVariable String id) throws Exception {
        return articleService.getArticle(id);
    }

    @GetMapping("/detail/{id}")
    public Memora.DimensiaCareApplication.dto.ArticleDetailDTO getArticleDetail(@PathVariable String id) {
        try {
            System.out.println("Received request for article detail with ID: " + id);
            Memora.DimensiaCareApplication.dto.ArticleDetailDTO articleDetail = articleService.getArticleDetail(id);
            if (articleDetail == null) {
                System.err.println("Article not found with ID: " + id);
                throw new RuntimeException("Article not found");
            }
            System.out.println("Returning article detail: " + articleDetail.getTitle());
            return articleDetail;
        } catch (Exception e) {
            System.err.println("Error in getArticleDetail controller: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get article detail: " + e.getMessage());
        }
    }

    @GetMapping("/drafts")
    public java.util.List<ArticleDTO> getDraftArticles(@RequestParam Long volunteerId) {
        try {
            System.out.println("Received request for drafts with volunteerId: " + volunteerId);
            java.util.List<ArticleDTO> drafts = articleService.getDraftArticles(volunteerId);
            System.out.println("Returning " + drafts.size() + " draft articles");
            return drafts;
        } catch (Exception e) {
            System.err.println("Error in getDraftArticles controller: " + e.getMessage());
            e.printStackTrace();
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    @GetMapping("/published")
    public java.util.List<ArticleDTO> getPublishedArticles(@RequestParam Long volunteerId) {
        try {
            System.out.println("Received request for published articles with volunteerId: " + volunteerId);
            java.util.List<ArticleDTO> publishedArticles = articleService.getPublishedArticles(volunteerId);
            System.out.println("Returning " + publishedArticles.size() + " published articles");
            return publishedArticles;
        } catch (Exception e) {
            System.err.println("Error in getPublishedArticles controller: " + e.getMessage());
            e.printStackTrace();
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    @GetMapping("/published/all")
    public java.util.List<ArticleDetailDTO> getAllPublishedArticles() {
        try {
            System.out.println("Received request for ALL published articles");
            java.util.List<ArticleDetailDTO> publishedArticles = articleService.getAllPublishedArticles();
            System.out.println("Returning " + publishedArticles.size() + " published articles from all volunteers");
            return publishedArticles;
        } catch (Exception e) {
            System.err.println("Error in getAllPublishedArticles controller: " + e.getMessage());
            e.printStackTrace();
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    @PutMapping("/{id}")
    public String updateArticle(@PathVariable String id, @RequestBody ArticleDTO articleDTO) {
        try {
            System.out.println("Received request to update article with ID: " + id);
            String updateTime = articleService.updateArticle(id, articleDTO);
            System.out.println("Article updated successfully at: " + updateTime);
            return updateTime;
        } catch (Exception e) {
            System.err.println("Error in updateArticle controller: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to update article: " + e.getMessage());
        }
    }

    @PostMapping("/sync-images")
    public String syncArticleImages() {
        try {
            System.out.println("Syncing article images from PostgreSQL to Firebase...");
            int synced = articleService.syncArticleImagesToFirebase();
            return "Successfully synced " + synced + " article images to Firebase";
        } catch (Exception e) {
            System.err.println("Error syncing images: " + e.getMessage());
            e.printStackTrace();
            return "Error syncing images: " + e.getMessage();
        }
    }
}
