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
}
