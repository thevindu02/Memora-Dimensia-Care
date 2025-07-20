package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.ArticleDTO;
import Memora.DimensiaCareApplication.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/articles")
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    @PostMapping
    public String addArticle(@RequestBody ArticleDTO article) throws Exception {
        return articleService.addArticle(article);
    }

    @GetMapping("/{id}")
    public ArticleDTO getArticle(@PathVariable String id) throws Exception {
        return articleService.getArticle(id);
    }
}
