package Memora.DimensiaCareApplication.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import Memora.DimensiaCareApplication.model.Article;

public interface ArticleRepository extends JpaRepository<Article, Long> {

    @Query("SELECT a FROM Article a WHERE a.volunteerId = :volunteerId AND a.draft = true ORDER BY a.createdAt DESC")
    List<Article> findDraftsByVolunteerId(@Param("volunteerId") Integer volunteerId);

    Article findByFirebaseDocId(String firebaseDocId);

    Long countByStatus(String status);

    @Query("SELECT ac.categoryName, COUNT(a) FROM Article a "
            + "LEFT JOIN ArticleCategory ac ON a.categoryId = ac.categoryId "
            + "WHERE a.status = 'Published' "
            + "GROUP BY ac.categoryName "
            + "ORDER BY COUNT(a) DESC")
    List<Object[]> getArticleCountByCategory();

    @Query("SELECT MONTH(a.createdAt), YEAR(a.createdAt), COUNT(a) FROM Article a "
            + "WHERE a.status = 'Published' "
            + "GROUP BY YEAR(a.createdAt), MONTH(a.createdAt) "
            + "ORDER BY YEAR(a.createdAt) DESC, MONTH(a.createdAt) DESC")
    List<Object[]> getMonthlyArticleCount();

    @Query("SELECT v.volunteerId, CONCAT(u.FName, ' ', u.LName), COUNT(a) FROM Article a "
            + "JOIN Volunteer v ON a.volunteerId = v.volunteerId "
            + "JOIN User u ON v.userId = u.id "
            + "WHERE a.status = 'Published' "
            + "GROUP BY v.volunteerId, u.FName, u.LName "
            + "ORDER BY COUNT(a) DESC "
            + "LIMIT 3")
    List<Object[]> getTopVolunteersByArticleCount();

    // Enhanced query with volunteer details
    @Query("SELECT v.volunteerId, CONCAT(u.FName, ' ', u.LName), u.email, COUNT(a), v.volunteerIdImage "
            + "FROM Article a "
            + "JOIN Volunteer v ON a.volunteerId = v.volunteerId "
            + "JOIN User u ON v.userId = u.id "
            + "WHERE a.status = 'Published' "
            + "GROUP BY v.volunteerId, u.FName, u.LName, u.email, v.volunteerIdImage "
            + "ORDER BY COUNT(a) DESC "
            + "LIMIT 3")
    List<Object[]> getTopVolunteersWithDetails();

    // Get all volunteers with their article counts and full details
    @Query("SELECT v.volunteerId, CONCAT(u.FName, ' ', u.LName), u.email, u.phoneNumber, "
            + "COALESCE(COUNT(a.articleId), 0), v.volunteerIdImage, u.createdAt "
            + "FROM Volunteer v "
            + "JOIN User u ON v.userId = u.id "
            + "LEFT JOIN Article a ON v.volunteerId = a.volunteerId AND a.status = 'Published' "
            + "GROUP BY v.volunteerId, u.FName, u.LName, u.email, u.phoneNumber, v.volunteerIdImage, u.createdAt "
            + "ORDER BY COUNT(a.articleId) DESC")
    List<Object[]> getAllVolunteersWithDetails();

    // Get published articles with volunteer and category details
    @Query("SELECT a.articleId, a.title, CONCAT(u.FName, ' ', u.LName), ac.categoryName, "
            + "a.status, a.createdAt, a.tagname, a.img "
            + "FROM Article a "
            + "LEFT JOIN Volunteer v ON a.volunteerId = v.volunteerId "
            + "LEFT JOIN User u ON v.userId = u.id "
            + "LEFT JOIN ArticleCategory ac ON a.categoryId = ac.categoryId "
            + "WHERE a.status = 'Published' "
            + "ORDER BY a.createdAt DESC")
    List<Object[]> getPublishedArticlesWithDetails();
}
