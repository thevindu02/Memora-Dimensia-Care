package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.DailyActivityRequest;
import Memora.DimensiaCareApplication.dto.DailyActivityResponse;
import Memora.DimensiaCareApplication.service.DailySchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/daily-activity")
public class DailyActivityController {

    @Autowired
    private DailySchedulerService dailySchedulerService;

    // Update daily activity
    @PutMapping("/{id}")
    public ResponseEntity<DailyActivityResponse> updateDailyActivity(
            @PathVariable("id") Long id,
            @RequestBody DailyActivityRequest request) {
        DailyActivityResponse response = dailySchedulerService.updateDailyActivity(id, request);
        if (response != null) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // You can add more endpoints here (get, delete, etc.)
}
