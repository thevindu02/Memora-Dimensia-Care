/// PayHere Configuration
///
/// To get your credentials:
/// 1. Go to https://sandbox.payhere.lk/ and create an account
/// 2. Login and navigate to Settings → Domains & Credentials
/// 3. Copy your Merchant ID and Merchant Secret
/// 4. Add your backend webhook URL in the Notify URL field
///
/// For local development:
/// - Use ngrok to expose your local backend: `ngrok http 8080`
/// - Use the ngrok HTTPS URL as your backend URL
/// - Example: https://abc123.ngrok.io/api/payments/webhook/payhere

class PayHereConfig {
  // ============================================
  // SANDBOX MODE (for testing)
  // ============================================
  static const bool useSandbox = true;

  // Your actual PayHere Sandbox Merchant ID
  static const String sandboxMerchantId = "1232508";

  // TODO: Get your Merchant Secret after adding a domain/app in PayHere
  // Temporary: Using test merchant secret
  static const String sandboxMerchantSecret =
      "MjY3NjczODU5MTE5NjE4MjkzMTQ1NTE4NzU0NTQ1NDEwNDA4MjQ0Mw==";

  // Your PC's IP address (so phone can connect to backend)
  // PC IP: 192.168.21.233 (from ipconfig - Wi-Fi adapter)
  static const String backendUrl = "http://192.168.8.102:8080";

  // ============================================
  // PRODUCTION MODE (for live payments)
  // ============================================
  // TODO: Replace with your actual PayHere Production Merchant ID
  static const String productionMerchantId = "YOUR_PRODUCTION_MERCHANT_ID";

  // TODO: Replace with your actual PayHere Production Merchant Secret
  static const String productionMerchantSecret =
      "YOUR_PRODUCTION_MERCHANT_SECRET";

  // TODO: Replace with your production backend URL
  static const String productionBackendUrl = "https://api.yourdomain.com";

  // ============================================
  // COMPUTED VALUES (don't modify these)
  // ============================================
  static String get merchantId =>
      useSandbox ? sandboxMerchantId : productionMerchantId;
  static String get merchantSecret =>
      useSandbox ? sandboxMerchantSecret : productionMerchantSecret;
  static String get notifyUrl =>
      "${useSandbox ? backendUrl : productionBackendUrl}/api/payments/webhook/payhere";

  // ============================================
  // TEST CARDS (only for sandbox)
  // ============================================
  static const String testCardVisa = "4242424242424242";
  static const String testCardMastercard = "5555555555554444";

  // Default values for testing
  static const String defaultTestEmail = "test@example.com";
  static const String defaultTestPhone = "0771234567";
  static const String defaultCountry = "Sri Lanka";
  static const String defaultCity = "Colombo";
  static const String currency = "LKR";
}
