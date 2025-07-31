// src/components/volunteers/ScheduleSession.js
import React, { useState } from "react";
import {
  Box,
  Typography,
  Container,
  TextField,
  Button,
  InputAdornment,
  IconButton,
  Tooltip,
  Paper,
} from "@mui/material";

import CalendarTodayIcon from "@mui/icons-material/CalendarToday";
import AccessTimeIcon from "@mui/icons-material/AccessTime";
import SubjectIcon from "@mui/icons-material/Subject";
import DescriptionIcon from "@mui/icons-material/Description";
import LinkIcon from "@mui/icons-material/Link";
import InfoOutlinedIcon from "@mui/icons-material/InfoOutlined";
import { LocalizationProvider, DatePicker, TimePicker } from "@mui/x-date-pickers";
import { AdapterDateFns } from "@mui/x-date-pickers/AdapterDateFns";

// Memora color palette
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
  backgroundLight: "#F7F8FA",
};

// Tooltip helper component for info icons
const InfoTooltip = ({ title }) => (
  <Tooltip title={title} arrow>
    <InfoOutlinedIcon
      sx={{ color: colors.deepPurple, ml: 0.5, verticalAlign: "middle", fontSize: 18, cursor: "help" }}
      aria-label={title}
      tabIndex={0}
    />
  </Tooltip>
);

