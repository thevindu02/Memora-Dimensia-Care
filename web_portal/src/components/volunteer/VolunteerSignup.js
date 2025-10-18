// src/components/volunteers/VolunteerSignup.js
import React, { useState, useRef } from "react";
import {
  Box,
  Typography,
  TextField,
  Button,
  IconButton,
  MenuItem,
  Select,
  InputLabel,
  FormControl,
  Tooltip,
  CircularProgress,
  Dialog,
  DialogContent,
  DialogTitle,
  Stack,
  Avatar,
} from "@mui/material";
import { useNavigate } from "react-router-dom";

import PersonIcon from "@mui/icons-material/Person";
import EmailIcon from "@mui/icons-material/Email";
import PhoneIcon from "@mui/icons-material/Phone";
import UploadFileIcon from "@mui/icons-material/UploadFile";
import CancelIcon from "@mui/icons-material/Cancel";
import CheckCircleOutlineIcon from "@mui/icons-material/CheckCircleOutline";
import InfoOutlinedIcon from "@mui/icons-material/InfoOutlined";

import VolunteerService from "../../services/volunteerService";
import CONFIG from "../../config/api";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};

export default function VolunteerSignup({ open, onClose }) {
  // Form state
  const [form, setForm] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    gender: "",
    volunteerIDImage: null, // File object or base64
    volunteerIDImageFile: null, // Actual file object for upload
  });

  // Validation errors
  const [errors, setErrors] = useState({});

  // Submission loading state
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Submission success state
  const [success, setSuccess] = useState(false);

  // Ref for hidden file input
  const fileInputRef = useRef(null);
  const navigate = useNavigate();

  // Handle input change with real-time validation
  const handleChange = (field) => (event) => {
    const value = event.target.value;
    setForm((prev) => ({ ...prev, [field]: value }));
    
    // Real-time validation feedback
    if (errors[field]) {
      let isValid = false;
      switch (field) {
        case 'firstName':
        case 'lastName':
          isValid = validateName(value.trim()) && value.trim().length <= 50;
          break;
        case 'email':
          isValid = validateEmail(value.trim()) && value.trim().length <= 100;
          break;
        case 'phone':
          isValid = validatePhone(value.trim());
          break;
        case 'gender':
          isValid = !!value;
          break;
        default:
          isValid = true;
      }
      
      if (isValid) {
        setErrors((prev) => ({ ...prev, [field]: null }));
      }
    }
  };

  // Handle image upload change
  const handleImageChange = (event) => {
    const file = event.target.files?.[0];
    if (file) {
      // Validate file type
      if (!CONFIG.UPLOAD_SETTINGS.ALLOWED_FILE_TYPES.includes(file.type)) {
        setErrors((prev) => ({
          ...prev,
          volunteerIDImage: "Please upload a valid image file (JPEG, JPG, PNG, GIF)",
        }));
        return;
      }

      // Validate file size
      if (file.size > CONFIG.UPLOAD_SETTINGS.MAX_FILE_SIZE) {
        setErrors((prev) => ({
          ...prev,
          volunteerIDImage: "File size too large. Please upload an image smaller than 5MB",
        }));
        return;
      }
      
      // Store both the file and preview
      const reader = new FileReader();
      reader.onloadend = () => {
        setForm((prev) => ({ 
          ...prev, 
          volunteerIDImage: reader.result,
          volunteerIDImageFile: file
        }));
        setErrors((prev) => ({ ...prev, volunteerIDImage: null }));
      };
      reader.readAsDataURL(file);
    }
  };

  // Validate email format
  const validateEmail = (email) => {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
  };

  // Validate name (only letters, spaces, hyphens, apostrophes)
  const validateName = (name) => {
    const regex = /^[a-zA-Z\s\-']+$/;
    return regex.test(name) && name.trim().length >= 2;
  };

  // Validate Sri Lankan phone number (without country code)
  const validatePhone = (phone) => {
    // Updated regex for Sri Lankan numbers: 07XXXXXXXX or 7XXXXXXXX
    const regex = /^0?7[0-9]{8}$/;
    return regex.test(phone);
  };

  // Check if email looks like an organizational email
  const isOrganizationalEmail = (email) => {
    const personalDomains = ['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'live.com'];
    const domain = email.split('@')[1]?.toLowerCase();
    return !personalDomains.includes(domain);
  };

  // Validate entire form
  const validateForm = () => {
    let newErrors = {};

    // First name validation
    if (!form.firstName.trim()) {
      newErrors.firstName = "First name is required";
    } else if (!validateName(form.firstName.trim())) {
      newErrors.firstName = "First name should only contain letters and be at least 2 characters";
    } else if (form.firstName.trim().length > 50) {
      newErrors.firstName = "First name should not exceed 50 characters";
    }

    // Last name validation
    if (!form.lastName.trim()) {
      newErrors.lastName = "Last name is required";
    } else if (!validateName(form.lastName.trim())) {
      newErrors.lastName = "Last name should only contain letters and be at least 2 characters";
    } else if (form.lastName.trim().length > 50) {
      newErrors.lastName = "Last name should not exceed 50 characters";
    }

    // Email validation
    if (!form.email.trim()) {
      newErrors.email = "Email is required";
    } else if (!validateEmail(form.email.trim())) {
      newErrors.email = "Please enter a valid email address";
    } else if (form.email.trim().length > 100) {
      newErrors.email = "Email should not exceed 100 characters";
    }

    // Phone number validation
    if (!form.phone.trim()) {
      newErrors.phone = "Phone number is required";
    } else if (!validatePhone(form.phone.trim())) {
      newErrors.phone = "Please enter a valid Sri Lankan phone number (e.g., 0712345678)";
    }

    // Gender validation
    if (!form.gender) {
      newErrors.gender = "Please select your gender";
    }

    // Image validation
    if (!form.volunteerIDImage) {
      newErrors.volunteerIDImage = "Volunteer ID image is required";
    }

    setErrors(newErrors);

    return Object.keys(newErrors).length === 0;
  };

  // Handle submit
  const handleSubmit = async (event) => {
    event.preventDefault();
    if (!validateForm()) return;

    setIsSubmitting(true);

    try {
      let imageUrl = "";

      // First, upload the image if provided
      if (form.volunteerIDImageFile) {
        const imageUploadResult = await VolunteerService.uploadVolunteerImage(form.volunteerIDImageFile);
        
        if (imageUploadResult.success) {
          imageUrl = imageUploadResult.imageUrl;
        } else {
          // Fallback to base64 if upload fails
          console.warn("Image upload failed, using base64 fallback:", imageUploadResult.message);
          imageUrl = form.volunteerIDImage;
        }
      } else {
        imageUrl = form.volunteerIDImage;
      }

      // Create volunteer request
      const volunteerData = {
        volunteerName: `${form.firstName.trim()} ${form.lastName.trim()}`,
        email: form.email.trim(),
        phoneNumber: form.phone.trim(),
        gender: form.gender,
        volunteerIdImage: imageUrl,
      };

      const result = await VolunteerService.createVolunteerRequest(volunteerData);

      setIsSubmitting(false);

      if (result.success) {
        setSuccess(true);

        // Navigate to submitted screen after short delay
        setTimeout(() => {
          setSuccess(false);
          setForm({
            firstName: "",
            lastName: "",
            email: "",
            phone: "",
            gender: "",
            volunteerIDImage: null,
            volunteerIDImageFile: null,
          });
          setErrors({});
          navigate("/VolunteerRegistrationSubmitted");
          if (onClose) onClose();
        }, 1500); // Short delay for UX
      } else {
        // Show error message
        setErrors({ submit: result.message });
      }
    } catch (error) {
      setIsSubmitting(false);
      console.error("Error submitting volunteer registration:", error);
      setErrors({ submit: "An unexpected error occurred. Please try again." });
    }
  };

  // Remove uploaded image
  const handleRemoveImage = () => {
    setForm((prev) => ({ 
      ...prev, 
      volunteerIDImage: null,
      volunteerIDImageFile: null 
    }));
    setErrors((prev) => ({ ...prev, volunteerIDImage: null }));
    if (fileInputRef.current) fileInputRef.current.value = null;
  };

  // Start file open dialog
  const openFileDialog = () => {
    if (fileInputRef.current) fileInputRef.current.click();
  };

  // Render as a dialog if open prop is provided, else as a page
  if (typeof open !== "undefined") {
    return (
      <Dialog
        open={open}
        onClose={isSubmitting ? null : onClose}
        maxWidth="sm"
        fullWidth
        PaperProps={{
          sx: {
            borderRadius: 4,
            p: 4,
            position: "relative",
            background: `linear-gradient(135deg, ${colors.softLavender} 0%, ${colors.lightSkyBlue} 100%)`,
            boxShadow: "0 4px 20px rgba(57,7,151,0.3)",
          },
        }}
        aria-labelledby="volunteer-signup-title"
        disableEscapeKeyDown={isSubmitting}
        disableBackdropClick={isSubmitting}
      >
        <DialogTitle
          id="volunteer-signup-title"
          sx={{ mb: 3, fontWeight: 700, color: colors.calmNavy }}
        >
          Volunteer Registration
        </DialogTitle>

        <DialogContent dividers>
          <Box
            component="form"
            noValidate
            onSubmit={handleSubmit}
            sx={{
              display: "flex",
              flexDirection: "column",
              gap: 3,
              bgcolor: "white",
              p: 3,
              borderRadius: 3,
              boxShadow: `0 4px 12px ${colors.softLavender}aa`,
            }}
          >
            {/* Section: Name */}
            <Typography
              variant="subtitle1"
              sx={{ color: colors.deepPurple, fontWeight: 600 }}
            >
              Name
            </Typography>
            <Stack direction={{ xs: "column", sm: "row" }} spacing={2}>
              <TextField
                label="First Name"
                required
                fullWidth
                value={form.firstName}
                onChange={handleChange("firstName")}
                error={!!errors.firstName}
                helperText={errors.firstName}
                inputProps={{ maxLength: 50 }}
                InputProps={{
                  startAdornment: (
                    <PersonIcon sx={{ color: colors.deepPurple, mr: 1 }} />
                  ),
                }}
                size="small"
              />
              <TextField
                label="Last Name"
                required
                fullWidth
                value={form.lastName}
                onChange={handleChange("lastName")}
                error={!!errors.lastName}
                helperText={errors.lastName}
                inputProps={{ maxLength: 50 }}
                InputProps={{
                  startAdornment: (
                    <PersonIcon sx={{ color: colors.deepPurple, mr: 1 }} />
                  ),
                }}
                size="small"
              />
            </Stack>

            {/* Email */}
            <Box>
              <Typography
                variant="subtitle1"
                sx={{
                  color: colors.deepPurple,
                  fontWeight: 600,
                  mb: 0.5,
                  display: "flex",
                  alignItems: "center",
                  gap: 0.5,
                }}
              >
                Email Address
                <Tooltip title="Please enter the email address given by your organization" arrow>
                  <InfoOutlinedIcon
                    fontSize="small"
                    sx={{ color: colors.lightSkyBlue, cursor: "help" }}
                  />
                </Tooltip>
              </Typography>
              <TextField
                label="Email Address"
                type="email"
                required
                fullWidth
                value={form.email}
                onChange={handleChange("email")}
                error={!!errors.email}
                helperText={errors.email}
                inputProps={{ maxLength: 100 }}
                InputProps={{
                  startAdornment: (
                    <EmailIcon sx={{ color: colors.deepPurple, mr: 1 }} />
                  ),
                }}
                size="small"
              />
            </Box>

            {/* Phone Number */}
            <Box>
              <Typography
                variant="subtitle1"
                sx={{ color: colors.deepPurple, fontWeight: 600, mb: 0.5 }}
              >
                Phone Number
              </Typography>
              <Stack direction="row" spacing={1} alignItems="center">
                <Box
                  sx={{
                    px: 1.5,
                    py: 1,
                    bgcolor: colors.softLavender,
                    borderRadius: 1,
                    fontWeight: 700,
                    color: colors.deepPurple,
                    userSelect: "none",
                    minWidth: 45,
                    textAlign: "center",
                  }}
                >
                  +94
                </Box>
                <TextField
                  placeholder="7XXXXXXXX"
                  variant="outlined"
                  required
                  fullWidth
                  value={form.phone}
                  onChange={(e) => {
                    // Only allow numbers and limit length
                    let value = e.target.value.replace(/[^0-9]/g, "");
                    
                    // Limit to 10 digits max (Sri Lankan numbers)
                    if (value.length > 10) {
                      value = value.slice(0, 10);
                    }
                    
                    setForm((prev) => ({ ...prev, phone: value }));
                    
                    // Real-time validation for phone
                    if (errors.phone && validatePhone(value)) {
                      setErrors((prev) => ({ ...prev, phone: null }));
                    }
                  }}
                  error={!!errors.phone}
                  helperText={errors.phone}
                  size="small"
                  InputProps={{
                    startAdornment: (
                      <PhoneIcon sx={{ color: colors.deepPurple, mr: 1 }} />
                    ),
                    inputMode: "numeric",
                    pattern: "[0-9]*",
                  }}
                />
              </Stack>
            </Box>

            {/* Gender */}
            <FormControl fullWidth size="small" required error={!!errors.gender}>
              <InputLabel id="gender-label" sx={{ color: colors.deepPurple }}>
                Gender
              </InputLabel>
              <Select
                labelId="gender-label"
                label="Gender"
                value={form.gender}
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
              >
                <MenuItem value="Male">Male</MenuItem>
                <MenuItem value="Female">Female</MenuItem>
                <MenuItem value="Other">Other</MenuItem>
              </Select>
              {!!errors.gender && (
                <Typography variant="caption" color="error" sx={{ mt: 0.5 }}>
                  {errors.gender}
                </Typography>
              )}
            </FormControl>

            {/* Volunteer ID Image Upload */}
            <Box>
              <Typography
                variant="subtitle1"
                sx={{ color: colors.deepPurple, fontWeight: 600, mb: 1 }}
              >
                Volunteer ID Image
              </Typography>

              <Box
                onClick={openFileDialog}
                sx={{
                  position: "relative",
                  border: `2px dashed ${
                    errors.volunteerIDImage ? "red" : colors.softLavender
                  }`,
                  borderRadius: 3,
                  height: 170,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  color: colors.deepPurple,
                  cursor: "pointer",
                  bgcolor: colors.softLavender + "33",
                  transition: "border-color 0.3s ease",
                  "&:hover": {
                    borderColor: colors.deepPurple,
                    bgcolor: colors.softLavender + "44",
                  },
                }}
              >
                {form.volunteerIDImage ? (
                  <>
                    <Avatar
                      src={form.volunteerIDImage}
                      variant="rounded"
                      alt="Volunteer ID preview"
                      sx={{ width: "auto", height: "100%", maxWidth: "100%" }}
                    />
                    <IconButton
                      aria-label="Remove uploaded image"
                      onClick={(e) => {
                        e.stopPropagation();
                        handleRemoveImage();
                      }}
                      sx={{
                        position: "absolute",
                        top: 4,
                        right: 4,
                        bgcolor: "rgba(57,7,151,0.7)",
                        color: "white",
                        "&:hover": { bgcolor: colors.deepPurple },
                      }}
                      size="small"
                    >
                      <CancelIcon fontSize="small" />
                    </IconButton>
                  </>
                ) : (
                  <Stack
                    direction="column"
                    alignItems="center"
                    spacing={1}
                    sx={{ userSelect: "none" }}
                  >
                    <UploadFileIcon sx={{ fontSize: 48 }} />
                    <Typography
                      variant="body2"
                      sx={{ maxWidth: 200, textAlign: "center" }}
                    >
                      Drag & drop or click to upload a clear image of your volunteer
                      ID
                    </Typography>
                  </Stack>
                )}
                <input
                  type="file"
                  accept="image/*"
                  ref={fileInputRef}
                  onChange={handleImageChange}
                  style={{ display: "none" }}
                  aria-label="Upload volunteer ID image"
                />
              </Box>
              {!!errors.volunteerIDImage && (
                <Typography variant="caption" color="error" sx={{ mt: 0.5 }}>
                  {errors.volunteerIDImage}
                </Typography>
              )}
            </Box>

            {/* Display submission error if any */}
            {errors.submit && (
              <Typography 
                variant="body2" 
                color="error" 
                sx={{ 
                  mt: 2, 
                  p: 2, 
                  bgcolor: "#ffebee", 
                  borderRadius: 2,
                  border: "1px solid #f44336"
                }}
              >
                {errors.submit}
              </Typography>
            )}

            {/* Submit Button & Success Animation */}
            <Box sx={{ textAlign: "center", pt: 1 }}>
              {success ? (
                <Box
                  sx={{
                    color: colors.calmNavy,
                    display: "flex",
                    flexDirection: "column",
                    alignItems: "center",
                    gap: 1,
                    userSelect: "none",
                  }}
                  role="alert"
                  aria-live="polite"
                >
                  <CheckCircleOutlineIcon
                    sx={{ fontSize: 48, color: colors.lightSkyBlue }}
                  />
                  <Typography
                    variant="h6"
                    sx={{ color: colors.deepPurple, fontWeight: 700 }}
                  >
                    Registration Successful!
                  </Typography>
                  <Typography>Your volunteer registration has been submitted.</Typography>
                </Box>
              ) : (
                <>
                  <Button
                    type="submit"
                    variant="contained"
                    disabled={isSubmitting}
                    sx={{
                      bgcolor: `linear-gradient(45deg, ${colors.deepPurple}, ${colors.calmNavy})`,
                      px: 6,
                      py: 1.5,
                      fontWeight: 700,
                      letterSpacing: 0.5,
                      borderRadius: 3,
                      color: "white",
                      fontSize: 16,
                      boxShadow: `0 4px 15px ${colors.deepPurple}aa`,
                      transition: "all 0.3s ease",
                      "&:hover:not(:disabled)": {
                        bgcolor: `linear-gradient(45deg, ${colors.calmNavy}, ${colors.deepPurple})`,
                        boxShadow: `0 6px 20px ${colors.calmNavy}cc`,
                      },
                    }}
                    aria-label="Submit volunteer registration"
                  >
                    {isSubmitting ? <CircularProgress color="inherit" size={24} /> : "Register"}
                  </Button>

                  {/* === Add "Already have an account? Sign in" below the button === */}
                  <Typography
                    variant="body2"
                    sx={{ mt: 2, color: colors.calmNavy }}
                  >
                    Already have an account?{" "}
                    <Box
                      component="span"
                      sx={{
                        color: colors.deepPurple,
                        fontWeight: 700,
                        cursor: "pointer",
                        textDecoration: "underline",
                        "&:hover": { color: colors.lightSkyBlue },
                      }}
                      onClick={() => navigate("/login")} // Adjust login route if needed
                      tabIndex={0}
                      role="link"
                      onKeyPress={(e) => {
                        if (e.key === "Enter" || e.key === " ") {
                          navigate("/login");
                        }
                      }}
                    >
                      Sign in
                    </Box>
                  </Typography>
                </>
              )}
            </Box>
          </Box>
        </DialogContent>
      </Dialog>
    );
  }

  // Render as a standalone page
  return (
    <Box
      sx={{
        maxWidth: 600,
        mx: "auto",
        my: 6,
        p: 4,
        bgcolor: "#fff",
        borderRadius: 4,
        boxShadow: "0 4px 20px rgba(57,7,151,0.1)",
      }}
    >
      <Typography variant="h4" sx={{ mb: 3, fontWeight: 700, color: colors.calmNavy }}>
        Volunteer Registration
      </Typography>
      <Box
        component="form"
        noValidate
        onSubmit={handleSubmit}
        sx={{
          display: "flex",
          flexDirection: "column",
          gap: 3,
          bgcolor: "white",
          p: 3,
          borderRadius: 3,
          boxShadow: `0 4px 12px ${colors.softLavender}aa`,
        }}
      >
        {/* Section: Name */}
        <Typography variant="subtitle1" sx={{ color: colors.deepPurple, fontWeight: 600 }}>
          Name
        </Typography>
        <Stack direction={{ xs: "column", sm: "row" }} spacing={2}>
          <TextField
            label="First Name"
            required
            fullWidth
            value={form.firstName}
            onChange={handleChange("firstName")}
            error={!!errors.firstName}
            helperText={errors.firstName}
            inputProps={{ maxLength: 50 }}
            InputProps={{
              startAdornment: <PersonIcon sx={{ color: colors.deepPurple, mr: 1 }} />,
            }}
            size="small"
          />
          <TextField
            label="Last Name"
            required
            fullWidth
            value={form.lastName}
            onChange={handleChange("lastName")}
            error={!!errors.lastName}
            helperText={errors.lastName}
            inputProps={{ maxLength: 50 }}
            InputProps={{
              startAdornment: <PersonIcon sx={{ color: colors.deepPurple, mr: 1 }} />,
            }}
            size="small"
          />
        </Stack>

        {/* Email */}
        <Box>
          <Typography
            variant="subtitle1"
            sx={{ color: colors.deepPurple, fontWeight: 600, mb: 0.5, display: "flex", alignItems: "center", gap: 0.5 }}
          >
            Email Address
            <Tooltip title="Please enter the email address given by your organization" arrow>
              <InfoOutlinedIcon fontSize="small" sx={{ color: colors.lightSkyBlue, cursor: "help" }} />
            </Tooltip>
          </Typography>
          <TextField
            label="Email Address"
            type="email"
            required
            fullWidth
            value={form.email}
            onChange={handleChange("email")}
            error={!!errors.email}
            helperText={errors.email}
            inputProps={{ maxLength: 100 }}
            InputProps={{
              startAdornment: <EmailIcon sx={{ color: colors.deepPurple, mr: 1 }} />,
            }}
            size="small"
          />
        </Box>

        {/* Phone Number */}
        <Box>
          <Typography variant="subtitle1" sx={{ color: colors.deepPurple, fontWeight: 600, mb: 0.5 }}>
            Phone Number
          </Typography>
          <Stack direction="row" spacing={1} alignItems="center">
            <Box
              sx={{
                px: 1.5,
                py: 1,
                bgcolor: colors.softLavender,
                borderRadius: 1,
                fontWeight: 700,
                color: colors.deepPurple,
                userSelect: "none",
                minWidth: 45,
                textAlign: "center",
              }}
            >
              +94
            </Box>
            <TextField
              placeholder="7XXXXXXXX"
              variant="outlined"
              required
              fullWidth
              value={form.phone}
              onChange={(e) => {
                // Only allow numbers and limit length
                let value = e.target.value.replace(/[^0-9]/g, "");
                
                // Limit to 10 digits max (Sri Lankan numbers)
                if (value.length > 10) {
                  value = value.slice(0, 10);
                }
                
                setForm((prev) => ({ ...prev, phone: value }));
                
                // Real-time validation for phone
                if (errors.phone && validatePhone(value)) {
                  setErrors((prev) => ({ ...prev, phone: null }));
                }
              }}
              error={!!errors.phone}
              helperText={errors.phone}
              size="small"
              InputProps={{
                startAdornment: <PhoneIcon sx={{ color: colors.deepPurple, mr: 1 }} />,
                inputMode: "numeric",
                pattern: "[0-9]*",
              }}
            />
          </Stack>
        </Box>

        {/* Gender */}
        <FormControl fullWidth size="small" required error={!!errors.gender}>
          <InputLabel id="gender-label" sx={{ color: colors.deepPurple }}>
            Gender
          </InputLabel>
          <Select
            labelId="gender-label"
            label="Gender"
            value={form.gender}
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
          >
            <MenuItem value="Male">Male</MenuItem>
            <MenuItem value="Female">Female</MenuItem>
            <MenuItem value="Other">Other</MenuItem>
          </Select>
          {!!errors.gender && (
            <Typography variant="caption" color="error" sx={{ mt: 0.5 }}>
              {errors.gender}
            </Typography>
          )}
        </FormControl>

        {/* Volunteer ID Image Upload */}
        <Box>
          <Typography variant="subtitle1" sx={{ color: colors.deepPurple, fontWeight: 600, mb: 1 }}>
            Volunteer ID Image
          </Typography>

          <Box
            onClick={openFileDialog}
            sx={{
              position: "relative",
              border: `2px dashed ${errors.volunteerIDImage ? "red" : colors.softLavender}`,
              borderRadius: 3,
              height: 170,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              color: colors.deepPurple,
              cursor: "pointer",
              bgcolor: colors.softLavender + "33",
              transition: "border-color 0.3s ease",
              "&:hover": {
                borderColor: colors.deepPurple,
                bgcolor: colors.softLavender + "44",
              },
            }}
          >
            {form.volunteerIDImage ? (
              <>
                <Avatar
                  src={form.volunteerIDImage}
                  variant="rounded"
                  alt="Volunteer ID preview"
                  sx={{ width: "auto", height: "100%", maxWidth: "100%" }}
                />
                <IconButton
                  aria-label="Remove uploaded image"
                  onClick={(e) => {
                    e.stopPropagation();
                    handleRemoveImage();
                  }}
                  sx={{
                    position: "absolute",
                    top: 4,
                    right: 4,
                    bgcolor: "rgba(57,7,151,0.7)",
                    color: "white",
                    "&:hover": { bgcolor: colors.deepPurple },
                  }}
                  size="small"
                >
                  <CancelIcon fontSize="small" />
                </IconButton>
              </>
            ) : (
              <Stack
                direction="column"
                alignItems="center"
                spacing={1}
                sx={{ userSelect: "none" }}
              >
                <UploadFileIcon sx={{ fontSize: 48 }} />
                <Typography
                  variant="body2"
                  sx={{ maxWidth: 200, textAlign: "center" }}
                >
                  Drag & drop or click to upload a clear image of your volunteer ID
                </Typography>
              </Stack>
            )}
            <input
              type="file"
              accept="image/*"
              ref={fileInputRef}
              onChange={handleImageChange}
              style={{ display: "none" }}
              aria-label="Upload volunteer ID image"
            />
          </Box>
          {!!errors.volunteerIDImage && (
            <Typography variant="caption" color="error" sx={{ mt: 0.5 }}>
              {errors.volunteerIDImage}
            </Typography>
          )}
        </Box>

        {/* Display submission error if any */}
        {errors.submit && (
          <Typography 
            variant="body2" 
            color="error" 
            sx={{ 
              mt: 2, 
              p: 2, 
              bgcolor: "#ffebee", 
              borderRadius: 2,
              border: "1px solid #f44336"
            }}
          >
            {errors.submit}
          </Typography>
        )}

        {/* Submit Button & Success Animation */}
        <Box sx={{ textAlign: "center", pt: 1 }}>
          {success ? (
            <Box
              sx={{
                color: colors.calmNavy,
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                gap: 1,
                userSelect: "none",
              }}
              role="alert"
              aria-live="polite"
            >
              <CheckCircleOutlineIcon
                sx={{ fontSize: 48, color: colors.lightSkyBlue }}
              />
              <Typography
                variant="h6"
                sx={{ color: colors.deepPurple, fontWeight: 700 }}
              >
                Registration Successful!
              </Typography>
              <Typography>Your volunteer registration has been submitted.</Typography>
            </Box>
          ) : (
            <>
              <Button
                type="submit"
                variant="contained"
                disabled={isSubmitting}
                sx={{
                  bgcolor: `linear-gradient(45deg, ${colors.deepPurple}, ${colors.calmNavy})`,
                  px: 6,
                  py: 1.5,
                  fontWeight: 700,
                  letterSpacing: 0.5,
                  borderRadius: 3,
                  color: "white",
                  fontSize: 16,
                  boxShadow: `0 4px 15px ${colors.deepPurple}aa`,
                  transition: "all 0.3s ease",
                  "&:hover:not(:disabled)": {
                    bgcolor: `linear-gradient(45deg, ${colors.calmNavy}, ${colors.deepPurple})`,
                    boxShadow: `0 6px 20px ${colors.calmNavy}cc`,
                  },
                }}
                aria-label="Submit volunteer registration"
              >
                {isSubmitting ? <CircularProgress color="inherit" size={24} /> : "Register"}
              </Button>

              {/* === Add "Already have an account? Sign in" below the button === */}
              <Typography
                variant="body2"
                sx={{ mt: 2, color: colors.calmNavy }}
              >
                Already have an account?{" "}
                <Box
                  component="span"
                  sx={{
                    color: colors.deepPurple,
                    fontWeight: 700,
                    cursor: "pointer",
                    textDecoration: "underline",
                    "&:hover": { color: colors.lightSkyBlue },
                  }}
                  onClick={() => navigate("/SignIn")} // Adjust login route if needed
                  tabIndex={0}
                  role="link"
                  onKeyPress={(e) => {
                    if (e.key === "Enter" || e.key === " ") {
                      navigate("/SignIn");
                    }
                  }}
                >
                  Sign in
                </Box>
              </Typography>
            </>
          )}
        </Box>
      </Box>
    </Box>
  );
}
