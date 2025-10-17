package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.CreateForumQuestionDTO;
import Memora.DimensiaCareApplication.dto.response.ForumQuestionDTO;
import Memora.DimensiaCareApplication.service.ForumQuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api/forum/questions")
@CrossOrigin(origins = "*")
public class ForumQuestionController {

    @Autowired
    private ForumQuestionService forumQuestionService;

    /**
     * Create a new forum question
     * POST /api/forum/questions
     */
    @PostMapping
    public ResponseEntity<?> createQuestion(@RequestBody CreateForumQuestionDTO request) {
        try {
            // Validate input
            if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Title is required"));
            }
            if (request.getContent() == null || request.getContent().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("Content is required"));
            }
            if (request.getGuardianId() == null) {
                return ResponseEntity.badRequest().body(createErrorResponse("Guardian ID is required"));
            }

            ForumQuestionDTO question = forumQuestionService.createQuestion(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(question);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to create question: " + e.getMessage()));
        }
    }

    /**
     * Get all forum questions
     * GET /api/forum/questions
     */
    @GetMapping
    public ResponseEntity<?> getAllQuestions() {
        try {
            List<ForumQuestionDTO> questions = forumQuestionService.getAllQuestions();
            return ResponseEntity.ok(questions);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to retrieve questions: " + e.getMessage()));
        }
    }

    /**
     * Get a single question by ID (and increment view count)
     * GET /api/forum/questions/{id}
     */
    @GetMapping("/{questionId}")
    public ResponseEntity<?> getQuestionById(@PathVariable String questionId) {
        try {
            ForumQuestionDTO question = forumQuestionService.getQuestionById(questionId);
            if (question == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(createErrorResponse("Question not found"));
            }
            return ResponseEntity.ok(question);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to retrieve question: " + e.getMessage()));
        }
    }

    /**
     * Get questions by guardian ID
     * GET /api/forum/questions/guardian/{guardianId}
     */
    @GetMapping("/guardian/{guardianId}")
    public ResponseEntity<?> getQuestionsByGuardianId(@PathVariable Long guardianId) {
        try {
            List<ForumQuestionDTO> questions = forumQuestionService.getQuestionsByGuardianId(guardianId);
            return ResponseEntity.ok(questions);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to retrieve questions: " + e.getMessage()));
        }
    }

    /**
     * Get unanswered questions
     * GET /api/forum/questions/unanswered
     */
    @GetMapping("/unanswered")
    public ResponseEntity<?> getUnansweredQuestions() {
        try {
            List<ForumQuestionDTO> questions = forumQuestionService.getUnansweredQuestions();
            return ResponseEntity.ok(questions);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to retrieve unanswered questions: " + e.getMessage()));
        }
    }

    /**
     * Delete a question
     * DELETE /api/forum/questions/{questionId}
     */
    @DeleteMapping("/{questionId}")
    public ResponseEntity<?> deleteQuestion(
            @PathVariable String questionId,
            @RequestParam Long guardianId) {
        try {
            boolean deleted = forumQuestionService.deleteQuestion(questionId, guardianId);
            if (!deleted) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(createErrorResponse("Cannot delete question - not found or not owner"));
            }
            Map<String, String> response = new HashMap<>();
            response.put("message", "Question deleted successfully");
            return ResponseEntity.ok(response);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to delete question: " + e.getMessage()));
        }
    }

    /**
     * Get recent questions (posted within last 24 hours)
     * GET /api/forum/questions/filter/recent
     */
    @GetMapping("/filter/recent")
    public ResponseEntity<?> getRecentQuestions() {
        try {
            List<ForumQuestionDTO> questions = forumQuestionService.getRecentQuestions();
            return ResponseEntity.ok(questions);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to retrieve recent questions: " + e.getMessage()));
        }
    }

    /**
     * Get questions sorted by most replies
     * GET /api/forum/questions/filter/most-replies
     */
    @GetMapping("/filter/most-replies")
    public ResponseEntity<?> getMostRepliedQuestions() {
        try {
            List<ForumQuestionDTO> questions = forumQuestionService.getMostRepliedQuestions();
            return ResponseEntity.ok(questions);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to retrieve most replied questions: " + e.getMessage()));
        }
    }

    /**
     * Get filtered questions based on filter type
     * GET /api/forum/questions/filter?type={filterType}
     * filterType: all, unanswered, recent, most_replies
     */
    @GetMapping("/filter")
    public ResponseEntity<?> getFilteredQuestions(@RequestParam(defaultValue = "all") String type) {
        try {
            List<ForumQuestionDTO> questions = forumQuestionService.getFilteredQuestions(type);
            return ResponseEntity.ok(questions);
        } catch (ExecutionException | InterruptedException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Failed to retrieve filtered questions: " + e.getMessage()));
        }
    }

    /**
     * Helper method to create error response
     */
    private Map<String, String> createErrorResponse(String message) {
        Map<String, String> error = new HashMap<>();
        error.put("error", message);
        return error;
    }
}
