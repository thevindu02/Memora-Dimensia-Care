package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.MedicationReminderRequest;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import Memora.DimensiaCareApplication.model.MedicationReminder;
import Memora.DimensiaCareApplication.service.MedicationReminderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/medications")
@CrossOrigin(origins = "*")
@Validated
public class MedicationReminderController {

    @Autowired
    private MedicationReminderService medicationReminderService;

    @PostMapping("/schedule/{scheduleId}")
    public ResponseEntity<Map<String, Object>> addMedicationReminder(
            @PathVariable Long scheduleId,
            @Valid @RequestBody MedicationReminderRequest request) {

        Map<String, Object> response = new HashMap<>();

        try {
            MedicationReminder medicationReminder = medicationReminderService.addMedicationReminder(scheduleId,
                    request);
            response.put("success", true);
            response.put("message", "Medication reminder added successfully");
            Map<String, Object> medicationData = new HashMap<>();
            medicationData.put("medicationReminderId", medicationReminder.getMedicationReminderId());
            medicationData.put("careActivityId",
                    medicationReminder.getCareActivity() != null
                            ? medicationReminder.getCareActivity().getCareActivityId()
                            : null);
            medicationData.put("medicationId",
                    medicationReminder.getMedication() != null ? medicationReminder.getMedication().getMedicationId()
                            : null);
            response.put("data", medicationData);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to add medication reminder: " + e.getMessage());

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/{medicationReminderId}")
    public ResponseEntity<Map<String, Object>> getMedicationReminderById(@PathVariable Long medicationReminderId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<MedicationReminder> medicationReminder = medicationReminderService
                    .getMedicationReminderById(medicationReminderId);
            if (medicationReminder.isPresent()) {
                response.put("success", true);
                response.put("message", "Medication reminder retrieved successfully");
                MedicationReminder med = medicationReminder.get();
                Map<String, Object> medicationData = new HashMap<>();
                medicationData.put("medicationReminderId", med.getMedicationReminderId());
                medicationData.put("careActivityId",
                        med.getCareActivity() != null ? med.getCareActivity().getCareActivityId() : null);
                medicationData.put("medicationId",
                        med.getMedication() != null ? med.getMedication().getMedicationId() : null);
                response.put("data", medicationData);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Medication reminder not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to retrieve medication reminder: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @DeleteMapping("/{medicationReminderId}")
    public ResponseEntity<Map<String, Object>> deleteMedicationReminder(@PathVariable Long medicationReminderId) {
        Map<String, Object> response = new HashMap<>();
        try {
            medicationReminderService.deleteMedicationReminder(medicationReminderId);
            response.put("success", true);
            response.put("message", "Medication reminder deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to delete medication reminder: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/schedule/{scheduleId}")
    public ResponseEntity<Map<String, Object>> getMedicationRemindersByScheduleId(@PathVariable Long scheduleId) {
        Map<String, Object> response = new HashMap<>();
        try {
            List<MedicationReminder> reminders = medicationReminderService
                    .getMedicationRemindersByScheduleId(scheduleId);
            List<Map<String, Object>> data = new java.util.ArrayList<>();
            for (MedicationReminder reminder : reminders) {
                Map<String, Object> item = new HashMap<>();
                item.put("medicationReminderId", reminder.getMedicationReminderId());
                item.put("careActivityId",
                        reminder.getCareActivity() != null ? reminder.getCareActivity().getCareActivityId() : null);
                item.put("medicationId",
                        reminder.getMedication() != null ? reminder.getMedication().getMedicationId() : null);

                // Add medication details
                if (reminder.getMedication() != null) {
                    item.put("medicationName", reminder.getMedication().getMedicationName());
                    item.put("dosage", reminder.getMedication().getDosage());
                    item.put("mealTiming", reminder.getMedication().getMealTiming());
                    item.put("description", reminder.getMedication().getDescription());
                    item.put("fromDate", reminder.getMedication().getFromDate());
                    item.put("dueDate", reminder.getMedication().getDueDate());
                    item.put("time", reminder.getMedication().getTime());
                }
                // Add care activity details
                if (reminder.getCareActivity() != null) {
                    item.put("reminderTime", reminder.getCareActivity().getTime());
                    item.put("status", reminder.getCareActivity().getStatus());
                }
                data.add(item);
            }
            response.put("success", true);
            response.put("message", "Medication reminders retrieved successfully");
            response.put("data", data);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to retrieve medication reminders: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
