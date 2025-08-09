// src/components/volunteers/VolunteerSettings.js
import React, { useState } from "react";
import {
  Box,
  Typography,
  Container,
  Paper,
  FormControl,
  Select,
  MenuItem,
  Switch,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  useMediaQuery,
} from "@mui/material";
import NotificationsActiveIcon from "@mui/icons-material/NotificationsActive";
import LanguageIcon from "@mui/icons-material/Language";
import SecurityIcon from "@mui/icons-material/Security";
import HelpOutlineIcon from "@mui/icons-material/HelpOutline";
import LogoutIcon from "@mui/icons-material/Logout";
import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";
import { useTheme } from "@mui/material/styles";
import { useNavigate } from "react-router-dom";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
  backgroundLight: "#F8F9FB",
};

function ProfileHeader() {
  return (
    <Box
      sx={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        mb: 4,
        pt: 2,
        pb: 3,
        bgcolor: colors.softLavender,
        borderRadius: "16px",
        boxShadow: `0 8px 16px ${colors.softLavender}aa`,
        userSelect: "none",
        position: "relative",
      }}
    >
      <Box
        sx={{
        //   mt: 1.5,
        //   width: 96,
        //   height: 96,
        //   position: "absolute",
        //   bottom: 12,
        //   borderRadius: "50%",
        //   border: `4px solid ${colors.lightSkyBlue}`,
        //   boxSizing: "content-box",
        //   pointerEvents: "none",
        //   animation: "progressRing 1.5s ease forwards",
        }}
      />
      <Typography
        variant="h6"
        sx={{ mt: 3, fontWeight: 700, color: colors.calmNavy, userSelect: "none" }}
      >
        Amanda Nethmini
      </Typography>
      <Typography
        variant="body2"
        sx={{ color: colors.deepPurple, fontWeight: 600, userSelect: "none" }}
      >
        Profile completeness: 80%
      </Typography>

      <style>{`
        @keyframes progressRing {
          0% {
            box-shadow: 0 0 0 0 ${colors.lightSkyBlue}aa;
          }
          100% {
            box-shadow: 0 0 12px 8px ${colors.lightSkyBlue}88;
          }
        }
      `}</style>
    </Box>
  );
}

function SettingItem({ icon, title, subtitle, children, onClick, hoverable = false }) {
  return (
    <Paper
      elevation={hoverable ? 6 : 2}
      onClick={onClick}
      sx={{
        display: "flex",
        alignItems: "center",
        p: 2,
        mb: 3,
        borderRadius: 3,
        cursor: onClick ? "pointer" : "default",
        boxShadow: hoverable ? `0 6px 20px ${colors.softLavender}bb` : `0 3px 8px ${colors.softLavender}88`,
        transition: "all 0.3s ease",
        "&:hover": hoverable
          ? {
              boxShadow: `0 10px 30px ${colors.deepPurple}cc`,
              transform: "translateY(-3px)",
            }
          : {},
        userSelect: "none",
        flexWrap: "wrap",
      }}
    >
      <Box sx={{ color: colors.deepPurple, mr: 2, fontSize: 28, flexShrink: 0 }}>{icon}</Box>
      <Box sx={{ flex: 1, minWidth: 0 }}>
        <Typography sx={{ fontWeight: 700, color: colors.calmNavy }}>{title}</Typography>
        {subtitle && (
          <Typography variant="body2" sx={{ color: colors.deepPurple, mt: 0.3 }}>
            {subtitle}
          </Typography>
        )}
      </Box>
      <Box>{children}</Box>
    </Paper>
  );
}

