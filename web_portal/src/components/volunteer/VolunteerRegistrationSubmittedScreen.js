// src/components/volunteers/VolunteerRegistrationSubmittedScreen.js
import React from "react";
import { Box, Typography, IconButton, Fade } from "@mui/material";
import ArrowBackIosNewIcon from "@mui/icons-material/ArrowBackIosNew";
import HourglassTopIcon from "@mui/icons-material/HourglassTop";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  bodyTextGray: "#555555",
  white: "#FFFFFF",
};

export default function VolunteerRegistrationSubmittedScreen({ onBack }) {
  const [visible, setVisible] = React.useState(false);

  React.useEffect(() => {
    setVisible(true);
  }, []);

  return (
    <Fade in={visible} timeout={600}>
      <Box
        sx={{
          minHeight: "100vh",
          bgcolor: `linear-gradient(135deg, ${colors.lightSkyBlue}, ${colors.softLavender})`,
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          p: 2,
          fontFamily: '"Poppins", "Roboto", sans-serif',
        }}
      >
        <Box
          sx={{
            bgcolor: colors.white,
            maxWidth: 460,
            width: "100%",
            borderRadius: 4,
            boxShadow: "0 12px 36px rgba(57,7,151,0.12)",
            p: { xs: 3, sm: 5 },
            display: "flex",
            flexDirection: "column",
            gap: 3,
            position: "relative",
            overflow: "hidden",
          }}
          role="region"
          aria-label="Registration Submitted Confirmation"
        >
          {/* Back button with hover */}
          <IconButton
            onClick={() => (onBack ? onBack() : alert("Back clicked (mock)"))}
            aria-label="Go back"
            sx={{
              position: "absolute",
              top: 16,
              left: 16,
              color: colors.calmNavy,
              transition: "color 0.3s ease",
              "&:hover": { color: colors.deepPurple, bgcolor: colors.softLavender + "88" },
            }}
          >
            <ArrowBackIosNewIcon fontSize="medium" />
          </IconButton>

          {/* Spacer so content doesn't overlap back button */}
          <Box sx={{ height: 32 }} />

          {/* Header */}
          <Box sx={{ display: "flex", alignItems: "center", gap: 1.5 }}>
            <Typography
              variant="h5"
              component="h1"
              sx={{
                color: colors.deepPurple,
                fontWeight: 700,
                userSelect: "none",
                flexGrow: 1,
              }}
              tabIndex={-1}
            >
              Registration Submitted
            </Typography>
          </Box>

          {/* Message */}
          <Typography
            variant="body1"
            sx={{
              color: colors.bodyTextGray,
              fontSize: { xs: 14, sm: 16 },
              lineHeight: 1.5,
              textAlign: { xs: "center", sm: "left" },
            }}
          >
            Your registration is under review. You will receive a notification once your status is updated.
          </Typography>

          {/* Status section */}
          <Box>
            <Typography
              variant="subtitle1"
              sx={{
                fontWeight: 600,
                color: colors.calmNavy,
                mb: 1,
              }}
            >
              Status
            </Typography>

            <Box
              sx={{
                display: "inline-flex",
                alignItems: "center",
                gap: 0.5,
                bgcolor: colors.softLavender,
                color: colors.calmNavy,
                px: 2,
                py: 0.5,
                borderRadius: 10,
                fontWeight: 600,
                fontSize: 14,
                userSelect: "none",
                minWidth: 90,
                justifyContent: "center",
                boxShadow: `0 1px 5px ${colors.softLavender}aa`,
              }}
              aria-label="Pending status"
              role="status"
            >
              <HourglassTopIcon fontSize="small" aria-hidden="true" />
              Pending
            </Box>
          </Box>

          {/* Optional illustration */}
          <Box
            component="img"
            src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=600&q=80"
            alt=""
            aria-hidden="true"
            sx={{
              mt: 4,
              width: "100%",
              borderRadius: 3,
              opacity: 0.12,
              userSelect: "none",
              pointerEvents: "none",
              objectFit: "contain",
              maxHeight: 180,
              mx: "auto",
              display: { xs: "none", sm: "block" },
            }}
          />
        </Box>
      </Box>
    </Fade>
  );
}
