import React, { useState } from "react";
import axios from "axios";

const AddKnownCaregiverForm = () => {
  const [caregiverEmail, setCaregiverEmail] = useState("");
  const [patientId, setPatientId] = useState("");
  const [guardianId, setGuardianId] = useState("");
  const [result, setResult] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setResult(null);
    try {
      const response = await axios.post("/api/guardian/add-known-caregiver", {
        caregiverEmail,
        patientId,
        guardianId,
      });
      setResult(response.data);
    } catch (error) {
      setResult({ success: false, message: error.response?.data?.message || "Error occurred" });
    }
  };

  return (
    <div>
      <h2>Add Known Caregiver</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label>Caregiver Email:</label>
          <input
            type="email"
            value={caregiverEmail}
            onChange={(e) => setCaregiverEmail(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Patient ID:</label>
          <input
            type="text"
            value={patientId}
            onChange={(e) => setPatientId(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Guardian ID:</label>
          <input
            type="text"
            value={guardianId}
            onChange={(e) => setGuardianId(e.target.value)}
            required
          />
        </div>
        <button type="submit">Add Caregiver</button>
      </form>
      {result && (
        <div style={{ color: result.success ? "green" : "red", marginTop: "1em" }}>
          {result.message}
        </div>
      )}
    </div>
  );
};

export default AddKnownCaregiverForm; 