package Memora.DimensiaCareApplication.dto.request;

public class SendMessageRequest {
    private String conversationId;
    private String senderId;
    private String senderRole; // "guardian" or "caregiver"
    private String text;

    public SendMessageRequest() {}

    // Getters and Setters
    public String getConversationId() { return conversationId; }
    public void setConversationId(String conversationId) { this.conversationId = conversationId; }
    
    public String getSenderId() { return senderId; }
    public void setSenderId(String senderId) { this.senderId = senderId; }
    
    public String getSenderRole() { return senderRole; }
    public void setSenderRole(String senderRole) { this.senderRole = senderRole; }
    
    public String getText() { return text; }
    public void setText(String text) { this.text = text; }
}
