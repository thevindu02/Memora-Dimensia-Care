// src/components/volunteers/VolunteerRegistrationCompletedScreen.js
import React from "react";
import { Box, Typography, Button, Fade } from "@mui/material";
import VerifiedUserIcon from "@mui/icons-material/VerifiedUser";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  successGreen: "#4CAF50",
  white: "#FFFFFF",
};

export default function VolunteerRegistrationCompletedScreen() {
  const [visible, setVisible] = React.useState(false);

  React.useEffect(() => {
    setVisible(true);
  }, []);

  const handleDashboardClick = () => {
    alert("Navigate to Dashboard (mock)");
  };

  return (
    <Fade in={visible}>
      <Box
        sx={{
          minHeight: "100vh",
          bgcolor: colors.softLavender,
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          p: 3,
        }}
      >
        <Box
          sx={{
            maxWidth: 480,
            width: "100%",
            bgcolor: colors.white,
            borderRadius: 4,
            boxShadow: "0 16px 50px rgba(57,7,151,0.15)",
            p: { xs: 4, sm: 6 },
            display: "flex",
            flexDirection: { xs: "column", sm: "row" },
            alignItems: { xs: "center", sm: "flex-start" },
            gap: 3,
            position: "relative",
            overflow: "hidden",
          }}
        >
          {/* Optional subtle background illustration */}
          <Box
            component="img"
            src="https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80"
            alt=""
            aria-hidden="true"
            sx={{
              position: "absolute",
              top: 0,
              right: 0,
              height: "100%",
              opacity: 0.07,
              borderTopRightRadius: 16,
              borderBottomRightRadius: 16,
              userSelect: "none",
              pointerEvents: "none",
              display: { xs: "none", sm: "block" },
              objectFit: "cover",
              width: "50%",
              zIndex: 0,
            }}
          />

          {/* Content: icon & title */}
          <Box
            sx={{
              flexShrink: 0,
              display: "flex",
              alignItems: "center",
              gap: 1.5,
              color: colors.successGreen,
              cursor: "default",
              transition: "transform 0.3s ease",
              "&:hover": {
                transform: "scale(1.15)",
              },
              zIndex: 1,
            }}
          >
            <VerifiedUserIcon sx={{ fontSize: 40 }} aria-hidden="true" />
            <Typography
              variant="h4"
              component="h1"
              sx={{
                fontWeight: 700,
                color: colors.deepPurple,
                userSelect: "none",
              }}
            >
              Registration Complete
            </Typography>
          </Box>

          {/* Message & button */}
          <Box
            sx={{
              flex: 1,
              color: colors.calmNavy,
              userSelect: "text",
              textAlign: { xs: "center", sm: "left" },
              zIndex: 1,
            }}
          >
            <Typography
              variant="body1"
              sx={{ fontSize: 18, mb: 4, lineHeight: 1.5 }}
              component="p"
            >
              Thank you for registering as a volunteer. Your ID image has been successfully uploaded.
            </Typography>

            <Button
              onClick={handleDashboardClick}
              variant="contained"
              sx={{
                background: `linear-gradient(45deg, ${colors.lightSkyBlue}, ${colors.calmNavy})`,
                color: colors.white,
                px: 6,
                py: 1.5,
                fontWeight: 700,
                fontSize: 16,
                borderRadius: 6,
                boxShadow: `0 6px 16px ${colors.calmNavy}bb`,
                transition: "all 0.4s ease",
                minWidth: 200,
                "&:hover": {
                  background: `linear-gradient(45deg, ${colors.calmNavy}, ${colors.lightSkyBlue})`,
                  boxShadow: `0 10px 24px ${colors.lightSkyBlue}dd`,
                },
              }}
              aria-label="Go to Dashboard"
            >
              Go to Dashboard
            </Button>
          </Box>
        </Box>
      </Box>
    </Fade>
  );
}
