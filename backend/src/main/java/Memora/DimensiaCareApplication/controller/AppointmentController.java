package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.AppointmentRequest;
import Memora.DimensiaCareApplication.model.Appointment;
import Memora.DimensiaCareApplication.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/appointments")
@CrossOrigin(origins = "*")
@Validated
public class AppointmentController {

    @Autowired
    private AppointmentService appointmentService;

    @PostMapping("/schedule/{scheduleId}")
    public ResponseEntity<Map<String, Object>> createAppointment(
            @PathVariable Long scheduleId,
            @Valid @RequestBody AppointmentRequest request) {

        Map<String, Object> response = new HashMap<>();

        try {
            Appointment appointment = appointmentService.createAppointment(scheduleId, request);
            response.put("success", true);
            response.put("message", "Appointment created successfully");

            Map<String, Object> appointmentData = new HashMap<>();
            appointmentData.put("appointmentId", appointment.getAppointmentId());
            appointmentData.put("careActivityId",
                    appointment.getCareActivity() != null
                            ? appointment.getCareActivity().getCareActivityId()
                            : null);
            appointmentData.put("taskName", appointment.getTaskName());
            appointmentData.put("hospital", appointment.getHospital());
            appointmentData.put("doctorName", appointment.getDoctorName());
            appointmentData.put("description", appointment.getDescription());
            appointmentData.put("date", appointment.getDate() != null ? appointment.getDate().toString() : null);
            appointmentData.put("time", appointment.getTime() != null ? appointment.getTime().toString() : null);
            appointmentData.put("status",
                    appointment.getCareActivity() != null && appointment.getCareActivity().getStatus() != null
                            ? appointment.getCareActivity().getStatus().toString()
                            : "PENDING");

            response.put("data", appointmentData);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to create appointment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/schedule/{scheduleId}")
    public ResponseEntity<List<Map<String, Object>>> getAppointmentsByScheduleId(@PathVariable Long scheduleId) {
        try {
            List<Appointment> appointments = appointmentService.getAppointmentsByScheduleId(scheduleId);
            List<Map<String, Object>> data = new ArrayList<>();

            for (Appointment appointment : appointments) {
                Map<String, Object> item = new HashMap<>();
                item.put("appointmentId", appointment.getAppointmentId());
                item.put("careActivityId",
                        appointment.getCareActivity() != null
                                ? appointment.getCareActivity().getCareActivityId()
                                : null);
                item.put("taskName", appointment.getTaskName());
                item.put("hospital", appointment.getHospital());
                item.put("doctorName", appointment.getDoctorName());
                item.put("description", appointment.getDescription());
                item.put("date", appointment.getDate() != null ? appointment.getDate().toString() : null);
                item.put("time", appointment.getTime() != null ? appointment.getTime().toString() : null);
                item.put("status",
                        appointment.getCareActivity() != null && appointment.getCareActivity().getStatus() != null
                                ? appointment.getCareActivity().getStatus().toString()
                                : "PENDING");
                data.add(item);
            }

            return ResponseEntity.ok(data);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ArrayList<>());
        }
    }

    @GetMapping("/{appointmentId}")
    public ResponseEntity<Map<String, Object>> getAppointmentById(@PathVariable Long appointmentId) {
        Map<String, Object> response = new HashMap<>();
        try {
            Optional<Appointment> appointmentOpt = appointmentService.getAppointmentById(appointmentId);
            if (appointmentOpt.isPresent()) {
                Appointment appointment = appointmentOpt.get();
                response.put("success", true);
                response.put("message", "Appointment retrieved successfully");

                Map<String, Object> appointmentData = new HashMap<>();
                appointmentData.put("appointmentId", appointment.getAppointmentId());
                appointmentData.put("careActivityId",
                        appointment.getCareActivity() != null
                                ? appointment.getCareActivity().getCareActivityId()
                                : null);
                appointmentData.put("taskName", appointment.getTaskName());
                appointmentData.put("hospital", appointment.getHospital());
                appointmentData.put("doctorName", appointment.getDoctorName());
                appointmentData.put("description", appointment.getDescription());
                appointmentData.put("date", appointment.getDate() != null ? appointment.getDate().toString() : null);
                appointmentData.put("time", appointment.getTime() != null ? appointment.getTime().toString() : null);
                appointmentData.put("status",
                        appointment.getCareActivity() != null && appointment.getCareActivity().getStatus() != null
                                ? appointment.getCareActivity().getStatus().toString()
                                : "PENDING");

                response.put("data", appointmentData);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Appointment not found");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to retrieve appointment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PutMapping("/{appointmentId}")
    public ResponseEntity<Map<String, Object>> updateAppointment(
            @PathVariable Long appointmentId,
            @Valid @RequestBody AppointmentRequest request) {

        Map<String, Object> response = new HashMap<>();

        try {
            Appointment appointment = appointmentService.updateAppointment(appointmentId, request);
            response.put("success", true);
            response.put("message", "Appointment updated successfully");

            Map<String, Object> appointmentData = new HashMap<>();
            appointmentData.put("appointmentId", appointment.getAppointmentId());
            appointmentData.put("careActivityId",
                    appointment.getCareActivity() != null
                            ? appointment.getCareActivity().getCareActivityId()
                            : null);
            appointmentData.put("taskName", appointment.getTaskName());
            appointmentData.put("hospital", appointment.getHospital());
            appointmentData.put("doctorName", appointment.getDoctorName());
            appointmentData.put("description", appointment.getDescription());
            appointmentData.put("date", appointment.getDate() != null ? appointment.getDate().toString() : null);
            appointmentData.put("time", appointment.getTime() != null ? appointment.getTime().toString() : null);
            appointmentData.put("status",
                    appointment.getCareActivity() != null && appointment.getCareActivity().getStatus() != null
                            ? appointment.getCareActivity().getStatus().toString()
                            : "PENDING");

            response.put("data", appointmentData);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to update appointment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @DeleteMapping("/{appointmentId}")
    public ResponseEntity<Map<String, Object>> deleteAppointment(@PathVariable Long appointmentId) {
        Map<String, Object> response = new HashMap<>();
        try {
            appointmentService.deleteAppointment(appointmentId);
            response.put("success", true);
            response.put("message", "Appointment deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to delete appointment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
