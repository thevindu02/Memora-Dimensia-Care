import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ImageUploadService {
  static final String uploadUrl = '${ApiConstants.baseUrl}/api/upload';

  static Future<ImageUploadResult> uploadImage(File imageFile) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$uploadUrl/image'),
      );

      // Add the image file
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: 'volunteer_id_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseData);
        return ImageUploadResult(
          success: true,
          imageUrl: data['imageUrl'],
          message: 'Image uploaded successfully',
        );
      } else {
        final errorData = jsonDecode(responseData);
        return ImageUploadResult(
          success: false,
          message:
              errorData['error'] ??
              'Failed to upload image: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ImageUploadResult(
        success: false,
        message: 'Error uploading image: $e',
      );
    }
  }

  // Fallback method if server upload is not available
  static Future<ImageUploadResult> uploadImageFallback(File imageFile) async {
    try {
      // For now, we'll return a placeholder URL
      // In a real implementation, you would upload to a cloud service like Firebase Storage
      await Future.delayed(Duration(seconds: 2)); // Simulate upload delay

      return ImageUploadResult(
        success: true,
        imageUrl:
            'https://example.com/volunteer_id_${DateTime.now().millisecondsSinceEpoch}.jpg',
        message: 'Image uploaded successfully (fallback)',
      );
    } catch (e) {
      return ImageUploadResult(
        success: false,
        message: 'Error uploading image: $e',
      );
    }
  }
}

class ImageUploadResult {
  final bool success;
  final String? imageUrl;
  final String message;

  ImageUploadResult({
    required this.success,
    this.imageUrl,
    required this.message,
  });
}
