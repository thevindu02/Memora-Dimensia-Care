// src/components/volunteer/SingleArticle.js
import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import {
  Box,
  Typography,
  Avatar,
  IconButton,
  Paper,
  Stack,
  TextField,
  Button,
  Container,
  CircularProgress,
  Alert,
  Divider,
  Chip,
} from "@mui/material";
import {
  ArrowBack as ArrowBackIcon,
  ThumbUp as ThumbUpIcon,
  ThumbUpOutlined as ThumbUpOutlinedIcon,
  ThumbDown as ThumbDownIcon,
  ThumbDownOutlined as ThumbDownOutlinedIcon,
  ChatBubbleOutline as ChatBubbleOutlineIcon,
  Send as SendIcon,
  Person as PersonIcon,
  Image as ImageIcon,
  CalendarToday as CalendarTodayIcon,
  Reply as ReplyIcon,
  Close as CloseIcon,
} from "@mui/icons-material";

import articleService from "../../services/articleService";
import commentService from "../../services/commentService";

// Brand colors matching the web portal theme
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};

export default function SingleArticle() {
  const { id } = useParams(); // Article ID from URL
  const navigate = useNavigate();

  // Article state
  const [article, setArticle] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Like/Unlike state
  const [liked, setLiked] = useState(false);
  const [unliked, setUnliked] = useState(false);
  const [likeCount, setLikeCount] = useState(0);

  // Comments state
  const [comments, setComments] = useState([]);
  const [commentText, setCommentText] = useState("");
  const [isPostingComment, setIsPostingComment] = useState(false);

  // Reply state
  const [replyingTo, setReplyingTo] = useState(null); // Comment ID being replied to
  const [replyText, setReplyText] = useState("");
  const [isPostingReply, setIsPostingReply] = useState(false);
  const [commentReplies, setCommentReplies] = useState({}); // Map of commentId -> replies array
  const [showReplies, setShowReplies] = useState({}); // Map of commentId -> boolean (show/hide)

  // User info (from localStorage - adjust based on your auth implementation)
  const [currentUser, setCurrentUser] = useState(null);

  // Load current user
  useEffect(() => {
    const loadUser = () => {
      try {
        const userStr = localStorage.getItem('user');
        if (userStr) {
          const user = JSON.parse(userStr);
          setCurrentUser(user);
          console.log('Current user loaded:', user);
        }
      } catch (error) {
        console.error('Error loading user:', error);
      }
    };

    loadUser();
  }, []);

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

  // Load like status
  useEffect(() => {
    const loadLikeStatus = async () => {
      if (!id || !currentUser) return;

      try {
        console.log('Loading like status for article:', id, 'user:', currentUser.id);
        const response = await articleService.getArticleLikeStatus(id, currentUser.id);

        if (response.success) {
          setLikeCount(response.likeCount);
          setLiked(response.hasLiked);
          console.log('Like status loaded:', response);
        }
      } catch (error) {
        console.error('Error loading like status:', error);
      }
    };

    loadLikeStatus();
  }, [id, currentUser]);

  // Subscribe to comments (real-time)
  useEffect(() => {
    if (!id) return;

    console.log('Setting up comment subscription for article:', id);
    
    const unsubscribe = commentService.subscribeToComments(id, (newComments) => {
      console.log('Comments updated:', newComments.length);
      setComments(newComments);
    });

    return () => {
      console.log('Unsubscribing from comments');
      unsubscribe();
    };
  }, [id]);

  // Subscribe to replies for all comments
  useEffect(() => {
    if (!comments || comments.length === 0) return;

    const unsubscribers = [];

    comments.forEach(comment => {
      const unsubscribe = commentService.subscribeToReplies(comment.id, (replies) => {
        setCommentReplies(prev => ({
          ...prev,
          [comment.id]: replies
        }));
      });
      unsubscribers.push(unsubscribe);
    });

    return () => {
      unsubscribers.forEach(unsub => unsub());
    };
  }, [comments]);

  // Handle like
  const handleLike = async () => {
    if (!currentUser) {
      alert('Please sign in to like articles');
      return;
    }

    if (liked) {
      alert('You have already liked this article');
      return;
    }

    // Optimistic update
    const previousLikeCount = likeCount;
    setLiked(true);
    setUnliked(false);
    setLikeCount(prevCount => prevCount + 1);

    try {
      const response = await articleService.likeArticle(id, currentUser.id);

      if (!response.success) {
        // Revert on failure
        setLiked(false);
        setLikeCount(previousLikeCount);
        alert(response.message || 'Failed to like article');
      }
    } catch (error) {
      // Revert on error
      setLiked(false);
      setLikeCount(previousLikeCount);
      console.error('Error liking article:', error);
      alert('Error liking article');
    }
  };

  // Handle unlike
  const handleUnlike = async () => {
    if (!currentUser) {
      alert('Please sign in to unlike articles');
      return;
    }

    if (!liked) {
      alert('You need to like this article first');
      return;
    }

    // Optimistic update
    const previousLikeCount = likeCount;
    setLiked(false);
    setUnliked(true);
    setLikeCount(prevCount => Math.max(0, prevCount - 1));

    try {
      const response = await articleService.unlikeArticle(id, currentUser.id);

      if (!response.success) {
        // Revert on failure
        setLiked(true);
        setUnliked(false);
        setLikeCount(previousLikeCount);
        alert(response.message || 'Failed to unlike article');
      }
    } catch (error) {
      // Revert on error
      setLiked(true);
      setUnliked(false);
      setLikeCount(previousLikeCount);
      console.error('Error unliking article:', error);
      alert('Error unliking article');
    }
  };

  // Handle add comment
  const handleAddComment = async () => {
    if (!commentText.trim()) {
      alert('Please enter a comment');
      return;
    }

    if (!currentUser) {
      alert('Please sign in to comment');
      return;
    }

    setIsPostingComment(true);

    try {
      const userName = `${currentUser.firstName || ''} ${currentUser.lastName || ''}`.trim() || currentUser.email || 'User';
      const response = await commentService.addComment({
        articleId: id,
        userId: currentUser.id,
        userName: userName,
        userType: currentUser.role || 'Volunteer',
        content: commentText.trim(),
      });

      if (response.success) {
        setCommentText('');
        console.log('Comment added successfully');
      } else {
        alert(response.message || 'Failed to add comment');
      }
    } catch (error) {
      console.error('Error adding comment:', error);
      alert('Error adding comment');
    } finally {
      setIsPostingComment(false);
    }
  };

  // Handle reply to comment
  const handleReplyClick = (commentId) => {
    setReplyingTo(commentId);
    setReplyText('');
  };

  // Handle cancel reply
  const handleCancelReply = () => {
    setReplyingTo(null);
    setReplyText('');
  };

  // Handle add reply
  const handleAddReply = async (parentCommentId) => {
    if (!replyText.trim()) {
      alert('Please enter a reply');
      return;
    }

    if (!currentUser) {
      alert('Please sign in to reply');
      return;
    }

    setIsPostingReply(true);

    try {
      const userName = `${currentUser.firstName || ''} ${currentUser.lastName || ''}`.trim() || currentUser.email || 'User';
      const response = await commentService.addComment({
        articleId: id,
        userId: currentUser.id,
        userName: userName,
        userType: currentUser.role || 'Volunteer',
        content: replyText.trim(),
        parentCommentId: parentCommentId,
      });

      if (response.success) {
        setReplyText('');
        setReplyingTo(null);
        // Show replies for this comment
        setShowReplies(prev => ({ ...prev, [parentCommentId]: true }));
        console.log('Reply added successfully');
      } else {
        alert(response.message || 'Failed to add reply');
      }
    } catch (error) {
      console.error('Error adding reply:', error);
      alert('Error adding reply');
    } finally {
      setIsPostingReply(false);
    }
  };

  // Toggle show/hide replies
  const toggleReplies = (commentId) => {
    setShowReplies(prev => ({ ...prev, [commentId]: !prev[commentId] }));
  };

  // Format date
  const formatDate = (timestamp) => {
    if (!timestamp) return 'Recently';
    try {
      const date = new Date(timestamp);
      return date.toLocaleDateString('en-US', { 
        month: 'long', 
        day: 'numeric', 
        year: 'numeric' 
      });
    } catch {
      return 'Recently';
    }
  };

  // Show loading state
  if (loading) {
    return (
      <Box
        sx={{
          minHeight: "100vh",
          bgcolor: "#F8F9FB",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <CircularProgress sx={{ color: colors.deepPurple }} />
        <Typography variant="body1" sx={{ ml: 2, color: colors.calmNavy }}>
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
          <Button
            startIcon={<ArrowBackIcon />}
            onClick={() => navigate('/volunteer/articles')}
            variant="contained"
            sx={{
              bgcolor: colors.deepPurple,
              "&:hover": { bgcolor: colors.calmNavy },
            }}
          >
            Back to Articles
          </Button>
        </Container>
      </Box>
    );
  }

  return (
    <Box sx={{ minHeight: "100vh", bgcolor: "#F8F9FB", pb: 12 }}>
      <Container maxWidth="md" sx={{ pt: 4 }}>
        {/* Back Button */}
        <IconButton
          onClick={() => navigate('/volunteer/articles')}
          sx={{
            mb: 3,
            bgcolor: colors.softLavender,
            color: colors.deepPurple,
            "&:hover": { bgcolor: colors.deepPurple, color: "#fff" },
          }}
        >
          <ArrowBackIcon />
        </IconButton>

        {/* Article Header */}
        <Paper elevation={3} sx={{ p: 3, mb: 3, borderRadius: 3 }}>
          {/* Title */}
          <Typography
            variant="h4"
            component="h1"
            sx={{
              fontWeight: 700,
              color: colors.deepPurple,
              mb: 2,
            }}
          >
            {article.title}
          </Typography>

          {/* Author and Category */}
          <Stack
            direction={{ xs: "column", sm: "row" }}
            alignItems={{ xs: "flex-start", sm: "center" }}
            spacing={2}
            sx={{ mb: 2 }}
          >
            <Stack direction="row" alignItems="center" spacing={1}>
              <Avatar
                src={article.authorProfilePic || ""}
                alt={article.authorName || "Unknown Author"}
                sx={{
                  width: 44,
                  height: 44,
                  border: `2px solid ${colors.deepPurple}`,
                }}
              >
                <PersonIcon />
              </Avatar>
              <Box>
                <Typography
                  variant="subtitle1"
                  sx={{ fontWeight: 600, color: colors.calmNavy }}
                >
                  {article.authorName || "Unknown Author"}
                </Typography>
                <Typography variant="caption" sx={{ color: colors.calmNavy, opacity: 0.7 }}>
                  {formatDate(article.createdAt)}
                </Typography>
              </Box>
            </Stack>

            {article.categoryName && (
              <Chip
                label={article.categoryName}
                sx={{
                  bgcolor: colors.lightSkyBlue,
                  color: colors.calmNavy,
                  fontWeight: 600,
                  fontSize: 13,
                }}
              />
            )}
          </Stack>

          {/* Banner Image */}
          {article.articleImg && article.articleImg.trim() !== "" ? (
            <Box
              sx={{
                position: "relative",
                width: "100%",
                height: { xs: 200, md: 320 },
                borderRadius: 3,
                overflow: "hidden",
                mb: 3,
              }}
            >
              <img
                src={article.articleImg}
                alt={`Banner for ${article.title}`}
                style={{
                  width: "100%",
                  height: "100%",
                  objectFit: "cover",
                }}
                onError={(e) => {
                  e.target.style.display = "none";
                  e.target.parentElement.innerHTML = `
                    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background-color: #F0F0F0; flex-direction: column; gap: 8px;">
                      <div style="font-size: 48px; color: ${colors.calmNavy};">📷</div>
                      <div style="color: ${colors.calmNavy};">Image not available</div>
                    </div>
                  `;
                }}
              />
            </Box>
          ) : (
            <Box
              sx={{
                width: "100%",
                height: { xs: 200, md: 320 },
                borderRadius: 3,
                bgcolor: "#F0F0F0",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                flexDirection: "column",
                gap: 1,
                mb: 3,
                border: `2px dashed ${colors.softLavender}`,
              }}
            >
              <ImageIcon sx={{ fontSize: 48, color: colors.calmNavy, opacity: 0.5 }} />
              <Typography variant="body1" sx={{ color: colors.calmNavy, opacity: 0.7 }}>
                No image available
              </Typography>
            </Box>
          )}

          {/* Like/Unlike and Comment Count */}
          <Stack direction="row" spacing={3} alignItems="center">
            {/* Like Button */}
            <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
              <IconButton
                onClick={handleLike}
                sx={{
                  color: liked ? colors.deepPurple : colors.calmNavy,
                  bgcolor: liked ? colors.softLavender : "transparent",
                  "&:hover": {
                    bgcolor: colors.softLavender,
                  },
                }}
              >
                {liked ? <ThumbUpIcon /> : <ThumbUpOutlinedIcon />}
              </IconButton>
              <Typography
                variant="body2"
                sx={{
                  fontWeight: 600,
                  color: liked ? colors.deepPurple : colors.calmNavy,
                }}
              >
                {likeCount}
              </Typography>
            </Box>

            {/* Unlike Button */}
            <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
              <IconButton
                onClick={handleUnlike}
                sx={{
                  color: unliked ? colors.deepPurple : colors.calmNavy,
                  bgcolor: unliked ? colors.softLavender : "transparent",
                  "&:hover": {
                    bgcolor: colors.softLavender,
                  },
                }}
              >
                {unliked ? <ThumbDownIcon /> : <ThumbDownOutlinedIcon />}
              </IconButton>
              <Typography variant="body2" sx={{ color: colors.calmNavy }}>
                Unlike
              </Typography>
            </Box>

            {/* Comment Count */}
            <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
              <ChatBubbleOutlineIcon sx={{ color: colors.calmNavy }} />
              <Typography variant="body2" sx={{ color: colors.calmNavy }}>
                {comments.length} {comments.length === 1 ? 'comment' : 'comments'}
              </Typography>
            </Box>
          </Stack>
        </Paper>

        {/* Article Content */}
        <Paper
          elevation={3}
          sx={{
            bgcolor: colors.softLavender,
            borderRadius: 3,
            p: { xs: 3, md: 5 },
            mb: 5,
          }}
        >
          <Typography
            variant="h6"
            sx={{
              fontWeight: 600,
              color: colors.deepPurple,
              mb: 2,
            }}
          >
            Article Content
          </Typography>
          <Divider sx={{ mb: 3, borderColor: colors.deepPurple, opacity: 0.3 }} />
          <Typography
            sx={{
              fontSize: 16,
              lineHeight: 1.8,
              color: colors.calmNavy,
              whiteSpace: "pre-line",
              fontFamily: '"Lora", "Georgia", serif',
            }}
          >
            {article.content}
          </Typography>
        </Paper>

        {/* Comments Section */}
        <Paper elevation={3} sx={{ p: 3, borderRadius: 3 }}>
          <Typography
            variant="h5"
            sx={{
              fontWeight: 700,
              color: colors.deepPurple,
              mb: 3,
            }}
          >
            Comments ({comments.length})
          </Typography>

          {/* Comment Input */}
          <Box sx={{ mb: 4 }}>
            <TextField
              fullWidth
              multiline
              rows={3}
              placeholder="Share your thoughts..."
              value={commentText}
              onChange={(e) => setCommentText(e.target.value)}
              variant="outlined"
              sx={{
                mb: 2,
                "& .MuiOutlinedInput-root": {
                  borderRadius: 2,
                },
              }}
            />
            <Button
              variant="contained"
              endIcon={isPostingComment ? <CircularProgress size={20} color="inherit" /> : <SendIcon />}
              onClick={handleAddComment}
              disabled={isPostingComment || !commentText.trim()}
              sx={{
                bgcolor: colors.deepPurple,
                "&:hover": { bgcolor: colors.calmNavy },
                borderRadius: 2,
                px: 3,
              }}
            >
              {isPostingComment ? 'Posting...' : 'Post Comment'}
            </Button>
          </Box>

          {/* Comments List */}
          <Stack spacing={3}>
            {comments.length === 0 ? (
              <Box sx={{ textAlign: "center", py: 4 }}>
                <ChatBubbleOutlineIcon
                  sx={{ fontSize: 64, color: colors.softLavender, mb: 2 }}
                />
                <Typography variant="body1" sx={{ color: colors.calmNavy, opacity: 0.7 }}>
                  No comments yet. Be the first to comment!
                </Typography>
              </Box>
            ) : (
              comments.map((comment) => {
                const replies = commentReplies[comment.id] || [];
                const repliesVisible = showReplies[comment.id] || false;
                
                return (
                  <Box key={comment.id}>
                    <Paper
                      elevation={1}
                      sx={{
                        p: 2,
                        borderRadius: 2,
                        bgcolor: "#fff",
                        border: `1px solid ${colors.softLavender}`,
                      }}
                    >
                      <Stack direction="row" spacing={2}>
                        <Avatar
                          sx={{
                            width: 40,
                            height: 40,
                            bgcolor: colors.lightSkyBlue,
                            color: colors.calmNavy,
                          }}
                        >
                          <PersonIcon />
                        </Avatar>
                        <Box sx={{ flex: 1 }}>
                          <Stack
                            direction="row"
                            justifyContent="space-between"
                            alignItems="center"
                            sx={{ mb: 0.5 }}
                          >
                            <Typography
                              variant="subtitle2"
                              sx={{ fontWeight: 700, color: colors.calmNavy }}
                            >
                              {comment.userName || 'Anonymous'}
                            </Typography>
                            <Typography
                              variant="caption"
                              sx={{ color: colors.calmNavy, opacity: 0.6 }}
                            >
                              {commentService.formatTimestamp(comment.createdAt)}
                            </Typography>
                          </Stack>
                          {comment.userType && (
                            <Chip
                              label={comment.userType}
                              size="small"
                              sx={{
                                bgcolor: colors.lightSkyBlue,
                                color: colors.calmNavy,
                                fontSize: 11,
                                height: 20,
                                mb: 1,
                              }}
                            />
                          )}
                          <Typography
                            variant="body2"
                            sx={{
                              color: colors.calmNavy,
                              whiteSpace: "pre-line",
                              lineHeight: 1.6,
                              mb: 1,
                            }}
                          >
                            {comment.content}
                          </Typography>

                          {/* Reply and View Replies buttons */}
                          <Stack direction="row" spacing={1} alignItems="center">
                            <Button
                              size="small"
                              startIcon={<ReplyIcon />}
                              onClick={() => handleReplyClick(comment.id)}
                              sx={{
                                color: colors.deepPurple,
                                textTransform: 'none',
                                fontSize: 12,
                                '&:hover': { bgcolor: colors.softLavender },
                              }}
                            >
                              Reply
                            </Button>
                            {replies.length > 0 && (
                              <Button
                                size="small"
                                onClick={() => toggleReplies(comment.id)}
                                sx={{
                                  color: colors.calmNavy,
                                  textTransform: 'none',
                                  fontSize: 12,
                                  '&:hover': { bgcolor: colors.softLavender },
                                }}
                              >
                                {repliesVisible ? 'Hide' : 'View'} {replies.length} {replies.length === 1 ? 'Reply' : 'Replies'}
                              </Button>
                            )}
                          </Stack>

                          {/* Reply Input */}
                          {replyingTo === comment.id && (
                            <Box sx={{ mt: 2 }}>
                              <Stack direction="row" spacing={1} alignItems="flex-start">
                                <TextField
                                  fullWidth
                                  multiline
                                  rows={2}
                                  placeholder="Write your reply..."
                                  value={replyText}
                                  onChange={(e) => setReplyText(e.target.value)}
                                  size="small"
                                  sx={{
                                    '& .MuiOutlinedInput-root': {
                                      bgcolor: '#f9f9f9',
                                    },
                                  }}
                                />
                                <IconButton
                                  onClick={() => handleAddReply(comment.id)}
                                  disabled={isPostingReply || !replyText.trim()}
                                  sx={{
                                    bgcolor: colors.lightSkyBlue,
                                    color: colors.calmNavy,
                                    '&:hover': { bgcolor: colors.deepPurple, color: '#fff' },
                                    '&:disabled': { bgcolor: colors.softLavender, opacity: 0.5 },
                                  }}
                                >
                                  <SendIcon fontSize="small" />
                                </IconButton>
                                <IconButton
                                  onClick={handleCancelReply}
                                  size="small"
                                  sx={{
                                    color: colors.calmNavy,
                                    '&:hover': { bgcolor: colors.softLavender },
                                  }}
                                >
                                  <CloseIcon fontSize="small" />
                                </IconButton>
                              </Stack>
                            </Box>
                          )}
                        </Box>
                      </Stack>
                    </Paper>

                    {/* Replies */}
                    {repliesVisible && replies.length > 0 && (
                      <Box sx={{ ml: 6, mt: 1 }}>
                        <Stack spacing={1}>
                          {replies.map((reply) => (
                            <Paper
                              key={reply.id}
                              elevation={0}
                              sx={{
                                p: 1.5,
                                borderRadius: 2,
                                bgcolor: '#f9f9f9',
                                border: `1px solid ${colors.softLavender}`,
                              }}
                            >
                              <Stack direction="row" spacing={1.5}>
                                <Avatar
                                  sx={{
                                    width: 32,
                                    height: 32,
                                    bgcolor: colors.softLavender,
                                    color: colors.deepPurple,
                                  }}
                                >
                                  <PersonIcon fontSize="small" />
                                </Avatar>
                                <Box sx={{ flex: 1 }}>
                                  <Stack
                                    direction="row"
                                    justifyContent="space-between"
                                    alignItems="center"
                                    sx={{ mb: 0.5 }}
                                  >
                                    <Typography
                                      variant="caption"
                                      sx={{ fontWeight: 700, color: colors.calmNavy }}
                                    >
                                      {reply.userName || 'Anonymous'}
                                    </Typography>
                                    <Typography
                                      variant="caption"
                                      sx={{ color: colors.calmNavy, opacity: 0.5, fontSize: 10 }}
                                    >
                                      {commentService.formatTimestamp(reply.createdAt)}
                                    </Typography>
                                  </Stack>
                                  {reply.userType && (
                                    <Chip
                                      label={reply.userType}
                                      size="small"
                                      sx={{
                                        bgcolor: colors.lightSkyBlue,
                                        color: colors.calmNavy,
                                        fontSize: 10,
                                        height: 18,
                                        mb: 0.5,
                                      }}
                                    />
                                  )}
                                  <Typography
                                    variant="body2"
                                    sx={{
                                      color: colors.calmNavy,
                                      whiteSpace: "pre-line",
                                      lineHeight: 1.5,
                                      fontSize: 13,
                                    }}
                                  >
                                    {reply.content}
                                  </Typography>
                                </Box>
                              </Stack>
                            </Paper>
                          ))}
                        </Stack>
                      </Box>
                    )}
                  </Box>
                );
              })
            )}
          </Stack>
        </Paper>
      </Container>

      {/* Fixed Comment Input at Bottom (Mobile Optimized) */}
      <Box
        sx={{
          display: { xs: "flex", md: "none" },
          position: "fixed",
          bottom: 0,
          left: 0,
          right: 0,
          bgcolor: "#fff",
          borderTop: `1px solid ${colors.softLavender}`,
          px: 2,
          py: 1.5,
          alignItems: "center",
          gap: 2,
          zIndex: 1600,
        }}
      >
        <TextField
          fullWidth
          placeholder="Add a comment..."
          value={commentText}
          onChange={(e) => setCommentText(e.target.value)}
          size="small"
          variant="outlined"
          sx={{
            "& .MuiOutlinedInput-root": {
              borderRadius: 24,
            },
          }}
          onKeyDown={(e) => {
            if (e.key === "Enter" && !e.shiftKey) {
              e.preventDefault();
              handleAddComment();
            }
          }}
        />
        <IconButton
          onClick={handleAddComment}
          disabled={isPostingComment || !commentText.trim()}
          sx={{
            bgcolor: colors.lightSkyBlue,
            color: colors.calmNavy,
            "&:hover": { bgcolor: colors.deepPurple, color: "#fff" },
            "&:disabled": { bgcolor: colors.softLavender, opacity: 0.5 },
          }}
        >
          <SendIcon />
        </IconButton>
      </Box>
    </Box>
  );
}
