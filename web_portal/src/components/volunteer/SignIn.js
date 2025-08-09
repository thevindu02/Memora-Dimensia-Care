// src/components/auth/SignIn.js
import React, { useState } from "react";
import {
  Box,
  Typography,
  TextField,
  InputAdornment,
  IconButton,
  Checkbox,
  FormControlLabel,
  Button,
  Divider,
  Stack,
  Link,
  Fade,
  useMediaQuery,
  useTheme,
  CircularProgress,
  Container,
} from "@mui/material";
import {
  MailOutline as MailIcon,
  LockOutlined as LockIcon,
  Visibility,
  VisibilityOff,
} from "@mui/icons-material";
import GoogleIcon from "@mui/icons-material/Google";
import { useNavigate } from "react-router-dom";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};

export default function SignIn() {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down("sm"));
  const navigate = useNavigate();

  // Form state
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordVisible, setPasswordVisible] = useState(false);
  const [rememberMe, setRememberMe] = useState(false);
  const [loading, setLoading] = useState(false);

  // Toggle password visibility
  const togglePasswordVisibility = () => {
    setPasswordVisible((visible) => !visible);
  };

  // Simulate sign-in loading state
  const handleSignIn = (e) => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      // Here you might handle result or reset form
    }, 2000);
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        bgcolor: `linear-gradient(135deg, ${colors.softLavender} 0%, ${colors.lightSkyBlue} 100%)`,
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        px: 2,
        pt: isMobile ? 4 : 0,
      }}
      component="main"
      aria-label="Sign in page"
    >
      <Fade in timeout={500}>
        <Container
          maxWidth="xs"
          sx={{
            bgcolor: "#fff",
            borderRadius: 3,
            p: { xs: 4, sm: 6 },
            boxShadow: "0 8px 24px rgba(57,7,151,0.15)",
            position: "relative",
            userSelect: "none",
            overflow: "visible",
            // Animation fade + slide-up keyframes:
            animation: "fadeSlideUp 0.6s ease forwards",
            "@keyframes fadeSlideUp": {
              "0%": { opacity: 0, transform: "translateY(20px)" },
              "100%": { opacity: 1, transform: "translateY(0)" },
            },
          }}
        >
          {/* Floating abstract shape at top */}
          <Box
            aria-hidden="true"
            sx={{
              position: "absolute",
              top: -60,
              left: "50%",
              transform: "translateX(-50%)",
              width: 120,
              height: 120,
              bgcolor: colors.softLavender,
              borderRadius: "50%",
              filter: "blur(26px)",
              opacity: 0.65,
              zIndex: -1,
            }}
          />

          {/* Optional small brand icon / logo */}
          <Box
            sx={{
              display: "flex",
              justifyContent: "center",
              mb: 3,
            }}
          >
            <LockIcon sx={{ fontSize: 40, color: colors.deepPurple }} aria-hidden="true" />
          </Box>

          {/* Header title and subtitle */}
          <Typography
            component="h1"
            variant="h5"
            sx={{
              fontWeight: 700,
              color: colors.deepPurple,
              textAlign: "center",
              mb: 0.75,
              userSelect: "text",
            }}
          >
            Welcome Back
          </Typography>
          <Typography
            component="p"
            variant="body2"
            sx={{
              color: colors.calmNavy,
              textAlign: "center",
              mb: 4,
              userSelect: "text",
            }}
          >
            Sign in to continue
          </Typography>

          {/* Form */}
          <Box component="form" onSubmit={handleSignIn} noValidate sx={{ mb: 2 }}>
            <TextField
              label="Email"
              type="email"
              placeholder="Enter your email"
              variant="outlined"
              required
              fullWidth
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <MailIcon sx={{ color: colors.deepPurple }} />
                  </InputAdornment>
                ),
              }}
              sx={{
                mb: 3,
                borderRadius: "12px",
                "& .MuiOutlinedInput-root": {
                  borderRadius: 12,
                },
              }}
              inputProps={{ "aria-label": "Email address" }}
            />

            <TextField
              label="Password"
              type={passwordVisible ? "text" : "password"}
              placeholder="Enter your password"
              variant="outlined"
              required
              fullWidth
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <LockIcon sx={{ color: colors.deepPurple }} />
                  </InputAdornment>
                ),
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      aria-label={passwordVisible ? "Hide password" : "Show password"}
                      onClick={togglePasswordVisibility}
                      edge="end"
                      sx={{ color: colors.deepPurple }}
                      size="large"
                      tabIndex={0}
                    >
                      {passwordVisible ? <VisibilityOff /> : <Visibility />}
                    </IconButton>
                  </InputAdornment>
                ),
              }}
              sx={{
                mb: 2,
                borderRadius: "12px",
                "& .MuiOutlinedInput-root": {
                  borderRadius: 12,
                },
              }}
              inputProps={{ "aria-label": "Password" }}
            />

            {/* Additional options row */}
            <Box
              sx={{
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
                mb: 3,
                userSelect: "none",
                fontSize: 14,
              }}
            >
              <FormControlLabel
                control={
                  <Checkbox
                    checked={rememberMe}
                    onChange={(e) => setRememberMe(e.target.checked)}
                    sx={{
                      color: colors.deepPurple,
                      "&.Mui-checked": {
                        color: colors.deepPurple,
                      },
                    }}
                    inputProps={{ "aria-label": "Remember me" }}
                  />
                }
                label="Remember Me"
                sx={{ userSelect: "none" }}
              />
              <Link
                href="/ForgetPassword"
                underline="hover"
                sx={{
                  color: colors.deepPurple,
                  cursor: "pointer",
                  fontWeight: 600,
                  "&:hover": { color: colors.lightSkyBlue },
                }}
              >
                Forgot Password?
              </Link>
            </Box>

            {/* Sign in button */}
            <Button
              type="submit"
              fullWidth
              variant="contained"
              disabled={loading}
              onClick={() => navigate("/VolunteerDashboard")} // Adjust route if needed
              sx={{
                borderRadius: 12,
                bgcolor: colors.lightSkyBlue,
                color: colors.calmNavy,
                fontWeight: 700,
                py: 1.75,
                boxShadow: "0 4px 12px rgba(160,196,253,0.5)",
                transition: "all 0.3s ease",
                "&:hover": {
                  bgcolor: colors.calmNavy,
                  color: "#fff",
                  boxShadow: "0 6px 20px rgba(43,63,153,0.7)",
                },
                "&:active": {
                  transform: "scale(0.98)",
                },
                userSelect: "none",
              }}
              aria-label="Sign in"
            >
              {loading ? <CircularProgress size={24} sx={{ color: colors.calmNavy }} /> : "Sign In"}
            </Button>
          </Box>

          {/* Divider */}
          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              mt: 1,
              mb: 3,
              px: 0,
            }}
          >
            <Divider sx={{ flexGrow: 1, borderColor: colors.softLavender }} />
            <Typography
              sx={{
                mx: 2,
                color: colors.deepPurple,
                fontWeight: 600,
                userSelect: "none",
                fontSize: 14,
              }}
            >
              OR
            </Typography>
            <Divider sx={{ flexGrow: 1, borderColor: colors.softLavender }} />
          </Box>

          {/* Social login buttons */}
          <Box sx={{ display: "flex", flexDirection: "column", gap: 2, mt: 3 }}>
            <Button
              variant="outlined"
              startIcon={<GoogleIcon />}
              sx={{
                borderColor: "#C3B1E1",
                color: "#390797",
                fontWeight: 600,
                textTransform: "none",
                "&:hover": { bgcolor: "#C3B1E1", borderColor: "#390797" },
              }}
              fullWidth
              // onClick={handleGoogleSignIn} // Add handler if needed
            >
              Sign in with Google
            </Button>
            {/* <Button
              variant="outlined"
              startIcon={<FacebookIcon />}
              sx={{
                borderColor: "#A0C4FD",
                color: "#2B3F99",
                fontWeight: 600,
                textTransform: "none",
                "&:hover": { bgcolor: "#A0C4FD", borderColor: "#2B3F99" },
              }}
              fullWidth
              // onClick={handleFacebookSignIn} // Add handler if needed
            >
              Sign in with Facebook
            </Button> */}
          </Box>

          {/* Footer text link */}
          <Typography variant="body2" align="center" sx={{ color: colors.calmNavy }}>
            Don’t have an account?{" "}
            <Link
              href="/VolunteerSignup"
              underline="hover"
              sx={{
                color: colors.deepPurple,
                fontWeight: 700,
                cursor: "pointer",
                "&:hover": { color: colors.lightSkyBlue },
              }}
            >
              Sign Up
            </Link>
          </Typography>
        </Container>
      </Fade>
    </Box>
  );
}
