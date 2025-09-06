package Memora.DimensiaCareApplication.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Service
public class FileStorageService {
    private final String uploadDir = "uploads/";

    public String storeFile(MultipartFile file) {
        String filename = "volunteer_id_" + UUID.randomUUID() + getExtension(file.getOriginalFilename());
        try {
            File dest = new File(uploadDir + filename);
            file.transferTo(dest);
            return filename;
        } catch (IOException e) {
            throw new RuntimeException("Failed to store file", e);
        }
    }

    private String getExtension(String originalName) {
        int idx = originalName.lastIndexOf(".");
        return idx != -1 ? originalName.substring(idx) : "";
    }
}
