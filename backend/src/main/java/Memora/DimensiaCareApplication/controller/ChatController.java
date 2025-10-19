package Memora.DimensiaCareApplication.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import Memora.DimensiaCareApplication.dto.request.SendMessageRequest;
import Memora.DimensiaCareApplication.dto.response.ConversationResponse;
import Memora.DimensiaCareApplication.service.FirebaseChatService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*")
public class ChatController {

    @Autowired
    private FirebaseChatService chatService;

    /**
     * Create or get conversation between guardian and caregiver
     * POST /api/chat/conversations?guardianId=1&caregiverId=3
     */
    @PostMapping("/conversations")
    public ResponseEntity<Map<String, String>> createConversation(
        @RequestParam String guardianId,
        @RequestParam String caregiverId
    ) {
        try {
            String conversationId = chatService.createOrGetConversation(guardianId, caregiverId);
            Map<String, String> response = new HashMap<>();
            response.put("conversationId", conversationId);
            response.put("status", "success");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    /**
     * Send a message
     * POST /api/chat/messages
     * Body: { "conversationId": "...", "senderId": "1", "senderRole": "guardian", "text": "Hello" }
     */
    @PostMapping("/messages")
    public ResponseEntity<Map<String, String>> sendMessage(@RequestBody SendMessageRequest request) {
        try {
            chatService.sendMessage(
                request.getConversationId(),
                request.getSenderId(),
                request.getSenderRole(),
                request.getText()
            );
            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }

    /**
     * Get conversations for a user
     * GET /api/chat/conversations/guardian/1  or  /api/chat/conversations/caregiver/3
     */
    @GetMapping("/conversations/{role}/{userId}")
    public ResponseEntity<List<ConversationResponse>> getUserConversations(
        @PathVariable String role,
        @PathVariable String userId
    ) {
        try {
            List<ConversationResponse> conversations = chatService.getUserConversations(userId);
            return ResponseEntity.ok(conversations);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Get Firebase custom token for authentication
     * GET /api/chat/auth/token?userId=1
     */
    @GetMapping("/auth/token")
    public ResponseEntity<Map<String, String>> getAuthToken(@RequestParam String userId) {
        try {
            String token = chatService.createCustomToken(userId);
            Map<String, String> response = new HashMap<>();
            response.put("token", token);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
}
