package Memora.DimensiaCareApplication.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
public class ImageUploadService {

    @Value("${app.upload.dir:uploads}")
    private String uploadDir;

    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(".jpg", ".jpeg", ".png", ".gif", ".webp");
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    /**
     * Upload an image file to the server
     * @param file The image file to upload
     * @param type The type of image (header, content, etc.)
     * @return The URL path to access the uploaded image
     * @throws IOException If upload fails
     */
    public String uploadImage(MultipartFile file, String type) throws IOException {
        // Validate file
        validateFile(file);

        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String fileExtension = getFileExtension(originalFilename);
        String filename = generateFileName(type, fileExtension);
        
        // Save file
        Path filePath = uploadPath.resolve(filename);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        // Return the URL path (without /api/ prefix since controller is already at /api)
        return "/images/" + filename;
    }

    /**
     * Validate if an image URL is accessible and valid
     * @param imageUrl The URL to validate
     * @return true if valid and accessible
     */
    public boolean validateImageUrl(String imageUrl) {
        try {
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                return false;
            }

            URL url = new URL(imageUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("HEAD");
            connection.setConnectTimeout(5000); // 5 seconds timeout
            connection.setReadTimeout(5000);

            int responseCode = connection.getResponseCode();
            String contentType = connection.getContentType();

            // Check if response is OK and content type is image
            return responseCode == 200 && contentType != null && contentType.startsWith("image/");

        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Delete an uploaded image file
     * @param fileName The name of the file to delete
     * @return true if deletion was successful
     */
    public boolean deleteImage(String fileName) {
        try {
            Path filePath = Paths.get(uploadDir).resolve(fileName);
            return Files.deleteIfExists(filePath);
        } catch (IOException e) {
            return false;
        }
    }

    /**
     * Validate the uploaded file
     * @param file The file to validate
     * @throws IOException If validation fails
     */
    private void validateFile(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new IOException("File is empty");
        }

        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds maximum limit of 5MB");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new IOException("Invalid file name");
        }

        String fileExtension = getFileExtension(originalFilename);
        if (!ALLOWED_EXTENSIONS.contains(fileExtension.toLowerCase())) {
            throw new IOException("File type not allowed. Supported types: " + ALLOWED_EXTENSIONS);
        }

        // Validate content type
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IOException("File is not a valid image");
        }
    }

    /**
     * Get file extension from filename
     * @param filename The filename
     * @return The file extension
     */
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return ".jpg"; // default extension
        }
        return filename.substring(filename.lastIndexOf("."));
    }

    /**
     * Generate unique filename
     * @param type The image type (header, content, etc.)
     * @param extension The file extension
     * @return Generated filename
     */
    private String generateFileName(String type, String extension) {
        String timestamp = String.valueOf(System.currentTimeMillis());
        String uuid = UUID.randomUUID().toString().substring(0, 8);
        return String.format("article_%s_%s_%s%s", type, timestamp, uuid, extension);
    }
}
