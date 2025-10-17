// src/components/volunteer/ViewDraft.js
import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import {
  Box,
  Typography,
  Avatar,
  IconButton,
  Paper,
  Stack,
  Tooltip,
  Container,
  CircularProgress,
  Alert,
  Button,
  Chip,
} from "@mui/material";

import {
  IoArrowBackSharp,
  IoPersonOutline,
  IoImageOutline,
} from "react-icons/io5";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";

import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";
import AuthService from "../../services/authService";
import articleService from "../../services/articleService";

// Brand colors
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
  backgroundLight: "#F8F9FB",
};

export default function ViewDraft() {
  const { id } = useParams(); // Get the draft ID from the URL
  const navigate = useNavigate();

  const [draft, setDraft] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);

  // Fetch draft article by ID
  useEffect(() => {
    const fetchDraft = async () => {
      try {
        setLoading(true);
        setError(null);

        const user = AuthService.getCurrentUser();
        if (!user || !user.id) {
          setError("User not authenticated. Please log in again.");
          return;
        }

        setCurrentUser(user);
        console.log("Fetching draft with ID:", id);

        const response = await articleService.getArticleById(id);

        if (response.success && response.data) {
          // Verify this draft belongs to the current user
          if (response.data.volunteerId !== user.id) {
            setError("You don't have permission to view this draft.");
            return;
          }

          // Verify it's actually a draft
          if (!response.data.draft) {
            setError("This article is not a draft.");
            return;
          }

          setDraft(response.data);
        } else {
          setError(response.message || "Failed to fetch draft article");
        }
      } catch (error) {
        console.error("Error fetching draft:", error);
        setError("Failed to load draft article. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchDraft();
    }
  }, [id]);

  const handleEdit = () => {
    navigate(`/EditDraft/${id}`);
  };

  const handleDelete = async () => {
    if (window.confirm(`Are you sure you want to delete the draft "${draft.title}"?`)) {
      try {
        // TODO: Implement delete API call
        alert("Delete functionality not implemented yet.");
        // After successful delete, navigate back to drafts page
        // navigate("/ArticleDrafts");
      } catch (error) {
        console.error("Error deleting draft:", error);
        alert("Failed to delete draft. Please try again.");
      }
    }
  };

  const formatDate = (timestamp) => {
    if (!timestamp) return "Unknown date";
    try {
      const date = new Date(timestamp);
      return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch (error) {
      return "Unknown date";
    }
  };

  return (
    <>
      {/* Top nav fixed full width on top */}
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
        volunteerName={currentUser?.firstName ? `${currentUser.firstName} ${currentUser.lastName}` : "Volunteer"}
        profileImage="https://randomuser.me/api/portraits/women/44.jpg"
        onNavigate={() => {}}
      />

      {/* Main content area */}
      <Box
        component="main"
        sx={{
          pl: { md: "260px" },
          pt: { xs: "56px", md: "130px" },
          minHeight: "100vh",
          bgcolor: colors.backgroundLight,
          pb: 8,
        }}
      >
        <Container maxWidth="md" sx={{ py: 3 }}>
          {/* Error Alert */}
          {error && (
            <Alert severity="error" sx={{ mb: 3 }}>
              {error}
              <Button
                size="small"
                onClick={() => navigate("/ArticleDrafts")}
                sx={{ ml: 2 }}
              >
                Back to Drafts
              </Button>
            </Alert>
          )}

          {/* Loading State */}
          {loading ? (
            <Box display="flex" justifyContent="center" alignItems="center" py={8}>
              <CircularProgress color="primary" />
              <Typography variant="body1" sx={{ ml: 2 }}>
                Loading draft...
              </Typography>
            </Box>
          ) : draft ? (
            <>
              {/* Header with Back button and actions */}
              <Box
                sx={{
                  mb: 3,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "space-between",
                  flexWrap: "wrap",
                  gap: 2,
                }}
              >
                <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                  <Tooltip title="Go Back" arrow>
                    <IconButton
                      aria-label="Back"
                      onClick={() => navigate("/ArticleDrafts")}
                      sx={{
                        bgcolor: colors.softLavender,
                        color: colors.deepPurple,
                        "&:hover": { bgcolor: colors.deepPurple, color: colors.softLavender },
                      }}
                      size="large"
                    >
                      <IoArrowBackSharp size={24} />
                    </IconButton>
                  </Tooltip>
                  <Chip
                    label="DRAFT"
                    size="small"
                    sx={{
                      bgcolor: colors.lightSkyBlue,
                      color: colors.calmNavy,
                      fontWeight: 700,
                      fontSize: 12,
                    }}
                  />
                </Box>

                <Stack direction="row" spacing={1}>
                  <Button
                    variant="contained"
                    startIcon={<EditIcon />}
                    onClick={handleEdit}
                    sx={{
                      bgcolor: colors.deepPurple,
                      "&:hover": { bgcolor: colors.calmNavy },
                    }}
                  >
                    Edit Draft
                  </Button>
                  <Button
                    variant="outlined"
                    startIcon={<DeleteIcon />}
                    onClick={handleDelete}
                    sx={{
                      borderColor: "#E04848",
                      color: "#E04848",
                      "&:hover": {
                        borderColor: "#C03030",
                        bgcolor: "#FEE",
                      },
                    }}
                  >
                    Delete
                  </Button>
                </Stack>
              </Box>

              {/* Title */}
              <Typography
                component="h1"
                variant="h4"
                sx={{
                  fontWeight: 700,
                  color: colors.deepPurple,
                  mb: 2,
                  userSelect: "text",
                }}
              >
                {draft.title || "Untitled Draft"}
              </Typography>

              {/* Metadata */}
              <Stack
                direction={{ xs: "column", sm: "row" }}
                alignItems="center"
                spacing={2}
                sx={{ mb: 3 }}
              >
                <Stack direction="row" alignItems="center" spacing={1}>
                  <Avatar
                    sx={{ width: 44, height: 44, border: `2px solid ${colors.deepPurple}`, bgcolor: colors.softLavender }}
                  >
                    <IoPersonOutline size={24} />
                  </Avatar>
                  <Box>
                    <Typography
                      variant="subtitle1"
                      sx={{ fontWeight: 600, color: colors.calmNavy }}
                    >
                      {currentUser?.firstName} {currentUser?.lastName}
                    </Typography>
                    <Typography variant="caption" sx={{ color: colors.softLavender }}>
                      Last updated: {formatDate(draft.created_at)}
                    </Typography>
                  </Box>
                </Stack>

                {draft.categoryId && (
                  <Box
                    sx={{
                      bgcolor: colors.lightSkyBlue,
                      px: 2,
                      py: 0.5,
                      borderRadius: "16px",
                    }}
                  >
                    <Typography
                      variant="caption"
                      sx={{ fontWeight: 600, color: colors.calmNavy, letterSpacing: 0.9 }}
                    >
                      Category ID: {draft.categoryId}
                    </Typography>
                  </Box>
                )}

                {draft.status && (
                  <Chip
                    label={draft.status.toUpperCase()}
                    size="small"
                    sx={{
                      bgcolor: draft.status === 'approved' ? '#4CAF50' : '#FFA726',
                      color: colors.white,
                      fontWeight: 600,
                    }}
                  />
                )}
              </Stack>

              {/* Summary */}
              {draft.summary && draft.summary.trim() !== '' && (
                <Paper
                  elevation={1}
                  sx={{
                    backgroundColor: colors.lightSkyBlue + "33",
                    borderRadius: 2,
                    p: 2,
                    mb: 3,
                    borderLeft: `4px solid ${colors.lightSkyBlue}`,
                  }}
                >
                  <Typography
                    variant="subtitle2"
                    sx={{ fontWeight: 700, color: colors.deepPurple, mb: 1 }}
                  >
                    Summary
                  </Typography>
                  <Typography
                    variant="body2"
                    sx={{ color: colors.calmNavy, fontStyle: "italic", userSelect: "text" }}
                  >
                    {draft.summary}
                  </Typography>
                </Paper>
              )}

              {/* Banner Image */}
              {draft.articleImg && draft.articleImg.trim() !== '' && (
                <Box
                  sx={{
                    position: "relative",
                    width: "100%",
                    height: { xs: 200, md: 320 },
                    borderRadius: 3,
                    overflow: "hidden",
                    mb: 4,
                    bgcolor: colors.softLavender,
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "center",
                  }}
                >
                  <img
                    src={draft.articleImg}
                    alt={`Banner for ${draft.title}`}
                    style={{
                      width: "100%",
                      height: "100%",
                      objectFit: "cover",
                      borderRadius: 12,
                      display: "block",
                    }}
                    onError={(e) => {
                      e.target.style.display = "none";
                    }}
                  />
                </Box>
              )}

              {/* Article Content */}
              <Paper
                elevation={2}
                sx={{
                  backgroundColor: colors.softLavender + "44",
                  borderRadius: 3,
                  p: { xs: 3, md: 5 },
                  mb: 5,
                  userSelect: "text",
                  fontSize: "18px",
                  lineHeight: 1.7,
                  fontFamily: `"Lora", "Poppins", serif`,
                  color: colors.calmNavy,
                  whiteSpace: "pre-line",
                  minHeight: "250px",
                }}
              >
                {draft.content || "No content available"}
              </Paper>
            </>
          ) : null}
        </Container>
      </Box>

      <Box sx={{ pl: { md: "260px" } }}>
        <Footer />
      </Box>
    </>
  );
}
