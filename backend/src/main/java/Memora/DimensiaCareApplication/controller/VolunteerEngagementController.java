package Memora.DimensiaCareApplication.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import Memora.DimensiaCareApplication.repository.ArticleCategoryRepository;
import Memora.DimensiaCareApplication.repository.ArticleRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.VolunteerRepository;

@RestController
@RequestMapping("/api/volunteer-engagement")
@CrossOrigin(origins = "*")
public class VolunteerEngagementController {

    @Autowired
    private VolunteerRepository volunteerRepository;

    @Autowired
    private ArticleRepository articleRepository;

    @Autowired
    private ArticleCategoryRepository articleCategoryRepository;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getVolunteerEngagementStats() {
        try {
            Map<String, Object> stats = new HashMap<>();

            // Total volunteers (active ones)
            Long totalVolunteers = volunteerRepository.countActiveVolunteers();

            // Total published articles
            Long totalArticles = articleRepository.countByStatus("Published");

            // Average articles per month (assuming we calculate for last 12 months)
            // For now, we'll use a simple calculation
            Double avgArticlesPerMonth = totalArticles != null ? totalArticles / 12.0 : 0.0;

            stats.put("totalVolunteers", totalVolunteers != null ? totalVolunteers : 0);
            stats.put("totalArticles", totalArticles != null ? totalArticles : 0);
            stats.put("avgArticlesPerMonth", Math.round(avgArticlesPerMonth * 100.0) / 100.0);

            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            System.err.println("Error fetching volunteer engagement stats: " + e.getMessage());
            e.printStackTrace();

            Map<String, Object> defaultStats = new HashMap<>();
            defaultStats.put("totalVolunteers", 0);
            defaultStats.put("totalArticles", 0);
            defaultStats.put("avgArticlesPerMonth", 0.0);

            return ResponseEntity.ok(defaultStats);
        }
    }

    @GetMapping("/articles-by-category")
    public ResponseEntity<List<Map<String, Object>>> getArticlesByCategory() {
        try {
            List<Map<String, Object>> categoryStats = new ArrayList<>();

            // Get all categories and their article counts
            List<Object[]> results = articleRepository.getArticleCountByCategory();

            for (Object[] result : results) {
                Map<String, Object> categoryStat = new HashMap<>();
                categoryStat.put("categoryName", result[0] != null ? result[0] : "Uncategorized");
                categoryStat.put("articleCount", result[1] != null ? result[1] : 0);
                categoryStats.add(categoryStat);
            }

            return ResponseEntity.ok(categoryStats);
        } catch (Exception e) {
            System.err.println("Error fetching articles by category: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new ArrayList<>());
        }
    }

    @GetMapping("/monthly-engagement")
    public ResponseEntity<List<Map<String, Object>>> getMonthlyEngagement() {
        try {
            List<Map<String, Object>> monthlyData = new ArrayList<>();

            // Get monthly article publication data
            List<Object[]> results = articleRepository.getMonthlyArticleCount();

            for (Object[] result : results) {
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("month", result[0]);
                monthData.put("year", result[1]);
                monthData.put("articleCount", result[2] != null ? result[2] : 0);
                monthlyData.add(monthData);
            }

            return ResponseEntity.ok(monthlyData);
        } catch (Exception e) {
            System.err.println("Error fetching monthly engagement: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new ArrayList<>());
        }
    }

    @GetMapping("/top-volunteers")
    public ResponseEntity<List<Map<String, Object>>> getTopVolunteers() {
        try {
            List<Map<String, Object>> topVolunteers = new ArrayList<>();

            // Get top volunteers by article count with detailed info
            List<Object[]> results = articleRepository.getTopVolunteersWithDetails();

            int rank = 1;
            for (Object[] result : results) {
                if (rank > 3) {
                    break; // Only top 3
                }
                Map<String, Object> volunteer = new HashMap<>();
                volunteer.put("rank", rank);
                volunteer.put("volunteerId", result[0]);
                volunteer.put("volunteerName", result[1] != null ? result[1] : "Unknown");
                volunteer.put("volunteerEmail", result[2] != null ? result[2] : "");
                volunteer.put("articleCount", result[3] != null ? result[3] : 0);
                volunteer.put("volunteerImage", result[4] != null ? result[4] : "");
                topVolunteers.add(volunteer);
                rank++;
            }

            return ResponseEntity.ok(topVolunteers);
        } catch (Exception e) {
            System.err.println("Error fetching top volunteers: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new ArrayList<>());
        }
    }

    @GetMapping("/volunteers-details")
    public ResponseEntity<List<Map<String, Object>>> getVolunteersDetails() {
        try {
            List<Map<String, Object>> volunteersDetails = new ArrayList<>();

            // Get all volunteers with their article counts and user details
            List<Object[]> results = articleRepository.getAllVolunteersWithDetails();

            for (Object[] result : results) {
                Map<String, Object> volunteer = new HashMap<>();
                volunteer.put("volunteerId", result[0]);
                volunteer.put("volunteerName", result[1] != null ? result[1] : "Unknown");
                volunteer.put("volunteerEmail", result[2] != null ? result[2] : "");
                volunteer.put("phoneNumber", result[3] != null ? result[3] : "");
                volunteer.put("articleCount", result[4] != null ? result[4] : 0);
                volunteer.put("volunteerImage", result[5] != null ? result[5] : "");
                volunteer.put("joinDate", result[6] != null ? result[6] : "");
                volunteersDetails.add(volunteer);
            }

            return ResponseEntity.ok(volunteersDetails);
        } catch (Exception e) {
            System.err.println("Error fetching volunteers details: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new ArrayList<>());
        }
    }

    @GetMapping("/articles-details")
    public ResponseEntity<List<Map<String, Object>>> getArticlesDetails() {
        try {
            List<Map<String, Object>> articlesDetails = new ArrayList<>();

            // Get all published articles with volunteer and category details
            List<Object[]> results = articleRepository.getPublishedArticlesWithDetails();

            for (Object[] result : results) {
                Map<String, Object> article = new HashMap<>();
                article.put("articleId", result[0]);
                article.put("title", result[1]);
                article.put("volunteerName", result[2] != null ? result[2] : "Unknown");
                article.put("categoryName", result[3] != null ? result[3] : "Uncategorized");
                article.put("status", result[4]);
                article.put("createdAt", result[5]);
                article.put("tagname", result[6] != null ? result[6] : "");
                article.put("img", result[7] != null ? result[7] : "");
                articlesDetails.add(article);
            }

            return ResponseEntity.ok(articlesDetails);
        } catch (Exception e) {
            System.err.println("Error fetching articles details: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(new ArrayList<>());
        }
    }
}
