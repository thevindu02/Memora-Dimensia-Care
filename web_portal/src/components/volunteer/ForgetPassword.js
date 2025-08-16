// src/components/volunteers/ForgetPassword.js
import React, { useState } from "react";
import {
  Box,
  Typography,
  TextField,
  Button,
  IconButton,
  Link,
  CircularProgress,
  Fade,
} from "@mui/material";
import { useNavigate } from "react-router-dom";

import ArrowBackIosNewIcon from "@mui/icons-material/ArrowBackIosNew";
import LockResetIcon from "@mui/icons-material/LockReset";
import MarkEmailReadIcon from "@mui/icons-material/MarkEmailRead";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
};

export default function ForgetPassword({ onBack }) {
  const [email, setEmail] = useState("");
  const [isSending, setIsSending] = useState(false);
  const [sent, setSent] = useState(false);
  const navigate = useNavigate();

  const handleBackClick = () => {
    if (onBack) onBack();
    else alert("Back to login (mock)");
  };

  const handleSendResetLink = () => {
    if (!email.trim() || !validateEmail(email.trim())) {
      alert("Please enter a valid email address.");
      return;
    }
    setIsSending(true);
    setTimeout(() => {
      setIsSending(false);
      setSent(true);
    }, 2000);
  };

  const handleOpenEmailApp = () => {
    alert("Open Email App (mock)");
  };

  const handleTryDifferentEmail = () => {
    setSent(false);
    setEmail("");
  };

  // Basic email format validation
  function validateEmail(email) {
    // Simple RFC2822-ish pattern
    // eslint-disable-next-line no-useless-escape
    const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@(([^<>()[\]\\.,;:\s@"]+\.)+[^<>()[\]\\.,;:\s@"]{2,})$/i;
    return re.test(String(email).toLowerCase());
  }

  // Decorative illustrative image URL (friendly, volunteering theme)
  const illustrationUrl =
    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80";

  return (
    <Box
      sx={{
        minHeight: "100vh",
        bgcolor: `linear-gradient(135deg, ${colors.softLavender}, ${colors.lightSkyBlue})`,
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        p: 3,
        fontFamily: `"Poppins", "Roboto", "Arial", sans-serif`,
      }}
      role="main"
    >
      <Box
        sx={{
          maxWidth: 400,
          width: "100%",
          bgcolor: colors.white,
          borderRadius: 3,
          boxShadow: "0 10px 25px rgba(57,7,151,0.12)",
          p: 4,
          textAlign: "center",
          position: "relative",
        }}
      >
        {/* Header: Back Button */}
        <IconButton
          onClick={() => navigate("/SignIn")}
          aria-label="Back to login"
          sx={{
            position: "absolute",
            top: 16,
            left: 16,
            color: colors.deepPurple,
            "&:hover": {
              bgcolor: colors.softLavender,
            },
          }}
        >
          <ArrowBackIosNewIcon />
        </IconButton>

        {/* Circular Icon Area */}
        <Box
          sx={{
            mx: "auto",
            width: 80,
            height: 80,
            bgcolor: colors.softLavender,
            borderRadius: "50%",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            mb: 3,
            boxShadow: `0 0 12px ${colors.calmNavy}88`,
            color: colors.calmNavy,
          }}
          aria-hidden="true"
        >
          {!sent ? (
            <LockResetIcon
              sx={{ fontSize: 44 }}
              aria-label="Reset Password Icon"
              role="img"
            />
          ) : (
            <MarkEmailReadIcon
              sx={{ fontSize: 44 }}
              aria-label="Email Sent Icon"
              role="img"
            />
          )}
        </Box>

        {/* Title */}
        <Typography
          component="h1"
          variant="h5"
          sx={{
            fontWeight: 700,
            color: colors.deepPurple,
            mb: 1,
          }}
        >
          {!sent ? "Reset Password" : "Check Your Email"}
        </Typography>

        {/* Subtitle / Description */}
        <Typography
          variant="body2"
          sx={{
            color: colors.calmNavy,
            fontSize: 14,
            mb: sent ? 4 : 3,
          }}
          role="region"
          aria-live="polite"
        >
          {!sent
            ? "Enter your registered email address below to receive a password reset link."
            : "We've sent a reset link to your email. Please check your inbox to continue."}
        </Typography>

        {/* Initial State - Email Input Form */}
        {!sent && (
          <Box
            component="form"
            onSubmit={(e) => {
              e.preventDefault();
              handleSendResetLink();
            }}
            noValidate
          >
            <TextField
              id="email"
              name="email"
              type="email"
              label="Email Address"
              variant="outlined"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              fullWidth
              placeholder="example@domain.com"
              InputProps={{
                sx: {
                  borderRadius: 3,
                },
              }}
              sx={{
                mb: 3,
                "& .MuiOutlinedInput-root": {
                  boxShadow:
                    "0 2px 8px rgba(57,7,151,0.1)",
                },
              }}
              aria-describedby="email-helper-text"
              autoComplete="email"
            />
            <Button
              type="submit"
              variant="contained"
              fullWidth
              disabled={isSending}
              sx={{
                borderRadius: 3,
                py: 1.6,
                fontWeight: 700,
                fontSize: 16,
                background: `linear-gradient(45deg, ${colors.softLavender}, ${colors.lightSkyBlue})`,
                color: colors.calmNavy,
                boxShadow: `0 6px 15px ${colors.calmNavy}88`,
                transition: "background-color 0.3s ease",
                "&:hover": {
                  background: `linear-gradient(45deg, ${colors.lightSkyBlue}, ${colors.calmNavy})`,
                  color: colors.white,
                },
              }}
              aria-label="Send password reset link"
            >
              {isSending ? (
                <CircularProgress size={24} color="inherit" />
              ) : (
                "Send Reset Link"
              )}
            </Button>
          </Box>
        )}

        {/* Success State */}
        {sent && (
          <Fade in={sent}>
            <Box
              sx={{
                display: "flex",
                flexDirection: { xs: "column", sm: "row" },
                gap: 2,
                justifyContent: "center",
              }}
            >
              <Button
                variant="contained"
                onClick={handleOpenEmailApp}
                sx={{
                  flexGrow: 1,
                  borderRadius: 3,
                  py: 1.5,
                  fontWeight: 700,
                  fontSize: 16,
                  background: `linear-gradient(45deg, ${colors.lightSkyBlue}, ${colors.calmNavy})`,
                  color: colors.white,
                  boxShadow: `0 6px 15px ${colors.calmNavy}88`,
                  "&:hover": {
                    background: `linear-gradient(45deg, ${colors.calmNavy}, ${colors.lightSkyBlue})`,
                  },
                  minWidth: 140,
                }}
                aria-label="Open email application"
              >
                Open Email App
              </Button>

              <Button
                variant="outlined"
                onClick={handleTryDifferentEmail}
                sx={{
                  flexGrow: 1,
                  borderRadius: 3,
                  py: 1.5,
                  fontWeight: 700,
                  fontSize: 16,
                  borderColor: colors.deepPurple,
                  color: colors.deepPurple,
                  "&:hover": {
                    bgcolor: colors.softLavender,
                    borderColor: colors.calmNavy,
                  },
                  minWidth: 140,
                }}
                aria-label="Try different email"
              >
                Try Different Email
              </Button>
            </Box>
          </Fade>
        )}

        {/* Footer Text Link */}
        <Box sx={{ mt: 4 }}>
          <Typography
            variant="body2"
            sx={{
              color: colors.deepPurple,
            }}
          >
            Remember your password?{" "}
            <Link
             onClick={() => navigate("/SignIn")}
              sx={{
                cursor: "pointer",
                fontWeight: 700,
                textDecoration: "underline",
                "&:hover": { color: colors.calmNavy },
              }}
              tabIndex={0}
              aria-label="Back to login"
            >
              Back to Login
            </Link>
          </Typography>
        </Box>
      </Box>
    </Box>
  );
}
