package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalTime;
import java.util.Set;
import java.util.HashSet;

@Entity
@Table(name = "careactivity")
public class CareActivity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "careactivityid")
    private Long careActivityId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "schedule_id", nullable = false)
    private Schedule schedule;

    @Column(name = "time", nullable = false)
    private LocalTime time;

    @Column(name = "skipreason", columnDefinition = "TEXT")
    private String skipReason;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 50)
    private CareActivityStatus status;
    @OneToMany(mappedBy = "careActivity", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<DailyTask> dailyTasks = new HashSet<>();

    @OneToMany(mappedBy = "careActivity", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<Task> tasks = new HashSet<>();

    // Default constructor
    public CareActivity() {
    }

    // Constructor with parameters
    public CareActivity(Schedule schedule, LocalTime time, CareActivityStatus status) {
        this.schedule = schedule;
        this.time = time;
        this.status = status;
    }

    // Getters and setters
    public Long getCareActivityId() {
        return careActivityId;
    }

    public void setCareActivityId(Long careActivityId) {
        this.careActivityId = careActivityId;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public LocalTime getTime() {
        return time;
    }

    public void setTime(LocalTime time) {
        this.time = time;
    }

    public String getSkipReason() {
        return skipReason;
    }

    public void setSkipReason(String skipReason) {
        this.skipReason = skipReason;
    }

    public CareActivityStatus getStatus() {
        return status;
    }

    public void setStatus(CareActivityStatus status) {
        this.status = status;
    }

    public Set<DailyTask> getDailyTasks() {
        return dailyTasks;
    }

    public void setDailyTasks(Set<DailyTask> dailyTasks) {
        this.dailyTasks = dailyTasks;
    }

    public Set<Task> getTasks() {
        return tasks;
    }

    public void setTasks(Set<Task> tasks) {
        this.tasks = tasks;
    }
}
