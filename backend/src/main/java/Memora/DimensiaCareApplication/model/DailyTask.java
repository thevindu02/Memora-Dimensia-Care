package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;

@Entity
@Table(name = "dailytask")
public class DailyTask {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "dailytaskid")
    private Long dailyTaskId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "careactivityid", nullable = false)
    private CareActivity careActivity;

    @Column(name = "dailytaskname", nullable = false, length = 100)
    private String dailyTaskName;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    // Default constructor
    public DailyTask() {
    }

    // Constructor with parameters
    public DailyTask(CareActivity careActivity, String dailyTaskName, String description) {
        this.careActivity = careActivity;
        this.dailyTaskName = dailyTaskName;
        this.description = description;
    }

    // Getters and setters
    public Long getDailyTaskId() {
        return dailyTaskId;
    }

    public void setDailyTaskId(Long dailyTaskId) {
        this.dailyTaskId = dailyTaskId;
    }

    public CareActivity getCareActivity() {
        return careActivity;
    }

    public void setCareActivity(CareActivity careActivity) {
        this.careActivity = careActivity;
    }

    public String getDailyTaskName() {
        return dailyTaskName;
    }

    public void setDailyTaskName(String dailyTaskName) {
        this.dailyTaskName = dailyTaskName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
