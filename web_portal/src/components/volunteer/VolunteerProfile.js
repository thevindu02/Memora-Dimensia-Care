// src/components/volunteers/VolunteerProfile.js
import React, { useState, useRef } from "react";
import {
  Box,
  Typography,
  Avatar,
  IconButton,
  Button,
  TextField,
  Select,
  MenuItem,
  FormControl,
  InputLabel,
  Modal,
  Fade,
  Backdrop,
  Stack,
} from "@mui/material";

import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import CameraAltIcon from "@mui/icons-material/CameraAlt";
import EmailOutlinedIcon from "@mui/icons-material/EmailOutlined";
import PhoneOutlinedIcon from "@mui/icons-material/PhoneOutlined";
import EditIcon from "@mui/icons-material/Edit";
import SaveIcon from "@mui/icons-material/Save";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};

const volunteerMock = {
  fullName: "John Smith",
  email: "john.smith@example.com",
  phone: "+1 (555) 123-4567",
  gender: "Male",
  profileImage:
    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
};

const modalStyle = {
  position: "absolute",
  top: "50%",
  left: "50%",
  transform: "translate(-50%, -50%)",
  bgcolor: "#fff",
  borderRadius: 3,
  boxShadow: 24,
  p: 3,
  width: 280,
  outline: "none",
};

