package Memora.DimensiaCareApplication.dto.response;

import java.util.List;
import java.util.Map;

public class ConversationResponse {
    private String conversationId;
    private List<String> participantIds;
    private Map<String, String> participantNames; // userId -> name
    private String lastMessage;
    private Long lastMessageTimestamp;
    private String otherParticipantName; // For easier UI display

    public ConversationResponse() {}

    public ConversationResponse(String conversationId, List<String> participantIds, 
                               Map<String, String> participantNames, String lastMessage, 
                               Long lastMessageTimestamp) {
        this.conversationId = conversationId;
        this.participantIds = participantIds;
        this.participantNames = participantNames;
        this.lastMessage = lastMessage;
        this.lastMessageTimestamp = lastMessageTimestamp;
    }

    // Getters and Setters
    public String getConversationId() { return conversationId; }
    public void setConversationId(String conversationId) { this.conversationId = conversationId; }
    
    public List<String> getParticipantIds() { return participantIds; }
    public void setParticipantIds(List<String> participantIds) { this.participantIds = participantIds; }
    
    public Map<String, String> getParticipantNames() { return participantNames; }
    public void setParticipantNames(Map<String, String> participantNames) { this.participantNames = participantNames; }
    
    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }
    
    public Long getLastMessageTimestamp() { return lastMessageTimestamp; }
    public void setLastMessageTimestamp(Long lastMessageTimestamp) { this.lastMessageTimestamp = lastMessageTimestamp; }
    
    public String getOtherParticipantName() { return otherParticipantName; }
    public void setOtherParticipantName(String otherParticipantName) { this.otherParticipantName = otherParticipantName; }
}
