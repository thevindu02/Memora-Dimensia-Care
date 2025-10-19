
package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;

@Entity
@Table(name = "medicationreminder")
public class MedicationReminder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "medicationreminder_id")
    private Long medicationReminderId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "careactivity_id", nullable = false)
    private CareActivity careActivity;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "medication_id", nullable = false)
    private Medication medication;

    public Long getMedicationReminderId() {
        return medicationReminderId;
    }

    public void setMedicationReminderId(Long medicationReminderId) {
        this.medicationReminderId = medicationReminderId;
    }

    public CareActivity getCareActivity() {
        return careActivity;
    }

    public void setCareActivity(CareActivity careActivity) {
        this.careActivity = careActivity;
    }

    public Medication getMedication() {
        return medication;
    }

    public void setMedication(Medication medication) {
        this.medication = medication;
    }

    @Override
    public String toString() {
        return "MedicationReminder{" +
                "medicationReminderId=" + medicationReminderId +
                ", careActivityId=" + (careActivity != null ? careActivity.getCareActivityId() : null) +
                ", medicationId=" + (medication != null ? medication.getMedicationId() : null) +
                '}';
    }
}