export default function VolunteerProfile({ onBack }) {
  const [editMode, setEditMode] = useState(false);
  const [profile, setProfile] = useState(volunteerMock);
  const [tempProfileImage, setTempProfileImage] = useState(profile.profileImage);
  const [modalOpen, setModalOpen] = useState(false);

  const fileInputRef = useRef(null);

  // Handlers for toggling edit mode
  const toggleEditMode = () => {
    if (editMode) {
      // Save action -- here just update profile image permanently
      setProfile((prev) => ({ ...prev, profileImage: tempProfileImage }));
    } else {
      setTempProfileImage(profile.profileImage);
    }
    setEditMode(!editMode);
    setModalOpen(false);
  };

  // Handle avatar click in edit mode: open modal for image selection options
  const onAvatarClick = () => {
    if (!editMode) return;
    setModalOpen(true);
  };

  // Choose 'Upload from gallery' will trigger hidden file input
  const handleUploadClick = () => {
    setModalOpen(false);
    fileInputRef.current?.click();
  };

  // Handle image upload from file input
  const handleFileChange = (event) => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setTempProfileImage(reader.result);
      };
      reader.readAsDataURL(file);
    }
  };

  // Choose 'Take a Photo' (simulate with alert)
  const handleTakePhoto = () => {
    setModalOpen(false);
    alert("Simulate 'Take a Photo' action (not implemented)");
  };

  // Handle form field changes
  const handleChange = (field) => (event) => {
    setProfile((prev) => ({ ...prev, [field]: event.target.value }));
  };

  return (
    <Box
      sx={{
        maxWidth: 480,
        mx: "auto",
        mt: 4,
        mb: 6,
        p: { xs: 2, sm: 3 },
        bgcolor: "#fff",
        borderRadius: 3,
        boxShadow: "0 6px 20px rgba(102, 101, 209, 0.1)",
        fontFamily: "Poppins, Roboto, Arial, sans-serif",
      }}
    >
      {/* Back Button */}
      <IconButton
        onClick={() => {
          if (onBack) onBack();
          else console.log("Back clicked");
        }}
        aria-label="Go back"
        sx={{ mb: 3, color: colors.deepPurple }}
      >
        <ArrowBackIcon fontSize="large" />
      </IconButton>

      {/* Profile Header */}
      <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", mb: 4 }}>
        <Box
          sx={{
            position: "relative",
            width: 150,
            height: 150,
            mb: 2,
            cursor: editMode ? "pointer" : "default",
            borderRadius: "50%",
            overflow: "hidden",
            boxShadow: "0 0 15px rgba(57, 7, 151, 0.2)",
          }}
          onClick={onAvatarClick}
          aria-label={editMode ? "Change profile picture" : "Profile picture"}
          role={editMode ? "button" : undefined}
          tabIndex={editMode ? 0 : undefined}
          onKeyDown={(e) => {
            if (editMode && (e.key === "Enter" || e.key === " ")) {
              onAvatarClick();
            }
          }}
        >
          <Avatar
            src={tempProfileImage}
            alt={`${profile.fullName} profile`}
            sx={{ width: "100%", height: "100%" }}
          />
        </Box>
        {editMode && (
          <Box
            sx={{
              mt: -4,
              mb: 2,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <Button
              variant="outlined"
              startIcon={<CameraAltIcon />}
              onClick={onAvatarClick}
              sx={{
                color: colors.deepPurple,
                borderColor: colors.deepPurple,
                fontWeight: 600,
                bgcolor: "#fff",
                "&:hover": {
                  bgcolor: colors.softLavender,
                  borderColor: colors.deepPurple,
                },
              }}
              aria-label="Change Profile Picture"
            >
              Change Photo
            </Button>
          </Box>
        )}
        <Typography variant="h5" fontWeight={700} sx={{ color: colors.calmNavy }}>
          {profile.fullName}
        </Typography>
        <Typography
          variant="subtitle1"
          sx={{ color: colors.deepPurple, mt: 0.5, userSelect: "none", fontWeight: 600 }}
        >
          Volunteer
        </Typography>
      </Box>

      {/* Editable fields */}
      <Box
        component="form"
        noValidate
        autoComplete="off"
        sx={{
          display: "flex",
          flexDirection: "column",
          gap: 3,
        }}
      >
        {/* Full Name */}
        {editMode ? (
          <TextField
            label="Full Name"
            variant="outlined"
            value={profile.fullName}
            onChange={handleChange("fullName")}
            fullWidth
            InputProps={{
              startAdornment: (
                <Box sx={{ mr: 1, color: colors.deepPurple }}>
                  <EditIcon fontSize="small" />
                </Box>
              ),
            }}
          />
        ) : (
          <FieldDisplay label="Full Name" value={profile.fullName} />
        )}

        {/* Email */}
        {editMode ? (
          <TextField
            label="Email"
            variant="outlined"
            type="email"
            value={profile.email}
            onChange={handleChange("email")}
            fullWidth
            InputProps={{
              startAdornment: (
                <Box sx={{ mr: 1, color: colors.deepPurple }}>
                  <EmailOutlinedIcon fontSize="small" />
                </Box>
              ),
            }}
          />
        ) : (
          <FieldDisplay label="Email" value={profile.email} icon={<EmailOutlinedIcon />} />
        )}

        {/* Phone */}
        {editMode ? (
          <TextField
            label="Phone Number"
            variant="outlined"
            type="tel"
            value={profile.phone}
            onChange={handleChange("phone")}
            fullWidth
            InputProps={{
              startAdornment: (
                <Box sx={{ mr: 1, color: colors.deepPurple }}>
                  <PhoneOutlinedIcon fontSize="small" />
                </Box>
              ),
            }}
          />
        ) : (
          <FieldDisplay label="Phone Number" value={profile.phone} icon={<PhoneOutlinedIcon />} />
        )}

        {/* Gender */}
        {editMode ? (
          <FormControl fullWidth>
            <InputLabel id="gender-label" sx={{ color: colors.deepPurple }}>
              Gender
            </InputLabel>
            <Select
              labelId="gender-label"
              value={profile.gender}
              label="Gender"
              onChange={handleChange("gender")}
              sx={{
                color: colors.deepPurple,
                "& .MuiOutlinedInput-notchedOutline": {
                  borderColor: colors.softLavender,
                },
                "&:hover .MuiOutlinedInput-notchedOutline": {
                  borderColor: colors.deepPurple,
                },
              }}
              size="medium"
            >
              <MenuItem value="Male">Male</MenuItem>
              <MenuItem value="Female">Female</MenuItem>
              <MenuItem value="Other">Other</MenuItem>
              <MenuItem value="Prefer not to say">Prefer not to say</MenuItem>
            </Select>
          </FormControl>
        ) : (
          <FieldDisplay label="Gender" value={profile.gender} />
        )}

        {/* Edit / Save toggle button moved here */}
        <Button
          onClick={toggleEditMode}
          variant="contained"
          startIcon={editMode ? <SaveIcon /> : <EditIcon />}
          sx={{
            mt: 3,
            bgcolor: colors.deepPurple,
            "&:hover": { bgcolor: colors.calmNavy },
            fontWeight: 700,
            textTransform: "none",
            alignSelf: "center",
            minWidth: 140,
          }}
          aria-label={editMode ? "Save profile" : "Edit profile"}
        >
          {editMode ? "Save" : "Edit"}
        </Button>
      </Box>

      {/* Hidden file input for image upload */}
      <input
        type="file"
        accept="image/*"
        style={{ display: "none" }}
        ref={fileInputRef}
        onChange={handleFileChange}
        aria-hidden="true"
        tabIndex={-1}
      />

      {/* Modal for image upload options */}
      <Modal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        aria-labelledby="profile-image-modal-title"
        closeAfterTransition
        slots={{ backdrop: Backdrop }}
        slotProps={{ backdrop: { timeout: 500 } }}
      >
        <Fade in={modalOpen}>
          <Box sx={modalStyle}>
            <Typography id="profile-image-modal-title" variant="h6" mb={2}>
              Change Profile Picture
            </Typography>
            <Stack spacing={2}>
              <Button
                variant="outlined"
                fullWidth
                onClick={handleUploadClick}
                startIcon={<CameraAltIcon />}
                aria-label="Upload from gallery"
              >
                Upload from Gallery
              </Button>
              <Button
                variant="outlined"
                fullWidth
                onClick={handleTakePhoto}
                startIcon={<CameraAltIcon />}
                aria-label="Take a photo"
              >
                Take a Photo
              </Button>
              <Button variant="text" fullWidth onClick={() => setModalOpen(false)}>
                Cancel
              </Button>
            </Stack>
          </Box>
        </Fade>
      </Modal>
    </Box>
  );
}

// Reusable display-only field with optional icon
function FieldDisplay({ label, value, icon }) {
  return (
    <Box
      sx={{
        display: "flex",
        alignItems: "center",
        gap: 1,
        py: 1,
        px: 2,
        borderRadius: 2,
        boxShadow: `0 2px 8px ${colors.softLavender}77`,
        bgcolor: "#FAFAFA",
        userSelect: "text",
      }}
      aria-label={`${label}: ${value}`}
      tabIndex={0}
      role="region"
    >
      {icon && (
        <Box sx={{ color: colors.deepPurple, display: "flex", alignItems: "center" }}>{icon}</Box>
      )}
      <Box>
        <Typography variant="caption" color={colors.deepPurple} sx={{ fontWeight: 600 }}>
          {label}
        </Typography>
        <Typography variant="body1">{value || "-"}</Typography>
      </Box>
    </Box>
  );
}
