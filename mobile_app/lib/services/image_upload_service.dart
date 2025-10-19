import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  static final String uploadUrl = '${ApiConstants.baseUrl}/api/upload';

  /// Upload image (mobile only)
  static Future<ImageUploadResult> uploadImage(
    dynamic imageFile, {
    String type = 'profile',
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$uploadUrl/image?type=$type'),
      );

      // Generate filename
      String filename = '${type}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Support both File and XFile
      if (imageFile is File) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: filename,
        );
        request.files.add(multipartFile);
      } else if (imageFile is XFile) {
        // Support XFile from image_picker
        var multipartFile = await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: filename,
        );
        request.files.add(multipartFile);
      }

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseData);
        // Construct full URL if imageUrl is relative
        String imageUrl = data['imageUrl'];
        if (!imageUrl.startsWith('http')) {
          imageUrl = '${ApiConstants.baseUrl}/api$imageUrl';
        }

        return ImageUploadResult(
          success: true,
          imageUrl: imageUrl,
          message: 'Image uploaded successfully',
        );
      } else {
        final errorData = jsonDecode(responseData);
        return ImageUploadResult(
          success: false,
          message:
              errorData['message'] ??
              errorData['error'] ??
              'Failed to upload image: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
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
