package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.service.ImageUploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api")
public class ImageUploadController {

    @Autowired
    private ImageUploadService imageUploadService;

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    /**
     * Upload image for articles
     * @param file The image file
     * @param type The type of image (header, content, etc.)
     * @return Response with image URL
     */
    @PostMapping("/upload/image")
    public ResponseEntity<Map<String, Object>> uploadImage(
            @RequestParam("image") MultipartFile file,
            @RequestParam(value = "type", defaultValue = "content") String type) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            String imageUrl = imageUploadService.uploadImage(file, type);
            
            response.put("success", true);
            response.put("message", "Image uploaded successfully");
            response.put("imageUrl", imageUrl);
            response.put("fileName", file.getOriginalFilename());
            response.put("fileSize", file.getSize());
            response.put("type", type);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to upload image: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Validate image URL
     * @param request Request body containing the URL
     * @return Validation result
     */
    @PostMapping("/images/validate-url")
    public ResponseEntity<Map<String, Object>> validateImageUrl(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String url = request.get("url");
            boolean isValid = imageUploadService.validateImageUrl(url);
            
            response.put("success", true);
            response.put("valid", isValid);
            response.put("url", url);
            response.put("message", isValid ? "Image URL is valid" : "Invalid image URL or image not accessible");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to validate URL: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Get uploaded image file
     * @param filename The filename
     * @return Image file
     */
    @GetMapping("/images/{filename}")
    public ResponseEntity<?> getImage(@PathVariable String filename) {
        try {
            Path filePath = Paths.get(uploadDir).resolve(filename);
            if (Files.exists(filePath)) {
                byte[] imageBytes = Files.readAllBytes(filePath);
                
                // Determine content type based on file extension
                String contentType = "image/jpeg"; // default
                if (filename.toLowerCase().endsWith(".png")) {
                    contentType = "image/png";
                } else if (filename.toLowerCase().endsWith(".gif")) {
                    contentType = "image/gif";
                } else if (filename.toLowerCase().endsWith(".webp")) {
                    contentType = "image/webp";
                }
                
                return ResponseEntity.ok()
                    .header("Content-Type", contentType)
                    .header("Cache-Control", "max-age=3600") // Cache for 1 hour
                    .body(imageBytes);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (IOException e) {
            return ResponseEntity.badRequest().body("Error reading image: " + e.getMessage());
        }
    }

    /**
     * Delete uploaded image
     * @param filename The filename to delete
     * @return Deletion result
     */
    @DeleteMapping("/images/{filename}")
    public ResponseEntity<Map<String, Object>> deleteImage(@PathVariable String filename) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            boolean deleted = imageUploadService.deleteImage(filename);
            
            response.put("success", deleted);
            response.put("message", deleted ? "Image deleted successfully" : "Image not found");
            response.put("fileName", filename);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to delete image: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
} 