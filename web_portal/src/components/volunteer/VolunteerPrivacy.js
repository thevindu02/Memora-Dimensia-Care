// src/components/volunteers/VolunteerPrivacy.js
import React from "react";
import {
  Box,
  Typography,
  IconButton,
  Container,
  Divider,
  Paper,
} from "@mui/material";
import { styled, alpha } from "@mui/material/styles";
import ArrowBackIosNewIcon from "@mui/icons-material/ArrowBackIosNew";
import DeleteOutlineOutlinedIcon from "@mui/icons-material/DeleteOutlineOutlined";
import Footer from "../home/Footer"; // Import Footer

// Colors per your palette
const COLORS = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  lightGray: "#E0E0E0",
  lightRedFade: "#FFEBEF",
  brightRed: "#D32F2F",
  offWhite: "#FAFAFA",
};

// Styled components
const GradientBackground = styled(Box)(({ theme }) => ({
  minHeight: "100vh",
  background: `linear-gradient(135deg, ${COLORS.softLavender} 0%, ${COLORS.lightSkyBlue} 100%)`,
  display: "flex",
  flexDirection: "column",
  alignItems: "center",
  justifyContent: "flex-start",
  paddingTop: theme.spacing(6),
  paddingBottom: 0,
}));

const StyledContainer = styled(Container)(({ theme }) => ({
  maxWidth: 700,
  backgroundColor: "#fff",
  borderRadius: 18,
  boxShadow: `0 8px 32px ${alpha(COLORS.deepPurple, 0.12)}`,
  padding: theme.spacing(5, 6),
  fontFamily: "'Roboto', 'Helvetica', 'Arial', sans-serif",
  userSelect: "text",
  marginBottom: theme.spacing(6),
  marginTop: theme.spacing(2),
  display: "flex",
  flexDirection: "column",
  alignItems: "center",
  minHeight: 500,
  [theme.breakpoints.down("sm")]: {
    padding: theme.spacing(3, 1.5),
    maxWidth: "98vw",
  },
}));

const DeleteCard = styled(Paper)(({ theme }) => ({
  marginTop: theme.spacing(5),
  cursor: "pointer",
  padding: theme.spacing(2.5, 4),
  borderRadius: 14,
  display: "flex",
  alignItems: "center",
  gap: theme.spacing(2),
  backgroundColor: "#fff",
  boxShadow: `0 4px 12px ${alpha(COLORS.brightRed, 0.1)}`,
  transition: "background-color 0.3s ease, box-shadow 0.3s",
  "&:hover, &:focus-visible": {
    backgroundColor: COLORS.lightRedFade,
    outline: `2px solid ${COLORS.brightRed}`,
    boxShadow: `0 8px 24px ${alpha(COLORS.brightRed, 0.18)}`,
  },
}));

export default function VolunteerPrivacy() {
  // Keyboard accessible back navigation
  const handleBack = () => {
    window.history.back();
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        background: `linear-gradient(135deg, ${COLORS.softLavender} 0%, ${COLORS.lightSkyBlue} 100%)`,
      }}
    >
      {/* Back Button */}
      <Box sx={{ pt: 4, pl: 4 }}>
        <IconButton
          edge="start"
          color="inherit"
          aria-label="Go back"
          onClick={handleBack}
          size="large"
          sx={{
            background: "#fff",
            boxShadow: `0 2px 8px ${COLORS.softLavender}55`,
            color: COLORS.deepPurple,
            "&:hover": { background: COLORS.softLavender },
          }}
        >
          <ArrowBackIosNewIcon />
        </IconButton>
      </Box>

      {/* Main Content */}
      <GradientBackground component="section" aria-labelledby="privacy-settings-title" sx={{ flex: 1 }}>
        <StyledContainer>
          <Box
            component="img"
            src="https://cdn-icons-png.flaticon.com/512/565/565547.png"
            alt=""
            aria-hidden="true"
            loading="lazy"
            sx={{
              width: 80,
              height: 80,
              mb: 3,
              mx: "auto",
              display: { xs: "none", sm: "block" },
              opacity: 0.7,
            }}
          />

          <Typography
            variant="h4"
            sx={{
              fontWeight: 800,
              color: COLORS.deepPurple,
              mb: 3,
              textAlign: "center",
              letterSpacing: 1,
            }}
          >
            Privacy & Data Management
          </Typography>
          <Typography sx={{ color: COLORS.calmNavy, mb: 2, fontSize: 18, textAlign: "center" }}>
            <b>Data Usage:</b> Your personal information is securely stored and used only for the purpose of providing volunteer services within Memora. We do not share your data with third parties without your consent.
          </Typography>
          <Typography sx={{ color: COLORS.calmNavy, mb: 2, fontSize: 18, textAlign: "center" }}>
            <b>Profile Visibility:</b> Only your name and profile image are visible to other users. Contact details and sensitive information remain private.
          </Typography>
          <Typography sx={{ color: COLORS.calmNavy, mb: 2, fontSize: 18, textAlign: "center" }}>
            <b>Session Data:</b> Details of your volunteer sessions and contributions are recorded for your dashboard and recognition, but are not publicly shared.
          </Typography>
          <Typography sx={{ color: COLORS.calmNavy, mb: 2, fontSize: 18, textAlign: "center" }}>
            <b>Account Control:</b> You can update or delete your account at any time. Deleting your account will permanently remove all your data from our system.
          </Typography>

          <Divider
            sx={{
              bgcolor: COLORS.lightGray,
              my: 4,
              borderBottomWidth: "2px",
              width: "100%",
            }}
            aria-hidden="true"
          />

          <DeleteCard
            tabIndex={0}
            role="button"
            aria-label="Delete account, permanently delete your account and all data"
            onClick={() => alert("Delete Account clicked (no backend logic)")}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                alert("Delete Account clicked (no backend logic)");
              }
            }}
            sx={{
              width: "100%",
              maxWidth: 400,
              mx: "auto",
              mt: 2,
              justifyContent: "center",
            }}
          >
            <DeleteOutlineOutlinedIcon
              sx={{ color: COLORS.brightRed, fontSize: 36, flexShrink: 0 }}
              aria-hidden="true"
            />
            <Box>
              <Typography
                variant="body1"
                sx={{ fontWeight: "bold", color: COLORS.brightRed, userSelect: "text", fontSize: 18 }}
              >
                Delete Account
              </Typography>
              <Typography
                variant="body2"
                sx={{ color: COLORS.brightRed, userSelect: "text", fontSize: 15 }}
              >
                Permanently delete your account and all data.
              </Typography>
            </Box>
          </DeleteCard>
        </StyledContainer>
      </GradientBackground>

      {/* Footer */}
      <Box sx={{ width: "100%", bgcolor: COLORS.calmNavy, mt: "auto", pt: 4, pb: 2 }}>
        <Footer />
      </Box>
    </Box>
  );
}
