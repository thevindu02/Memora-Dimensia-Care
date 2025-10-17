// src/components/volunteers/ViewArticle.js
import React, { useState, useEffect } from "react";
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
  CircularProgress,
  Alert,
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

import articleService from "../../services/articleService";

// Brand colors
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};

// Sample comments (keeping as static for now since comments are not implemented yet)
const sampleComments = [
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
    avatar: "",
    timestamp: "5 hours ago",
    content:
      "Great tips on patience and communication. I found the caregiver advice especially useful.",
  },
];

export default function ViewArticle() {
  const { id } = useParams(); // Get the article ID from the URL

  // State management
  const [article, setArticle] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  // Like button state
  const [liked, setLiked] = useState(false);
  const [likesCount, setLikesCount] = useState(56); // Hardcoded for now

  // Comment input state
  const [commentText, setCommentText] = useState("");
  const [comments, setComments] = useState(sampleComments);

  // Fetch article data
  useEffect(() => {
    const fetchArticle = async () => {
      try {
        setLoading(true);
        setError(null);

        console.log("Fetching article with ID:", id);
        const response = await articleService.getArticleDetail(id);

        if (response.success) {
          console.log("Article fetched successfully:", response.data);
          console.log("Article image URL:", response.data.articleImg);
          console.log("Article image type:", typeof response.data.articleImg);
          setArticle(response.data);
        } else {
          setError(response.message || "Failed to load article");
        }
      } catch (err) {
        console.error("Error fetching article:", err);
        setError("Failed to load article. Please try again.");
      } finally {
        setLoading(false);
      }
    };

    if (id) {
      fetchArticle();
    }
  }, [id]);

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

  // Show loading state
  if (loading) {
    return (
      <Box sx={{ minHeight: "100vh", bgcolor: "#F8F9FB", display: "flex", alignItems: "center", justifyContent: "center" }}>
        <CircularProgress color="primary" />
        <Typography variant="body1" sx={{ ml: 2 }}>
          Loading article...
        </Typography>
      </Box>
    );
  }

  // Show error state
  if (error || !article) {
    return (
      <Box sx={{ minHeight: "100vh", bgcolor: "#F8F9FB", p: 4 }}>
        <Container maxWidth="md">
          <Alert severity="error" sx={{ mb: 3 }}>
            {error || "Article not found"}
          </Alert>
          <IconButton onClick={() => window.history.back()}>
            <IoArrowBackSharp size={24} />
          </IconButton>
        </Container>
      </Box>
    );
  }

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
            {article.title || "Untitled Article"}
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
              src={article.authorProfilePic || ""}
              alt={article.authorName || "Unknown Author"}
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
                {article.authorName || "Unknown Author"}
              </Typography>
            </Box>
          </Stack>

          {article.categoryName && (
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
                {article.categoryName}
              </Typography>
            </Box>
          )}
        </Stack>

        {/* Banner Image Section - Always show */}
        <Box
          sx={{
            position: "relative",
            width: "100%",
            height: { xs: 200, md: 320 },
            borderRadius: 3,
            overflow: "hidden",
            mb: 4,
            bgcolor: "#F0F0F0",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            userSelect: "none",
            border: `2px solid ${colors.softLavender}`,
          }}
        >
          {article.articleImg && article.articleImg.trim() !== "" ? (
            <img
              src={article.articleImg}
              alt={`Banner for ${article.title || "Article"}`}
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
          ) : null}
          <Box
            id="imgPlaceholder"
            sx={{
              display: !article.articleImg || article.articleImg.trim() === "" ? "flex" : "none",
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
            <Typography variant="body1" sx={{ color: colors.calmNavy }}>
              Image not available
            </Typography>
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
