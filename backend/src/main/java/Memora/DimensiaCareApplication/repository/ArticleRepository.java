package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Article;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ArticleRepository extends JpaRepository<Article, Long> {
    
    @Query("SELECT a FROM Article a WHERE a.volunteerId = :volunteerId AND a.draft = true ORDER BY a.createdAt DESC")
    List<Article> findDraftsByVolunteerId(@Param("volunteerId") Integer volunteerId);
    
    Article findByFirebaseDocId(String firebaseDocId);
}
