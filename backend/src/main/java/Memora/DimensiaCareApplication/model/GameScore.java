package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;

@Entity
@Table(name = "gamescores")
public class GameScore {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "gamescoreid")
    private Long gameScoreId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "gameid", nullable = false)
    private Game game;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @Column(name = "score", nullable = false)
    private Integer score;

    // Default constructor
    public GameScore() {
    }

    // Constructor with parameters
    public GameScore(Game game, Patient patient, Integer score) {
        this.game = game;
        this.patient = patient;
        this.score = score;
    }

    // Getters and setters
    public Long getGameScoreId() {
        return gameScoreId;
    }

    public void setGameScoreId(Long gameScoreId) {
        this.gameScoreId = gameScoreId;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }
}
