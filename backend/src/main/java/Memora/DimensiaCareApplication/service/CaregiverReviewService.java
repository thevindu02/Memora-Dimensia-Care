package Memora.DimensiaCareApplication.service;
import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import Memora.DimensiaCareApplication.dto.request.CaregiverReviewRequest;
import Memora.DimensiaCareApplication.dto.response.CaregiverReviewResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CaregiverReviewService {

    @Autowired
    private CaregiverReviewRepository reviewRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CaregiverRepository caregiverRepository;

    public CaregiverReview addReview(CaregiverReviewRequest req) {
        System.out.println("Received review POST request: " + req);

        User guardian = userRepository.findById(req.getGuardianId()).orElse(null);
        Caregiver caregiver = caregiverRepository.findById(req.getCaregiverId().intValue()).orElse(null);

        if (guardian == null) {
            System.out.println("Guardian not found: " + req.getGuardianId());
            return null;
        }
        if (caregiver == null) {
            System.out.println("Caregiver not found: " + req.getCaregiverId());
            return null;
        }

        CaregiverReview review = new CaregiverReview();
        review.setGuardian(guardian);
        review.setCaregiver(caregiver);
        review.setRating(req.getRating());
        review.setReviewText(req.getReviewText());
        return reviewRepository.save(review);
    }

    public List<CaregiverReview> getReviewsForCaregiver(Long caregiverId) {
        return reviewRepository.findByCaregiver_CaregiverId(caregiverId);
    }

    public List<CaregiverReviewResponse> getReviewResponsesForCaregiver(Long caregiverId) {
        List<CaregiverReview> reviews = reviewRepository.findByCaregiver_CaregiverId(caregiverId); // <-- FIXED
        List<CaregiverReviewResponse> responses = new ArrayList<>();
        for (CaregiverReview review : reviews) {
            String guardianName = "";
            if (review.getGuardian() != null) {
                guardianName = review.getGuardian().getFName() + " " + review.getGuardian().getLName();
            }
            responses.add(new CaregiverReviewResponse(
                review.getReviewId(),
                guardianName,
                review.getRating(),
                review.getReviewText(),
                review.getCreatedAt()
            ));
        }
        return responses;
    }
}
