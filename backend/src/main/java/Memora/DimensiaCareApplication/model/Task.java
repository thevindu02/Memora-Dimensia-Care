package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;

@Entity
@Table(name = "task")
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "taskid")
    private Long taskId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "careactivityid", nullable = false)
    private CareActivity careActivity;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "gameid", nullable = false)
    private Game game;

    // Default constructor
    public Task() {
    }

    // Constructor with parameters
    public Task(CareActivity careActivity, Game game) {
        this.careActivity = careActivity;
        this.game = game;
    }

    // Getters and setters
    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public CareActivity getCareActivity() {
        return careActivity;
    }

    public void setCareActivity(CareActivity careActivity) {
        this.careActivity = careActivity;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }
}
