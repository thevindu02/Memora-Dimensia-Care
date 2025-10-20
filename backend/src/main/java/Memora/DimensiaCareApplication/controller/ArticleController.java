package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.ArticleDTO;
import Memora.DimensiaCareApplication.dto.ArticleDetailDTO;
import Memora.DimensiaCareApplication.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/articles")
@CrossOrigin(origins = "*")
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    /**
     * Add a new article. For volunteer articles, authorId is required and will
     * be used to fetch volunteer name and profilePic from PostgreSQL. Fields
     * supported: title, summary, content, images, status, draft, profilePic.
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
    public java.util.List<ArticleDetailDTO> getDraftArticles(@RequestParam Long volunteerId) {
        try {
            System.out.println("Received request for drafts with volunteerId: " + volunteerId);
            java.util.List<ArticleDetailDTO> drafts = articleService.getDraftArticles(volunteerId);
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
    public java.util.List<ArticleDetailDTO> getPublishedArticles(@RequestParam Long volunteerId) {
        try {
            System.out.println("Received request for published articles with volunteerId: " + volunteerId);
            java.util.List<ArticleDetailDTO> publishedArticles = articleService.getPublishedArticles(volunteerId);
            System.out.println("Returning " + publishedArticles.size() + " published articles");
            return publishedArticles;
        } catch (Exception e) {
            System.err.println("Error in getPublishedArticles controller: " + e.getMessage());
            e.printStackTrace();
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    @GetMapping("/all")
    public java.util.List<ArticleDetailDTO> getAllArticles() {
        try {
            System.out.println("Received request for ALL articles (all statuses)");

            // First try Firebase, if empty try PostgreSQL
            java.util.List<ArticleDetailDTO> allArticles = articleService.getAllArticles();

            if (allArticles.isEmpty()) {
                System.out.println("No articles found in Firebase, trying PostgreSQL...");
                allArticles = articleService.getAllArticlesFromPostgreSQL();
            }

            System.out.println("Returning " + allArticles.size() + " articles from all volunteers (all statuses)");
            return allArticles;
        } catch (Exception e) {
            System.err.println("Error in getAllArticles controller: " + e.getMessage());
            e.printStackTrace();
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    @GetMapping("/all/postgres")
    public java.util.List<ArticleDetailDTO> getAllArticlesFromPostgreSQL() {
        try {
            System.out.println("Received request for ALL articles from PostgreSQL");
            java.util.List<ArticleDetailDTO> allArticles = articleService.getAllArticlesFromPostgreSQL();
            System.out.println("Returning " + allArticles.size() + " articles from PostgreSQL");
            return allArticles;
        } catch (Exception e) {
            System.err.println("Error in getAllArticlesFromPostgreSQL controller: " + e.getMessage());
            e.printStackTrace();
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

    /**
     * Like an article
     * POST /api/articles/{articleId}/like
     */
    @PostMapping("/{articleId}/like")
    public ResponseEntity<?> likeArticle(
            @PathVariable String articleId,
            @RequestParam Long userId) {
        try {
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "User ID is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            boolean success = articleService.likeArticle(articleId, userId);
            
            if (success) {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Article liked successfully");
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Already liked");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to like article: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Unlike an article
     * DELETE /api/articles/{articleId}/like
     */
    @DeleteMapping("/{articleId}/like")
    public ResponseEntity<?> unlikeArticle(
            @PathVariable String articleId,
            @RequestParam Long userId) {
        try {
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "User ID is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            boolean success = articleService.unlikeArticle(articleId, userId);
            
            if (success) {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Article unliked successfully");
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Not liked yet");
                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to unlike article: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Check if user has liked an article and get like count
     * GET /api/articles/{articleId}/like-status
     */
    @GetMapping("/{articleId}/like-status")
    public ResponseEntity<?> getArticleLikeStatus(
            @PathVariable String articleId,
            @RequestParam(required = false) Long userId) {
        try {
            Map<String, Object> response = new HashMap<>();
            
            // Get like count
            long likeCount = articleService.getArticleLikeCount(articleId);
            response.put("likeCount", likeCount);
            
            // Check if user has liked (if userId is provided)
            if (userId != null) {
                boolean hasLiked = articleService.hasLikedArticle(articleId, userId);
                response.put("hasLiked", hasLiked);
            } else {
                response.put("hasLiked", false);
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to get like status: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Delete an article (only by the author)
     * DELETE /api/articles/{articleId}
     */
    @DeleteMapping("/{articleId}")
    public ResponseEntity<?> deleteArticle(
            @PathVariable String articleId,
            @RequestParam Long volunteerId) {
        try {
            System.out.println("Received request to delete article: " + articleId + " by volunteer: " + volunteerId);
            
            if (volunteerId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Volunteer ID is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            boolean success = articleService.deleteArticle(articleId, volunteerId);
            
            if (success) {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Article deleted successfully");
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Failed to delete article. Either article not found or you don't have permission.");
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error);
            }
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to delete article: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}