export default function ScheduleSession() {
  const [date, setDate] = useState(null);
  const [time, setTime] = useState(null);
  const [topic, setTopic] = useState("");
  const [description, setDescription] = useState("");
  const [meetingLink, setMeetingLink] = useState("");

  // Handler for Schedule button
  const handleSchedule = () => {
    alert("Session scheduled (dummy)!");
  };

  return (
    <Box
      sx={{
        bgcolor: colors.backgroundLight,
        minHeight: "100vh",
        py: 4,
        px: 2,
        fontFamily: "Poppins, Lato, Nunito, Arial, sans-serif",
        color: colors.calmNavy,
      }}
    >
      <Container maxWidth="sm">
        {/* Illustration / Banner */}
        <Box
          sx={{
            mb: 4,
            height: 140,
            borderRadius: 3,
            backgroundImage:
              "url('https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?auto=format&fit=crop&w=800&q=80')",
            backgroundSize: "cover",
            backgroundPosition: "center",
            boxShadow: `0 8px 24px ${colors.softLavender}aa`,
            position: "relative",
          }}
          aria-hidden="true"
          role="img"
        >
          <Box
            sx={{
              position: "absolute",
              inset: 0,
              bgcolor: "rgba(57, 7, 151, 0.35)", // deep purple overlay for warmth
              borderRadius: 3,
            }}
          />
        </Box>

        {/* Title with emoji */}
        <Typography
          variant="h5"
          sx={{
            fontWeight: 700,
            mb: 4,
            display: "flex",
            alignItems: "center",
            color: colors.deepPurple,
          }}
        >
          🗓️ Schedule a Session
        </Typography>

        {/* Date Picker Card */}
        <Paper
          elevation={3}
          sx={{
            p: 2,
            mb: 3,
            borderRadius: 3,
            boxShadow: `0 6px 18px ${colors.softLavender}88`,
            backgroundColor: colors.white,
          }}
          component="section"
          aria-labelledby="date-picker-label"
        >
          <Typography
            id="date-picker-label"
            variant="subtitle1"
            sx={{ fontWeight: 600, mb: 1, color: colors.calmNavy }}
          >
            Select Date
            <InfoTooltip title="Choose the date for the session." />
          </Typography>
          <LocalizationProvider dateAdapter={AdapterDateFns}>
            <DatePicker
              value={date}
              onChange={(newDate) => setDate(newDate)}
              slotProps={{
                textField: {
                  fullWidth: true,
                  variant: "outlined",
                  placeholder: "Select date...",
                  InputProps: {
                    startAdornment: (
                      <InputAdornment position="start">
                        <CalendarTodayIcon sx={{ color: colors.deepPurple }} />
                      </InputAdornment>
                    ),
                    sx: { color: colors.calmNavy },
                  },
                },
              }}
            />
          </LocalizationProvider>
        </Paper>

        {/* Time Picker Card */}
        <Paper
          elevation={3}
          sx={{
            p: 2,
            mb: 3,
            borderRadius: 3,
            boxShadow: `0 6px 18px ${colors.softLavender}88`,
            backgroundColor: colors.white,
          }}
          component="section"
          aria-labelledby="time-picker-label"
        >
          <Typography
            id="time-picker-label"
            variant="subtitle1"
            sx={{ fontWeight: 600, mb: 1, color: colors.calmNavy }}
          >
            Select Time
            <InfoTooltip title="Choose the time for the session." />
          </Typography>
          <LocalizationProvider dateAdapter={AdapterDateFns}>
            <TimePicker
              value={time}
              onChange={(newTime) => setTime(newTime)}
              ampm
              slotProps={{
                textField: {
                  fullWidth: true,
                  variant: "outlined",
                  placeholder: "Select time...",
                  InputProps: {
                    startAdornment: (
                      <InputAdornment position="start">
                        <AccessTimeIcon sx={{ color: colors.deepPurple }} />
                      </InputAdornment>
                    ),
                    sx: { color: colors.calmNavy },
                  },
                },
              }}
            />
          </LocalizationProvider>
        </Paper>

        {/* Topic Input Card */}
        <Paper
          elevation={3}
          sx={{
            p: 2,
            mb: 3,
            borderRadius: 3,
            boxShadow: `0 6px 18px ${colors.softLavender}88`,
            backgroundColor: colors.white,
          }}
          component="section"
          aria-labelledby="topic-input-label"
        >
          <Typography
            id="topic-input-label"
            variant="subtitle1"
            sx={{ fontWeight: 600, mb: 1, color: colors.calmNavy }}
          >
            Session Topic
            <InfoTooltip title="Enter the main topic or title of the session." />
          </Typography>
          <TextField
            variant="outlined"
            fullWidth
            placeholder="Enter session topic"
            value={topic}
            onChange={(e) => setTopic(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <SubjectIcon sx={{ color: colors.deepPurple }} />
                </InputAdornment>
              ),
              sx: { color: colors.calmNavy },
            }}
          />
        </Paper>

        {/* Description Input Card */}
        <Paper
          elevation={3}
          sx={{
            p: 2,
            mb: 3,
            borderRadius: 3,
            boxShadow: `0 6px 18px ${colors.softLavender}88`,
            backgroundColor: colors.white,
          }}
          component="section"
          aria-labelledby="description-input-label"
        >
          <Typography
            id="description-input-label"
            variant="subtitle1"
            sx={{ fontWeight: 600, mb: 1, color: colors.calmNavy }}
          >
            Description
            <InfoTooltip title="Provide a brief description of what will be covered." />
          </Typography>
          <TextField
            variant="outlined"
            fullWidth
            multiline
            minRows={4}
            placeholder="Enter description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <DescriptionIcon sx={{ color: colors.deepPurple }} />
                </InputAdornment>
              ),
              sx: { color: colors.calmNavy },
            }}
          />
        </Paper>

        {/* Meeting Link Input Card */}
        <Paper
          elevation={3}
          sx={{
            p: 2,
            mb: 5,
            borderRadius: 3,
            boxShadow: `0 6px 18px ${colors.softLavender}88`,
            backgroundColor: colors.white,
          }}
          component="section"
          aria-labelledby="meeting-link-input-label"
        >
          <Typography
            id="meeting-link-input-label"
            variant="subtitle1"
            sx={{ fontWeight: 600, mb: 1, color: colors.calmNavy }}
          >
            Meeting Link
            <InfoTooltip title="Link to the meeting (Zoom, Teams, etc.)" />
          </Typography>
          <TextField
            variant="outlined"
            fullWidth
            placeholder="Enter meeting URL"
            value={meetingLink}
            onChange={(e) => setMeetingLink(e.target.value)}
            InputProps={{
              startAdornment: (
                <InputAdornment position="start">
                  <LinkIcon sx={{ color: colors.deepPurple }} />
                </InputAdornment>
              ),
              sx: { color: colors.calmNavy },
            }}
            type="url"
          />
        </Paper>

        {/* Schedule Button */}
        <Button
          fullWidth
          variant="contained"
          onClick={handleSchedule}
          sx={{
            bgcolor: colors.lightSkyBlue,
            color: colors.white,
            fontWeight: "bold",
            borderRadius: 4,
            py: 1.75,
            boxShadow: `0 8px 15px ${colors.lightSkyBlue}80`,
            textTransform: "none",
            fontSize: 16,
            "&:hover": {
              bgcolor: colors.deepPurple,
              boxShadow: `0 12px 24px ${colors.deepPurple}cc`,
            },
            transition: "all 0.3s ease",
          }}
          aria-label="Schedule session"
        >
          Schedule
        </Button>
      </Container>
    </Box>
  );
}
