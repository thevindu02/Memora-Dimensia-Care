package Memora.DimensiaCareApplication.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/upload")
public class ImageUploadController {

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    @PostMapping("/image")
    public ResponseEntity<?> uploadImage(@RequestParam("image") MultipartFile file) {
        try {
            // Create upload directory if it doesn't exist
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Generate unique filename
            String originalFilename = file.getOriginalFilename();
            String fileExtension = originalFilename != null ? 
                originalFilename.substring(originalFilename.lastIndexOf(".")) : ".jpg";
            String filename = "volunteer_id_" + UUID.randomUUID().toString() + fileExtension;
            
            // Save file
            Path filePath = uploadPath.resolve(filename);
            Files.copy(file.getInputStream(), filePath);

            // Return the file URL
            Map<String, String> response = new HashMap<>();
            response.put("imageUrl", "/api/images/" + filename);
            response.put("filename", filename);
            response.put("message", "Image uploaded successfully");

            return ResponseEntity.ok(response);
        } catch (IOException e) {
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "Failed to upload image: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    @GetMapping("/images/{filename}")
    public ResponseEntity<?> getImage(@PathVariable String filename) {
        try {
            Path filePath = Paths.get(uploadDir).resolve(filename);
            if (Files.exists(filePath)) {
                byte[] imageBytes = Files.readAllBytes(filePath);
                return ResponseEntity.ok()
                    .header("Content-Type", "image/jpeg")
                    .body(imageBytes);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (IOException e) {
            return ResponseEntity.badRequest().body("Error reading image: " + e.getMessage());
        }
    }
} 