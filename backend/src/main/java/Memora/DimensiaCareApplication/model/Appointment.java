package Memora.DimensiaCareApplication.model;

import java.time.LocalDate;
import java.time.LocalTime;

import jakarta.persistence.*;

@Entity
@Table(name = "appointments")
public class Appointment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "appointmentid")
    private Long appointmentId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "careactivityid", nullable = false)
    private CareActivity careActivity;

    @Column(name = "taskname", nullable = false, length = 100)
    private String taskName;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "hospital", nullable = false, length = 100)
    private String hospital;

    @Column(name = "doctorname", nullable = false, length = 100)
    private String doctorName;

    @Column(name = "time")
    private LocalTime time;

    @Column(name = "date")
    private LocalDate date;

    // Getters and setters
    public Long getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Long appointmentId) {
        this.appointmentId = appointmentId;
    }

    public CareActivity getCareActivity() {
        return careActivity;
    }

    public void setCareActivity(CareActivity careActivity) {
        this.careActivity = careActivity;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getHospital() {
        return hospital;
    }

    public void setHospital(String hospital) {
        this.hospital = hospital;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public LocalTime getTime() {
        return time;
    }

    public void setTime(LocalTime time) {
        this.time = time;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }
}
