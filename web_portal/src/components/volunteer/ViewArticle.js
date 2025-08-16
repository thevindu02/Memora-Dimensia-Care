// src/components/volunteers/ViewArticle.js
import React, { useState } from "react";
import { useParams } from "react-router-dom";
import {
  Box,
  Typography,
  Avatar,
  IconButton,
  Paper,
  Stack,
  TextField,
  Tooltip,
  Container,
} from "@mui/material";

import {
  IoArrowBackSharp,
  IoHeartOutline,
  IoHeart,
  IoChatbubbleEllipsesOutline,
  IoSendSharp,
  IoPersonOutline,
  IoImageOutline,
} from "react-icons/io5";

// Remove SideBar, VolunteerNav, Footer imports

// Brand colors
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};

// Hardcoded sample article
const article = {
  title: "Understanding Dementia Care Basics",
  author: "Dr. Sarah Johnson",
  authorAvatar: "https://randomuser.me/api/portraits/women/44.jpg",
  category: "Awareness",
  imageUrl:
    "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1000&q=80",
  content: `Dementia is a complex condition affecting millions worldwide. Early signs often include memory loss, difficulty completing familiar tasks, confusion with time or place, and changes in mood or personality.

Volunteers can make a meaningful difference to caregivers and patients by understanding these basics and providing compassionate support.

This article provides a comprehensive overview of dementia care principles, practical tips for volunteers, and advice for families navigating this challenging journey.`,

  stats: {
    likes: 56,
    comments: 14,
  },

  comments: [
    {
      id: 1,
      author: "Emily Rogers",
      avatar: "https://randomuser.me/api/portraits/women/68.jpg",
      timestamp: "2 hours ago",
      content:
        "Thank you for this detailed guide! It helped me better understand how to assist my neighbor living with dementia.",
    },
    {
      id: 2,
      author: "James Thompson",
      avatar: "", // No avatar, should show placeholder
      timestamp: "5 hours ago",
      content:
        "Great tips on patience and communication. I found the caregiver advice especially useful.",
    },
  ],
};

