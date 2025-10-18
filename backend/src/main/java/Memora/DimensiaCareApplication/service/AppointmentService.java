package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.AppointmentRequest;
import Memora.DimensiaCareApplication.model.Appointment;
import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import Memora.DimensiaCareApplication.model.Schedule;
import Memora.DimensiaCareApplication.repository.AppointmentRepository;
import Memora.DimensiaCareApplication.repository.CareActivityRepository;
import Memora.DimensiaCareApplication.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
public class AppointmentService {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Transactional
    public Appointment createAppointment(Long scheduleId, AppointmentRequest request) {
        try {
            // Parse time and date from string format
            LocalTime time = LocalTime.parse(request.getTime(), DateTimeFormatter.ofPattern("HH:mm"));
            LocalDate date = LocalDate.parse(request.getDate());

            // Find the schedule
            Optional<Schedule> scheduleOpt = scheduleRepository.findById(scheduleId);
            if (!scheduleOpt.isPresent()) {
                throw new RuntimeException("Schedule not found with ID: " + scheduleId);
            }

            // Create and save CareActivity first
            CareActivity careActivity = new CareActivity();
            careActivity.setSchedule(scheduleOpt.get());
            careActivity.setTime(time);
            careActivity.setStatus(CareActivityStatus.PENDING);

            CareActivity savedCareActivity = careActivityRepository.save(careActivity);

            // Create and save Appointment
            Appointment appointment = new Appointment();
            appointment.setCareActivity(savedCareActivity);
            appointment.setTaskName(request.getTaskName());
            appointment.setHospital(request.getHospital());
            appointment.setDoctorName(request.getDoctorName());
            appointment.setDescription(request.getDescription());
            appointment.setDate(date);
            appointment.setTime(time);

            return appointmentRepository.save(appointment);

        } catch (Exception e) {
            throw new RuntimeException("Failed to create appointment: " + e.getMessage(), e);
        }
    }

    public List<Appointment> getAppointmentsByScheduleId(Long scheduleId) {
        // Check if schedule is completed
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException("Schedule not found with ID: " + scheduleId));

        if (schedule.getIsCompleted() != null && schedule.getIsCompleted()) {
            return List.of();
        }

        return appointmentRepository.findByScheduleId(scheduleId);
    }

    public List<Appointment> getAppointmentsByCareActivityId(Long careActivityId) {
        return appointmentRepository.findByCareActivityCareActivityId(careActivityId);
    }

    public Optional<Appointment> getAppointmentById(Long appointmentId) {
        return appointmentRepository.findById(appointmentId);
    }

    @Transactional
    public Appointment updateAppointment(Long appointmentId, AppointmentRequest request) {
        try {
            Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
            if (!appointmentOpt.isPresent()) {
                throw new RuntimeException("Appointment not found with ID: " + appointmentId);
            }

            Appointment appointment = appointmentOpt.get();

            // Parse time and date from string format
            LocalTime time = LocalTime.parse(request.getTime(), DateTimeFormatter.ofPattern("HH:mm"));
            LocalDate date = LocalDate.parse(request.getDate());

            // Update appointment fields
            appointment.setTaskName(request.getTaskName());
            appointment.setHospital(request.getHospital());
            appointment.setDoctorName(request.getDoctorName());
            appointment.setDescription(request.getDescription());
            appointment.setDate(date);
            appointment.setTime(time);

            // Update care activity time
            CareActivity careActivity = appointment.getCareActivity();
            careActivity.setTime(time);
            careActivityRepository.save(careActivity);

            return appointmentRepository.save(appointment);

        } catch (Exception e) {
            throw new RuntimeException("Failed to update appointment: " + e.getMessage(), e);
        }
    }

    @Transactional
    public void deleteAppointment(Long appointmentId) {
        try {
            Optional<Appointment> appointmentOpt = appointmentRepository.findById(appointmentId);
            if (!appointmentOpt.isPresent()) {
                throw new RuntimeException("Appointment not found with ID: " + appointmentId);
            }

            Appointment appointment = appointmentOpt.get();
            CareActivity careActivity = appointment.getCareActivity();

            // Delete appointment first
            appointmentRepository.delete(appointment);

            // Then delete the associated care activity
            careActivityRepository.delete(careActivity);

        } catch (Exception e) {
            throw new RuntimeException("Failed to delete appointment: " + e.getMessage(), e);
        }
    }
}
