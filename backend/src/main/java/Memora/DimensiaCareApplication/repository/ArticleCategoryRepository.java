package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.ArticleCategory;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ArticleCategoryRepository extends JpaRepository<ArticleCategory, Integer> {
}