export default function ViewArticle() {
  const { id } = useParams(); // Get the article ID from the URL

  // TODO: Fetch or filter the article data using the id
  // For now, you can log it:
  console.log("Viewing article with ID:", id);

  // Like button state
  const [liked, setLiked] = useState(false);
  const [likesCount, setLikesCount] = useState(article.stats.likes);

  // Comment input state
  const [commentText, setCommentText] = useState("");
  const [comments, setComments] = useState(article.comments);

  const toggleLike = () => {
    setLiked((prev) => !prev);
    setLikesCount((count) => count + (liked ? -1 : 1));
  };

  const addComment = () => {
    if (!commentText.trim()) return;
    const newComment = {
      id: Date.now(),
      author: "You",
      avatar: "",
      timestamp: "Just now",
      content: commentText.trim(),
    };
    setComments([newComment, ...comments]);
    setCommentText("");
  };

  return (
    <Box sx={{ minHeight: "100vh", bgcolor: "#F8F9FB" }}>
      <Container
        maxWidth="md"
        sx={{
          pb: 12,
          pt: 4,
          flexGrow: 1,
          userSelect: "text",
        }}
      >
        {/* Header with Back button only */}
        <Box
          sx={{
            mb: 3,
            display: "flex",
            alignItems: "center",
            gap: 1,
          }}
        >
          <Tooltip title="Go Back" arrow>
            <IconButton
              aria-label="Back"
              onClick={() => window.history.back()}
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
          <Typography
            component="h1"
            variant="h4"
            sx={{
              fontWeight: 700,
              color: colors.deepPurple,
              userSelect: "text",
              px: 1,
            }}
          >
            {article.title}
          </Typography>
        </Box>

        {/* Author + Category tag */}
        <Stack
          direction={{ xs: "column", sm: "row" }}
          alignItems="center"
          spacing={2}
          sx={{ mb: 3 }}
        >
          <Stack direction="row" alignItems="center" spacing={1} sx={{ flexShrink: 0 }}>
            <Avatar
              src={article.authorAvatar}
              alt={article.author}
              sx={{ width: 44, height: 44, border: `2px solid ${colors.deepPurple}` }}
            >
              <IoPersonOutline size={24} />
            </Avatar>

            <Box>
              <Typography
                variant="subtitle1"
                component="div"
                sx={{ fontWeight: 600, color: colors.calmNavy }}
              >
                {article.author}
              </Typography>
            </Box>
          </Stack>

          <Box
            sx={{
              bgcolor: colors.lightSkyBlue,
              px: 2,
              py: 0.5,
              borderRadius: "16px",
              userSelect: "none",
            }}
          >
            <Typography
              variant="caption"
              sx={{ fontWeight: 600, color: colors.calmNavy, letterSpacing: 0.9 }}
            >
              {article.category}
            </Typography>
          </Box>
        </Stack>

        {/* Banner Image Section */}
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
            userSelect: "none",
          }}
        >
          <img
            src={article.imageUrl}
            alt={`Banner for ${article.title}`}
            style={{
              width: "100%",
              height: "100%",
              objectFit: "cover",
              borderRadius: 12,
              display: "block",
              userSelect: "none",
            }}
            onError={(e) => {
              e.target.onerror = null;
              e.target.style.display = "none";
              const placeholder = document.getElementById("imgPlaceholder");
              if (placeholder) placeholder.style.display = "flex";
            }}
          />
          <Box
            id="imgPlaceholder"
            sx={{
              display: "none",
              flexDirection: "column",
              alignItems: "center",
              justifyContent: "center",
              color: colors.calmNavy,
              gap: 1,
              position: "absolute",
              inset: 0,
              fontWeight: 700,
              fontSize: 18,
              backgroundColor: "#F0F0F0",
              borderRadius: 3,
              userSelect: "none",
            }}
          >
            <IoImageOutline size={48} />
            Image not available
          </Box>
        </Box>

        {/* Stats section (Likes + Comments) */}
        <Stack
          direction="row"
          spacing={4}
          alignItems="center"
          sx={{ mb: 4, userSelect: "none" }}
        >
          <Tooltip title={liked ? "Unlike" : "Like"} arrow>
            <IconButton
              onClick={toggleLike}
              aria-pressed={liked}
              aria-label={liked ? "Unlike article" : "Like article"}
              sx={{
                color: liked ? colors.deepPurple : colors.calmNavy,
                bgcolor: liked ? colors.softLavender : "transparent",
                transition: "background-color 0.3s ease",
                "&:hover": {
                  bgcolor: colors.softLavender,
                  color: colors.deepPurple,
                },
              }}
              size="large"
            >
              {liked ? <IoHeart size={26} /> : <IoHeartOutline size={26} />}
            </IconButton>
          </Tooltip>
          <Typography sx={{ color: colors.calmNavy, fontWeight: 600 }}>
            {likesCount} likes
          </Typography>

          <Stack direction="row" spacing={0.5} alignItems="center">
            <IoChatbubbleEllipsesOutline size={22} color={colors.calmNavy} />
            <Typography sx={{ color: colors.calmNavy, fontWeight: 600 }}>
              {comments.length} comments
            </Typography>
          </Stack>
        </Stack>

        {/* Article Content */}
        <Paper
          elevation={2}
          sx={{
            backgroundColor: colors.softLavender,
            borderRadius: 3,
            p: { xs: 3, md: 5 },
            mb: 5,
            userSelect: "text",
            fontSize: "18px",
            lineHeight: 1.7,
            fontFamily: `"Lora", serif`,
            color: colors.calmNavy,
            whiteSpace: "pre-line",
            minHeight: "250px",
          }}
        >
          {article.content}
        </Paper>

        {/* Comments Section */}
        <Box>
          <Typography
            component="h2"
            variant="h5"
            sx={{ color: colors.deepPurple, fontWeight: 700, mb: 3 }}
          >
            Comments ({comments.length})
          </Typography>

          <Stack spacing={3}>
            {comments.length === 0 && (
              <Typography sx={{ color: colors.softLavender, fontStyle: "italic" }}>
                No comments yet. Be the first to comment!
              </Typography>
            )}

            {comments.map((c) => (
              <Paper
                key={c.id}
                elevation={2}
                sx={{
                  p: 2,
                  borderRadius: 3,
                  display: "flex",
                  gap: 2,
                  alignItems: "flex-start",
                  bgcolor: "#fff",
                  userSelect: "text",
                }}
                aria-label={`Comment by ${c.author}`}
              >
                <Avatar
                  src={c.avatar}
                  alt={c.author}
                  sx={{ width: 44, height: 44, border: `2px solid ${colors.deepPurple}` }}
                >
                  {!c.avatar && <IoPersonOutline size={28} color={colors.deepPurple} />}
                </Avatar>
                <Box sx={{ flex: 1 }}>
                  <Stack
                    direction="row"
                    alignItems="center"
                    justifyContent="space-between"
                    sx={{ mb: 0.5 }}
                  >
                    <Typography sx={{ fontWeight: 700, color: colors.calmNavy }}>
                      {c.author}
                    </Typography>
                    <Typography variant="caption" sx={{ color: colors.softLavender }}>
                      {c.timestamp}
                    </Typography>
                  </Stack>
                  <Typography sx={{ color: colors.calmNavy, fontSize: 15, whiteSpace: "pre-line" }}>
                    {c.content}
                  </Typography>
                </Box>
              </Paper>
            ))}
          </Stack>
        </Box>
      </Container>

      {/* Fixed Comment Input at bottom */}
      <Box
        sx={{
          position: "fixed",
          bottom: 0,
          left: 0,
          right: 0,
          bgcolor: "#fff",
          borderTop: `1px solid ${colors.softLavender}`,
          px: { xs: 2, md: 4 },
          py: 1.5,
          display: "flex",
          alignItems: "center",
          gap: 2,
          zIndex: 1600,
        }}
      >
        <TextField
          fullWidth
          variant="outlined"
          placeholder="Reply to comments..."
          value={commentText}
          onChange={(e) => setCommentText(e.target.value)}
          size="small"
          InputProps={{
            sx: {
              borderRadius: 24,
              fontSize: 14,
              fontWeight: 400,
              color: colors.calmNavy,
              px: 3,
            },
            "aria-label": "Reply to comments",
          }}
          onKeyDown={(e) => {
            if (e.key === "Enter" && !e.shiftKey) {
              e.preventDefault();
              addComment();
            }
          }}
        />
        <Tooltip title="Send comment" arrow>
          <IconButton
            color="primary"
            onClick={addComment}
            sx={{
              bgcolor: colors.lightSkyBlue,
              color: colors.calmNavy,
              "&:hover": { bgcolor: colors.deepPurple, color: "#fff" },
              borderRadius: "50%",
              p: 1.25,
            }}
            aria-label="Send comment"
            size="large"
          >
            <IoSendSharp size={24} />
          </IconButton>
        </Tooltip>
      </Box>
    </Box>
  );
}
