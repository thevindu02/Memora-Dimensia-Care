package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.CreateForumAnswerDTO;
import Memora.DimensiaCareApplication.dto.response.ForumAnswerDTO;
import Memora.DimensiaCareApplication.service.ForumAnswerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/forum/answers")
@CrossOrigin(origins = "*")
public class ForumAnswerController {

    @Autowired
    private ForumAnswerService forumAnswerService;

    /**
     * Create a new answer to a question
     * POST /api/forum/answers
     */
    @PostMapping
    public ResponseEntity<?> createAnswer(@RequestBody CreateForumAnswerDTO request) {
        try {
            // Validate required fields
            if (request.getQuestionId() == null || request.getQuestionId().trim().isEmpty()) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Question ID is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            if (request.getVolunteerId() == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Volunteer ID is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            if (request.getContent() == null || request.getContent().trim().isEmpty()) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "Content is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            ForumAnswerDTO answer = forumAnswerService.createAnswer(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(answer);
            
        } catch (IllegalArgumentException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to create answer: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Get all answers for a specific question
     * GET /api/forum/answers/question/{questionId}
     * Optional query parameter: userId (to check if liked by current user)
     */
    @GetMapping("/question/{questionId}")
    public ResponseEntity<?> getAnswersByQuestionId(
            @PathVariable String questionId,
            @RequestParam(required = false) Long userId) {
        try {
            List<ForumAnswerDTO> answers = forumAnswerService.getAnswersByQuestionId(questionId, userId);
            return ResponseEntity.ok(answers);
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to fetch answers: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Like an answer
     * POST /api/forum/answers/{answerId}/like
     */
    @PostMapping("/{answerId}/like")
    public ResponseEntity<?> likeAnswer(
            @PathVariable String answerId,
            @RequestParam Long userId) {
        try {
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "User ID is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            boolean success = forumAnswerService.likeAnswer(answerId, userId);
            
            if (success) {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Answer liked successfully");
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Already liked");
                return ResponseEntity.ok(response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to like answer: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }

    /**
     * Unlike an answer
     * DELETE /api/forum/answers/{answerId}/like
     */
    @DeleteMapping("/{answerId}/like")
    public ResponseEntity<?> unlikeAnswer(
            @PathVariable String answerId,
            @RequestParam Long userId) {
        try {
            if (userId == null) {
                Map<String, String> error = new HashMap<>();
                error.put("error", "User ID is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            boolean success = forumAnswerService.unlikeAnswer(answerId, userId);
            
            if (success) {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Answer unliked successfully");
                return ResponseEntity.ok(response);
            } else {
                Map<String, String> response = new HashMap<>();
                response.put("message", "Not liked yet");
                return ResponseEntity.ok(response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to unlike answer: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
        }
    }
}