export default function VolunteerSettings() {
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);
  const [language, setLanguage] = useState("English");
  const [logoutModalOpen, setLogoutModalOpen] = useState(false);

  const theme = useTheme();
  const isSmallScreen = useMediaQuery(theme.breakpoints.down("sm"));
  const navigate = useNavigate();

  const handleLogoutConfirm = () => {
    setLogoutModalOpen(false);
    alert("Logged out (dummy)");
  };

  const handleLogoutCancel = () => {
    setLogoutModalOpen(false);
  };

  const volunteerName = "Amanda Nethmini";
  const volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg";

  return (
    <>
      {/* Top nav spans full width above SideBar */}
      <Box
        sx={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          zIndex: 1400,
          bgcolor: colors.white,
          boxShadow: "0 2px 8px rgb(0 0 0 / 0.1)",
        }}
      >
        <VolunteerNav />
      </Box>

      {/* Sidebar fixed on left */}
      <SideBar
        volunteerName={volunteerName}
        profileImage={volunteerProfileImage}
        onNavigate={(page) => alert(`Navigate to ${page} (dummy)`)}
      />

      {/* Main content area with left padding for sidebar, top padding for nav */}
      <Box
        component="main"
        sx={{
          pl: { md: "260px" }, // sidebar width
          pt: { xs: "56px", md: "64px" }, // nav height approx.
          minHeight: "100vh",
          bgcolor: colors.backgroundLight,
          fontFamily: "Inter, Roboto, Open Sans, Arial, sans-serif",
          color: colors.calmNavy,
          pb: 8,
          px: { xs: 2, sm: 4, md: 6 },
        }}
      >
        <Container maxWidth="md" sx={{ py: 3 }}>
          {/* Header Section */}
          

          {/* Profile Header */}
          <ProfileHeader />

          {/* User Preferences */}
          <Box role="list" aria-label="Settings options">
            <SettingItem
              icon={<NotificationsActiveIcon />}
              title="Receive Notifications"
              hoverable={false}
              children={
                <Switch
                  checked={notificationsEnabled}
                  onChange={() => setNotificationsEnabled(!notificationsEnabled)}
                  color="primary"
                  inputProps={{ "aria-label": "Receive Notifications Toggle" }}
                  sx={{
                    "& .MuiSwitch-switchBase.Mui-checked": {
                      color: colors.lightSkyBlue,
                    },
                    "& .MuiSwitch-switchBase.Mui-checked + .MuiSwitch-track": {
                      backgroundColor: colors.lightSkyBlue,
                    },
                  }}
                />
              }
            />
            <SettingItem
              icon={<LanguageIcon />}
              title="Language Selection"
              subtitle="Choose your preferred language"
              hoverable={true}
              onClick={() => null}
              children={
                <FormControl size="small" variant="outlined" sx={{ minWidth: 140 }}>
                  <Select
                    value={language}
                    onChange={(e) => setLanguage(e.target.value)}
                    sx={{
                      color: colors.deepPurple,
                      ".MuiOutlinedInput-notchedOutline": { borderColor: colors.softLavender },
                      "&:hover .MuiOutlinedInput-notchedOutline": { borderColor: colors.deepPurple },
                      ".MuiSvgIcon-root": { color: colors.deepPurple },
                    }}
                    inputProps={{ "aria-label": "Select Language" }}
                  >
                    <MenuItem value="English">English</MenuItem>
                    <MenuItem value="Sinhala">Sinhala</MenuItem>
                    <MenuItem value="Tamil">Tamil</MenuItem>
                  </Select>
                </FormControl>
              }
            />
            <SettingItem
              icon={<SecurityIcon />}
              title="Privacy"
              subtitle="Manage your data"
              hoverable={true}
              onClick={() => navigate("/VolunteerPrivacy")} // Navigate to privacy page
            />
            <SettingItem
              icon={<HelpOutlineIcon />}
              title="Help & Support"
              subtitle="FAQs & Support"
              hoverable={true}
              onClick={() => navigate("/HelpAndSupport")} // Navigate to help page
            />
          </Box>

          {/* Logout Button */}
          <Box sx={{ mt: 6, textAlign: "center" }}>
            <Button
              variant="contained"
              startIcon={<LogoutIcon />}
              onClick={() => setLogoutModalOpen(true)}
              sx={{
                bgcolor: `linear-gradient(45deg, ${colors.deepPurple}, ${colors.calmNavy})`,
                px: 6,
                py: 1.5,
                fontWeight: 700,
                borderRadius: 6,
                color: "white",
                boxShadow: `0 4px 12px ${colors.deepPurple}aa`,
                fontSize: 16,
                transition: "all 0.3s ease",
                "&:hover": {
                  bgcolor: `linear-gradient(45deg, ${colors.calmNavy}, ${colors.deepPurple})`,
                  boxShadow: `0 6px 18px ${colors.calmNavy}cc`,
                },
              }}
              aria-label="Logout button"
            >
              Logout
            </Button>
          </Box>
        </Container>
      </Box>

      {/* Footer at bottom */}

    <Box sx={{ pl: { md: "260px" } }}>
      <Footer />
    </Box>

      {/* Logout Confirmation Dialog */}
      <Dialog
        open={logoutModalOpen}
        onClose={() => setLogoutModalOpen(false)}
        aria-labelledby="logout-dialog-title"
        aria-describedby="logout-dialog-description"
      >
        <DialogTitle id="logout-dialog-title" sx={{ color: colors.deepPurple }}>
          Confirm Logout
        </DialogTitle>
        <DialogContent dividers>
          <Typography id="logout-dialog-description" sx={{ color: colors.calmNavy }}>
            Are you sure you want to log out?
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleLogoutCancel} color="primary" aria-label="Cancel logout">
            Cancel
          </Button>
          <Button
            onClick={handleLogoutConfirm}
            color="error"
            variant="contained"
            aria-label="Confirm logout"
          >
            Logout
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
