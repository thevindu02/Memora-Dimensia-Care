// src/components/volunteers/PublishedArticles.js
import React, { useState  } from "react";
import { useNavigate } from 'react-router-dom';

import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  IconButton,
  Badge,
  Stack,
} from "@mui/material";

import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";
import VisibilityIcon from "@mui/icons-material/Visibility";

import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  backgroundLight: "#FFFFFF",
  fallbackGray: "#f0f0f0",
};

// Dummy published articles by the logged-in volunteer (static data)
const publishedArticlesData = [
  {
    id: 101,
    title: "Understanding Dementia Care Basics",
    excerpt:
      "An introductory overview of dementia care, its challenges and how volunteers can help caregivers at home.",
    thumbnail:
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80",
    publishedDate: "2025-08-01",
  },
  {
    id: 102,
    title: "5 Tips For Volunteers",
    excerpt:
      "Practical ways to provide meaningful support and communicate effectively with dementia patients.",
    thumbnail: "", // No image, fallback illustration will show
    publishedDate: "2025-07-26",
  },
  {
    id: 103,
    title: "Healthy Nutrition for Dementia",
    excerpt:
      "A guide to balanced diets and food types that can help improve overall wellbeing for dementia patients.",
    thumbnail:
      "https://images.unsplash.com/photo-1526045612212-70caf35c14df?auto=format&fit=crop&w=600&q=80",
    publishedDate: "2025-07-15",
  },
];

function ArticleCard({ article }) {
  const navigate = useNavigate(); // Add this line

  const fallbackImage =
    "https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=600&q=80";

  return (
    <Paper
      elevation={4}
      tabIndex={0}
      role="article"
      aria-label={`Published article titled ${article.title}`}
      sx={{
        borderRadius: 3,
        overflow: "hidden",
        display: "flex",
        flexDirection: "column",
        height: "100%",
        cursor: "pointer",
        boxShadow: `0 2px 8px ${colors.softLavender}AA`,
        transition: "box-shadow 0.3s ease",
        "&:hover": {
          boxShadow: `0 10px 30px ${colors.deepPurple}88`,
        },
        outlineOffset: 2,
        outline: "none",
        "&:focus-visible": {
          outline: `2px solid ${colors.lightSkyBlue}`,
        },
      }}
      onClick={() => navigate(`/ViewArticle/${article.id}`)} // Change here
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          navigate(`/ViewArticle/${article.id}`); // Change here
        }
      }}
    >
      <Box
        component="img"
        src={article.thumbnail || fallbackImage}
        alt={article.thumbnail ? `Thumbnail of ${article.title}` : "Fallback illustration"}
        loading="lazy"
        sx={{
          width: "100%",
          height: 160,
          objectFit: "cover",
          backgroundColor: colors.fallbackGray,
        }}
      />
      <Box sx={{ p: 2, flexGrow: 1, display: "flex", flexDirection: "column" }}>
        <Typography
          variant="h6"
          sx={{
            fontWeight: 700,
            color: colors.deepPurple,
            mb: 1,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 2,
            WebkitBoxOrient: "vertical",
            userSelect: "text",
          }}
        >
          {article.title}
        </Typography>
        <Typography
          variant="body2"
          sx={{
            flexGrow: 1,
            color: colors.calmNavy,
            mb: 2,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 3,
            WebkitBoxOrient: "vertical",
            userSelect: "text",
          }}
        >
          {article.excerpt}
        </Typography>

        <Stack
          direction="row"
          justifyContent="space-between"
          alignItems="center"
          sx={{ fontSize: 12, userSelect: "none", color: colors.calmNavy }}
        >
          <Stack direction="row" alignItems="center" spacing={0.5}>
            <CalendarTodayIcon fontSize="small" sx={{ color: colors.lightSkyBlue }} />
            <time dateTime={article.publishedDate}>
              {new Date(article.publishedDate).toLocaleDateString(undefined, {
                year: "numeric",
                month: "short",
                day: "numeric",
              })}
            </time>
          </Stack>

          <Stack direction="row" spacing={1}>
            <IconButton
              aria-label={`Edit article titled ${article.title}`}
              size="small"
              onClick={(e) => {
                e.stopPropagation();
                alert(`Edit article: ${article.title} (dummy)`);
              }}
            >
              <EditIcon sx={{ color: colors.deepPurple }} fontSize="small" />
            </IconButton>

            <IconButton
              aria-label={`Delete article titled ${article.title}`}
              size="small"
              onClick={(e) => {
                e.stopPropagation();
                /* Confirm before deleting */
                if (window.confirm(`Are you sure you want to delete "${article.title}"?`)) {
                  alert(`Deleted article: ${article.title} (dummy)`);
                }
              }}
            >
              <DeleteIcon sx={{ color: "#E04848" }} fontSize="small" />
            </IconButton>

            <IconButton
              aria-label={`View full article titled ${article.title}`}
              size="small"
              onClick={(e) => {
                e.stopPropagation();
                alert(`View full article: ${article.title} (dummy)`);
              }}
            >
              <VisibilityIcon sx={{ color: colors.calmNavy }} fontSize="small" />
            </IconButton>
          </Stack>
        </Stack>
      </Box>
    </Paper>
  );
}

