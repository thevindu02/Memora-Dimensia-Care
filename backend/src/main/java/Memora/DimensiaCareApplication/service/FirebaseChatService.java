package Memora.DimensiaCareApplication.service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import Memora.DimensiaCareApplication.dto.response.ConversationResponse;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.model.User;

import java.util.*;
import java.util.concurrent.ExecutionException;

@Service
public class FirebaseChatService {

    @Autowired
    private Firestore firestore;
    
    @Autowired
    private UserRepository userRepository;

    /**
     * Create or get existing conversation between guardian and caregiver
     */
    public String createOrGetConversation(String guardianId, String caregiverId) throws ExecutionException, InterruptedException {
        String conversationId = "guardian_" + guardianId + "_caregiver_" + caregiverId;
        
        DocumentReference docRef = firestore.collection("conversations").document(conversationId);
        DocumentSnapshot doc = docRef.get().get();
        
        if (!doc.exists()) {
            // Create new conversation
            Map<String, Object> conversationData = new HashMap<>();
            conversationData.put("participantIds", Arrays.asList(guardianId, caregiverId));
            
            Map<String, String> roles = new HashMap<>();
            roles.put(guardianId, "guardian");
            roles.put(caregiverId, "caregiver");
            conversationData.put("participantRoles", roles);
            
            conversationData.put("createdAt", FieldValue.serverTimestamp());
            conversationData.put("lastMessage", "");
            conversationData.put("lastMessageTimestamp", 0L);
            
            docRef.set(conversationData).get();
            System.out.println("✅ Created new conversation: " + conversationId);
        }
        
        return conversationId;
    }

    /**
     * Send a message to a conversation
     */
    public void sendMessage(String conversationId, String senderId, String senderRole, String text) throws ExecutionException, InterruptedException {
        // Add message to subcollection
        CollectionReference messagesRef = firestore.collection("conversations")
            .document(conversationId)
            .collection("messages");
        
        Map<String, Object> messageData = new HashMap<>();
        messageData.put("senderId", senderId);
        messageData.put("senderRole", senderRole);
        messageData.put("text", text);
        messageData.put("timestamp", FieldValue.serverTimestamp());
        messageData.put("read", false);
        
        messagesRef.add(messageData).get();
        
        // Update conversation's last message
        DocumentReference convRef = firestore.collection("conversations").document(conversationId);
        Map<String, Object> updates = new HashMap<>();
        updates.put("lastMessage", text);
        updates.put("lastMessageTimestamp", System.currentTimeMillis());
        convRef.update(updates).get();
        
        System.out.println("✅ Message sent in conversation: " + conversationId);
    }

    /**
     * Get conversations for a user (guardian or caregiver)
     */
    public List<ConversationResponse> getUserConversations(String userId) throws ExecutionException, InterruptedException {
        CollectionReference conversationsRef = firestore.collection("conversations");
        Query query = conversationsRef.whereArrayContains("participantIds", userId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        List<QueryDocumentSnapshot> documents = future.get().getDocuments();
        
        List<ConversationResponse> conversations = new ArrayList<>();
        
        for (QueryDocumentSnapshot doc : documents) {
            List<String> participantIds = (List<String>) doc.get("participantIds");
            String lastMessage = doc.getString("lastMessage");
            Long lastMessageTimestamp = doc.getLong("lastMessageTimestamp");
            
            // Get participant names from MySQL database
            Map<String, String> participantNames = new HashMap<>();
            String otherParticipantName = "Unknown";
            
            if (participantIds != null) {
                for (String participantId : participantIds) {
                    try {
                        Long participantIdLong = Long.parseLong(participantId);
                        Optional<User> userOpt = userRepository.findById(participantIdLong);
                        if (userOpt.isPresent()) {
                            User user = userOpt.get();
                            String name = user.getFName() + " " + user.getLName();
                            participantNames.put(participantId, name);
                            
                            // If this is the other participant (not current user), save their name
                            if (!participantId.equals(userId)) {
                                otherParticipantName = name;
                            }
                        }
                    } catch (NumberFormatException e) {
                        participantNames.put(participantId, "User " + participantId);
                    }
                }
            }
            
            ConversationResponse response = new ConversationResponse(
                doc.getId(),
                participantIds,
                participantNames,
                lastMessage,
                lastMessageTimestamp
            );
            response.setOtherParticipantName(otherParticipantName);
            
            conversations.add(response);
        }
        
        // Sort by last message timestamp (newest first)
        conversations.sort((a, b) -> {
            Long tsA = a.getLastMessageTimestamp() != null ? a.getLastMessageTimestamp() : 0L;
            Long tsB = b.getLastMessageTimestamp() != null ? b.getLastMessageTimestamp() : 0L;
            return tsB.compareTo(tsA);
        });
        
        return conversations;
    }

    /**
     * Create Firebase custom token for a user (for authentication)
     */
    public String createCustomToken(String userId) throws Exception {
        return FirebaseAuth.getInstance().createCustomToken(userId);
    }
}
