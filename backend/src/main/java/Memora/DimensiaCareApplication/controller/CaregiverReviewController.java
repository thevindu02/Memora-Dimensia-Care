package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.CaregiverReview;
import Memora.DimensiaCareApplication.dto.request.CaregiverReviewRequest;
import Memora.DimensiaCareApplication.service.CaregiverReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/caregiver-reviews")
@CrossOrigin(origins = "*")
public class CaregiverReviewController {

    @Autowired
    private CaregiverReviewService caregiverReviewService;

    @PostMapping("/add-review")
    public ResponseEntity<?> addReview(@RequestBody CaregiverReviewRequest req) {
        System.out.println("Received review POST request: " + req);
        CaregiverReview review = caregiverReviewService.addReview(req);
        if (review == null) {
            return ResponseEntity.badRequest().body("Invalid guardian or caregiver");
        }
        return ResponseEntity.ok("Review added");
    }
}