export default function PublishedArticles() {
  const navigate = useNavigate(); // Add this line
  const [articles, setArticles] = useState(publishedArticlesData);

  const articlesCount = articles.length;
 


  return (
    <>
      {/* Top Nav spanning full width above sidebar */}
      <Box
        sx={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          height: 64,
          zIndex: 1400,
          bgcolor: colors.backgroundLight,
          boxShadow: "0 2px 8px rgb(0 0 0 / 0.1)",
        }}
      >
        <VolunteerNav />
      </Box>

      {/* Fixed Sidebar */}
      <SideBar
        volunteerName="Alex Morgan"
        profileImage="https://randomuser.me/api/portraits/women/44.jpg"
        onNavigate={(page) => alert(`Navigate to ${page} (dummy)`)}
      />

      {/* Main content */}
      <Box
        component="main"
        role="main"
        sx={{
          minHeight: "100vh",
          pt: "130px", // nav height
          pb: 10,
          pl: { xs: 2, md: "260px" }, // leave space for sidebar on md+
          pr: { xs: 2, md: 6 },
          bgcolor: colors.backgroundLight,
          fontFamily: `"Poppins", "Lato", "Nunito", Arial, sans-serif`,
          color: colors.calmNavy,
        }}
      >
        {/* Header: title + count + new article button */}
        <Box
          sx={{
            maxWidth: 1200,
            mx: "auto",
            mb: 4,
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            flexWrap: "wrap",
            gap: 2,
          }}
        >
          <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
            <Typography variant="h4" fontWeight={700} sx={{ userSelect: "none" }}>
              My Published Articles
            </Typography>
            <Badge
              color="primary"
              badgeContent={articlesCount}
              sx={{
                "& .MuiBadge-badge": {
                  bgcolor: colors.deepPurple,
                  fontWeight: 700,
                  fontSize: 16,
                  minWidth: 32,
                  height: 32,
                  borderRadius: "16px",
                  top: -6,
                },
              }}
              aria-label={`${articlesCount} articles published`}
            />
          </Box>

          <Button
            variant="contained"
            sx={{
              bgcolor: colors.deepPurple,
              "&:hover": { bgcolor: colors.calmNavy },
              textTransform: "none",
              fontWeight: 700,
              px: 3,
              py: 1,
            }}
             onClick={() => navigate("/CreateBlog")}
          >
            + New Article
          </Button>
        </Box>

        {/* Articles grid or empty state */}
        {articlesCount > 0 ? (
          <Grid container spacing={4} maxWidth={1200} sx={{ mx: "auto" }}>
            {articles.map((article) => (
              <Grid item xs={12} sm={6} md={4} key={article.id}>
                <ArticleCard article={article} />
              </Grid>
            ))}
          </Grid>
        ) : (
          <Box
            sx={{
              mt: 12,
              color: colors.softLavender,
              textAlign: "center",
              userSelect: "none",
            }}
          >
            <Box
              component="img"
              src="https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?auto=format&fit=crop&w=240&q=80"
              alt="Empty state illustration"
              sx={{ mx: "auto", mb: 3, maxWidth: 240 }}
              loading="lazy"
            />
            <Typography variant="h6">
              You haven’t published any articles yet. Start sharing your insights!
            </Typography>
          </Box>
        )}
      </Box>

        <Box sx={{ pl: { md: "260px" } }}>
            <Footer />
        </Box>
    </>
  );
}
