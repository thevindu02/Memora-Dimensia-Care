package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.ArticleCategory;
import Memora.DimensiaCareApplication.repository.ArticleCategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@CrossOrigin(origins = "*")
public class ArticleCategoryController {

    @Autowired
    private ArticleCategoryRepository categoryRepository;

    @GetMapping
    public List<ArticleCategory> getAllCategories() {
        return categoryRepository.findAll();
    }
}
