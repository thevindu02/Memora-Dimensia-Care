// src/components/volunteer/EditDraft.js
import React, { useState, useRef, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import {
  Box,
  Typography,
  Container,
  TextField,
  MenuItem,
  FormControl,
  InputLabel,
  Select,
  Button,
  IconButton,
  Tooltip,
  CircularProgress,
  Paper,
  Alert,
  Stack,
  Chip,
  Snackbar,
} from "@mui/material";
import AddPhotoAlternateIcon from "@mui/icons-material/AddPhotoAlternate";
import LinkIcon from "@mui/icons-material/Link";
import SendIcon from "@mui/icons-material/Send";
import SaveIcon from "@mui/icons-material/Save";
import ClearAllIcon from "@mui/icons-material/ClearAll";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";

import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";
import SideBar from "./SideBar";
import articleService from '../../services/articleService';
import authService from '../../services/authService';
import CONFIG from '../../config/api.js';

// Memora color palette constants
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
  backgroundLight: "#F8F9FB",
};

export default function EditDraft() {
  const { id } = useParams();
  const navigate = useNavigate();

  // Form state
  const [category, setCategory] = useState("");
  const [title, setTitle] = useState("");
  const [summary, setSummary] = useState("");
  const [content, setContent] = useState("");
  const [selectedImage, setSelectedImage] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [showUrlInput, setShowUrlInput] = useState(false);
  const [imageUrl, setImageUrl] = useState("");
  
  // Backend state
  const [categories, setCategories] = useState([]);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);
  const [validationErrors, setValidationErrors] = useState({});
  const [currentUser, setCurrentUser] = useState(null);
  const [originalDraft, setOriginalDraft] = useState(null);
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState('');
  const [snackbarSeverity, setSnackbarSeverity] = useState('success');

  // Refs
  const contentRef = useRef(null);

  // Load draft, categories, and user data on component mount
  useEffect(() => {
    loadDraft();
    loadCategories();
    loadCurrentUser();
  }, [id]);

  // Load draft article
  const loadDraft = async () => {
    try {
      setLoading(true);
      setError(null);

      const user = authService.getCurrentUser();
      if (!user || !user.id) {
        setError("User not authenticated. Please log in again.");
        return;
      }

      console.log("Loading draft with ID:", id);
      const response = await articleService.getArticleById(id);

      if (response.success && response.data) {
        const draft = response.data;

        // Verify this draft belongs to the current user
        if (draft.volunteerId !== user.id) {
          setError("You don't have permission to edit this draft.");
          return;
        }

        // Verify it's actually a draft
        if (!draft.draft) {
          setError("This article is not a draft and cannot be edited here.");
          return;
        }

        // Populate form fields
        setOriginalDraft(draft);
        setTitle(draft.title || "");
        setSummary(draft.summary || "");
        setContent(draft.content || "");
        setCategory(draft.categoryId ? draft.categoryId.toString() : "");
        
        if (draft.articleImg && draft.articleImg.trim() !== "") {
          setSelectedImage({
            id: 'existing',
            src: draft.articleImg,
            type: 'url',
            fileName: 'Existing Image'
          });
        }

        console.log("Draft loaded successfully");
      } else {
        setError(response.message || "Failed to load draft article");
      }
    } catch (error) {
      console.error("Error loading draft:", error);
      setError("Failed to load draft article. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  // Load categories from backend
  const loadCategories = async () => {
    try {
      const result = await articleService.getCategories();
      if (result.success) {
        setCategories(result.data);
      } else {
        console.error('Failed to load categories:', result.message);
        setCategories([
          { categoryId: 1, categoryName: "General" },
          { categoryId: 2, categoryName: "Caregiving" },
          { categoryId: 3, categoryName: "Research" },
          { categoryId: 4, categoryName: "Technology" },
        ]);
      }
    } catch (error) {
      console.error('Error loading categories:', error);
      setCategories([
        { categoryId: 1, categoryName: "General" },
        { categoryId: 2, categoryName: "Caregiving" },
        { categoryId: 3, categoryName: "Research" },
        { categoryId: 4, categoryName: "Technology" },
      ]);
    }
  };

  // Load current user data
  const loadCurrentUser = () => {
    const user = authService.getCurrentUser();
    setCurrentUser(user);
  };

  // Clear messages after timeout
  const clearMessages = () => {
    setTimeout(() => {
      setError(null);
      setSuccess(null);
    }, 5000);
  };

  // Handle snackbar close
  const handleSnackbarClose = (event, reason) => {
    if (reason === 'clickaway') {
      return;
    }
    setSnackbarOpen(false);
  };

  // Validate form data
  const validateForm = (isDraft = true) => {
    const errors = {};

    if (!title.trim()) {
      errors.title = 'Title is required';
    } else if (title.trim().length < 5) {
      errors.title = 'Title must be at least 5 characters long';
    }

    if (!isDraft && !content.trim()) {
      errors.content = 'Content is required for publishing';
    } else if (!isDraft && content.trim().length < 50) {
      errors.content = 'Content must be at least 50 characters long';
    }

    if (!category) {
      errors.category = 'Please select a category';
    }

    if (summary && summary.trim().length > 500) {
      errors.summary = 'Summary must be less than 500 characters';
    }

    setValidationErrors(errors);
    return Object.keys(errors).length === 0;
  };

  // Upload image file to backend
  const uploadImageFile = async (file) => {
    try {
      const uploadResult = await articleService.uploadImage(file, 'article');
      
      if (uploadResult.success) {
        return `${CONFIG.API_BASE_URL}${uploadResult.imageUrl}`;
      } else {
        throw new Error(uploadResult.message);
      }
    } catch (error) {
      throw new Error(`Failed to upload image: ${error.message}`);
    }
  };

  // Handle file selection
  const handleFileSelection = (event) => {
    const file = event.target.files[0];
    if (file) {
      if (!file.type.startsWith('image/')) {
        setError('Please select a valid image file');
        clearMessages();
        return;
      }
      
      if (file.size > 5 * 1024 * 1024) {
        setError('Image size should be less than 5MB');
        clearMessages();
        return;
      }

      const previewUrl = URL.createObjectURL(file);
      setSelectedImage({ 
        id: Date.now(), 
        src: previewUrl,
        file: file,
        fileName: file.name,
        type: 'file'
      });
      setSuccess('Image selected! It will be uploaded when you save.');
      clearMessages();
    }
    event.target.value = '';
  };

  // Add image by URL
  const addImageByUrl = () => {
    setShowUrlInput(true);
  };

  // Handle URL input confirmation
  const handleUrlConfirm = () => {
    if (imageUrl.trim()) {
      setSelectedImage({ 
        id: Date.now(), 
        src: imageUrl.trim(), 
        type: 'url',
        fileName: 'External Image'
      });
      setImageUrl("");
      setShowUrlInput(false);
      setSuccess('Image URL added successfully!');
      clearMessages();
    }
  };

  // Handle URL input cancel
  const handleUrlCancel = () => {
    setImageUrl("");
    setShowUrlInput(false);
  };

  // Remove selected image
  const removeSelectedImage = () => {
    if (selectedImage && selectedImage.type === 'file' && selectedImage.src.startsWith('blob:')) {
      URL.revokeObjectURL(selectedImage.src);
    }
    setSelectedImage(null);
  };

  // Handle update draft (save changes)
  const handleUpdateDraft = async () => {
    setError(null);
    setSuccess(null);
    setValidationErrors({});

    if (!validateForm(true)) {
      setError('Please correct the errors below');
      clearMessages();
      return;
    }

    if (!currentUser || !currentUser.id) {
      setError('User information not found. Please sign in again.');
      clearMessages();
      return;
    }

    setSaving(true);

    try {
      // Handle image upload if new file is selected
      let finalImageUrl = '';
      if (selectedImage) {
        if (selectedImage.type === 'file') {
          console.log('Uploading new image file:', selectedImage.fileName);
          finalImageUrl = await uploadImageFile(selectedImage.file);
        } else if (selectedImage.type === 'url') {
          if (selectedImage.id === 'existing') {
            // Keep existing image URL
            finalImageUrl = selectedImage.src;
          } else {
            // Validate new URL
            console.log('Validating new image URL:', selectedImage.src);
            const validation = await articleService.validateImageUrl(selectedImage.src);
            if (validation.success && validation.valid) {
              finalImageUrl = selectedImage.src;
            } else {
              throw new Error(validation.message || 'Invalid image URL');
            }
          }
        }
      }

      // Prepare update data
      const updateData = {
        articleId: id,
        title: title.trim(),
        summary: summary.trim() || articleService.generateSummary(content),
        content: articleService.cleanContent(content),
        categoryId: parseInt(category),
        volunteerId: parseInt(currentUser.id),
        draft: true,
        articleImg: finalImageUrl
      };

      console.log('Updating draft:', updateData);

      // Call update endpoint (we'll create this)
      const result = await articleService.updateArticle(updateData);

      if (result.success) {
        const successMsg = 'Draft updated successfully!';
        setSuccess(successMsg);
        setSnackbarMessage(successMsg);
        setSnackbarSeverity('success');
        setSnackbarOpen(true);
        setTimeout(() => {
          navigate("/ArticleDrafts");
        }, 1500);
      } else {
        setError(result.message);
        setSnackbarMessage(result.message || 'Failed to update draft');
        setSnackbarSeverity('error');
        setSnackbarOpen(true);
      }

    } catch (error) {
      console.error('Error updating draft:', error);
      const errorMsg = 'An unexpected error occurred. Please try again.';
      setError(errorMsg);
      setSnackbarMessage(errorMsg);
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
    } finally {
      setSaving(false);
      clearMessages();
    }
  };

  // Handle publish draft
  const handlePublishDraft = async () => {
    setError(null);
    setSuccess(null);
    setValidationErrors({});

    if (!validateForm(false)) {
      setError('Please correct the errors below before publishing');
      clearMessages();
      return;
    }

    if (!currentUser || !currentUser.id) {
      setError('User information not found. Please sign in again.');
      clearMessages();
      return;
    }

    setSaving(true);

    try {
      // Handle image upload if new file is selected
      let finalImageUrl = '';
      if (selectedImage) {
        if (selectedImage.type === 'file') {
          console.log('Uploading image file:', selectedImage.fileName);
          finalImageUrl = await uploadImageFile(selectedImage.file);
        } else if (selectedImage.type === 'url') {
          if (selectedImage.id === 'existing') {
            finalImageUrl = selectedImage.src;
          } else {
            const validation = await articleService.validateImageUrl(selectedImage.src);
            if (validation.success && validation.valid) {
              finalImageUrl = selectedImage.src;
            } else {
              throw new Error(validation.message || 'Invalid image URL');
            }
          }
        }
      }

      // Prepare publish data
      const publishData = {
        articleId: id,
        title: title.trim(),
        summary: summary.trim() || articleService.generateSummary(content),
        content: articleService.cleanContent(content),
        categoryId: parseInt(category),
        volunteerId: parseInt(currentUser.id),
        draft: false, // Change to published
        articleImg: finalImageUrl
      };

      console.log('Publishing draft:', publishData);

      // Call update endpoint to publish
      const result = await articleService.updateArticle(publishData);

      if (result.success) {
        setSuccess('Draft published successfully!');
        setSnackbarMessage('Article submitted successfully! It will be published after admin approval.');
        setSnackbarSeverity('success');
        setSnackbarOpen(true);
        setTimeout(() => {
          navigate("/PublishedArticles");
        }, 1500);
      } else {
        setError(result.message);
        setSnackbarMessage(result.message || 'Failed to publish article. Please try again.');
        setSnackbarSeverity('error');
        setSnackbarOpen(true);
      }

    } catch (error) {
      console.error('Error publishing draft:', error);
      const errorMsg = 'An unexpected error occurred. Please try again.';
      setError(errorMsg);
      setSnackbarMessage(errorMsg);
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
    } finally {
      setSaving(false);
      clearMessages();
    }
  };

  if (loading) {
    return (
      <>
        <Box sx={{ pl: { md: "260px" }, pt: { xs: "56px", md: "130px" } }}>
          <Container>
            <Box display="flex" justifyContent="center" alignItems="center" minHeight="60vh">
              <CircularProgress color="primary" />
              <Typography variant="body1" sx={{ ml: 2 }}>
                Loading draft...
              </Typography>
            </Box>
          </Container>
        </Box>
      </>
    );
  }

  if (error && !originalDraft) {
    return (
      <>
        <Box sx={{ pl: { md: "260px" }, pt: { xs: "56px", md: "130px" } }}>
          <Container>
            <Alert severity="error" sx={{ mt: 3 }}>
              {error}
              <Button
                size="small"
                onClick={() => navigate("/ArticleDrafts")}
                sx={{ ml: 2 }}
              >
                Back to Drafts
              </Button>
            </Alert>
          </Container>
        </Box>
      </>
    );
  }

  return (
    <>
      {/* Sidebar fixed on left */}
      <SideBar />

      {/* Volunteer Nav at top full width */}
      <VolunteerNav />

      {/* Main content container with left margin for sidebar */}
      <Box
        sx={{
          bgcolor: colors.backgroundLight,
          minHeight: "100vh",
          py: 4,
          px: { xs: 2, sm: 4, md: 6 },
          fontFamily: "Poppins, Lato, Nunito, Arial, sans-serif",
          color: colors.calmNavy,
          ml: { md: "260px" },
          pt: "80px",
          pb: 10,
        }}
      >
        <Container maxWidth="md">
          {/* Header */}
          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              justifyContent: "space-between",
              mb: 4,
              flexWrap: "wrap",
              gap: 2,
            }}
          >
            <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
              <IconButton
                onClick={() => navigate("/ArticleDrafts")}
                sx={{
                  bgcolor: colors.softLavender,
                  color: colors.deepPurple,
                  "&:hover": { bgcolor: colors.deepPurple, color: colors.white },
                }}
              >
                <ArrowBackIcon />
              </IconButton>
              <Typography
                variant="h4"
                sx={{ fontWeight: 700, color: colors.deepPurple }}
              >
                Edit Draft
              </Typography>
              <Chip
                label="DRAFT"
                size="small"
                sx={{
                  bgcolor: colors.lightSkyBlue,
                  color: colors.calmNavy,
                  fontWeight: 700,
                }}
              />
            </Box>
          </Box>

          {/* Error and Success Messages */}
          {error && (
            <Alert severity="error" sx={{ mb: 3 }}>
              {error}
            </Alert>
          )}
          
          {success && (
            <Alert severity="success" sx={{ mb: 3 }}>
              {success}
            </Alert>
          )}

          {/* Category Select */}
          <FormControl 
            fullWidth 
            sx={{ mb: 3 }}
            error={!!validationErrors.category}
          >
            <InputLabel id="category-label">Category *</InputLabel>
            <Select
              labelId="category-label"
              value={category}
              label="Category *"
              onChange={(e) => setCategory(e.target.value)}
            >
              {categories.map((cat) => (
                <MenuItem key={cat.categoryId} value={cat.categoryId}>
                  {cat.categoryName}
                </MenuItem>
              ))}
            </Select>
            {validationErrors.category && (
              <Typography variant="caption" color="error" sx={{ mt: 0.5 }}>
                {validationErrors.category}
              </Typography>
            )}
          </FormControl>

          {/* Title Input */}
          <TextField
            fullWidth
            label="Title *"
            variant="outlined"
            placeholder="Enter a captivating title..."
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            error={!!validationErrors.title}
            helperText={validationErrors.title}
            sx={{ mb: 3 }}
          />

          {/* Summary Input */}
          <TextField
            fullWidth
            label="Summary (Optional)"
            variant="outlined"
            placeholder="Briefly describe your article (max 500 characters)..."
            multiline
            rows={3}
            value={summary}
            onChange={(e) => setSummary(e.target.value)}
            error={!!validationErrors.summary}
            helperText={validationErrors.summary || `${summary.length}/500 characters`}
            sx={{ mb: 3 }}
          />

          {/* Article Image Section */}
          <Paper
            elevation={2}
            sx={{
              p: 2,
              mb: 3,
              borderRadius: 2,
              bgcolor: colors.white,
            }}
          >
            <Typography
              variant="subtitle1"
              sx={{ mb: 2, color: colors.deepPurple, fontWeight: 700 }}
            >
              Article Image (Optional)
            </Typography>
            
            {/* Upload Buttons */}
            <Stack direction="row" spacing={2} alignItems="center" mb={2}>
              <input
                accept="image/*"
                style={{ display: 'none' }}
                id="image-upload-input"
                type="file"
                onChange={handleFileSelection}
              />
              <label htmlFor="image-upload-input">
                <Button
                  variant="outlined"
                  component="span"
                  startIcon={<AddPhotoAlternateIcon />}
                  sx={{ textTransform: "none" }}
                >
                  Upload Image
                </Button>
              </label>
              <Button
                variant="outlined"
                startIcon={<LinkIcon />}
                onClick={addImageByUrl}
                sx={{ textTransform: "none" }}
              >
                Add URL
              </Button>
            </Stack>

            {/* URL Input Dialog */}
            {showUrlInput && (
              <Box sx={{ mb: 2, p: 2, bgcolor: colors.backgroundLight, borderRadius: 1 }}>
                <TextField
                  fullWidth
                  size="small"
                  label="Image URL"
                  value={imageUrl}
                  onChange={(e) => setImageUrl(e.target.value)}
                  placeholder="https://example.com/image.jpg"
                  sx={{ mb: 1 }}
                />
                <Stack direction="row" spacing={1}>
                  <Button size="small" onClick={handleUrlConfirm} variant="contained">
                    Add
                  </Button>
                  <Button size="small" onClick={handleUrlCancel}>
                    Cancel
                  </Button>
                </Stack>
              </Box>
            )}

            {/* Image Preview */}
            {selectedImage && (
              <Box sx={{ position: 'relative', display: 'inline-block' }}>
                <img
                  src={selectedImage.src}
                  alt="Preview"
                  style={{
                    maxWidth: '100%',
                    maxHeight: 200,
                    borderRadius: 8,
                    objectFit: 'cover'
                  }}
                />
                <IconButton
                  size="small"
                  onClick={removeSelectedImage}
                  sx={{
                    position: 'absolute',
                    top: 8,
                    right: 8,
                    bgcolor: 'rgba(255,255,255,0.9)',
                    '&:hover': { bgcolor: 'rgba(255,255,255,1)' }
                  }}
                >
                  <ClearAllIcon />
                </IconButton>
              </Box>
            )}
          </Paper>

          {/* Content Editor */}
          <Paper
            elevation={2}
            sx={{
              p: 2,
              mb: 3,
              borderRadius: 2,
              bgcolor: colors.white,
            }}
          >
            <Typography
              variant="subtitle1"
              sx={{ mb: 2, color: colors.deepPurple, fontWeight: 700 }}
            >
              Content *
            </Typography>
            
            <TextField
              fullWidth
              multiline
              rows={15}
              variant="outlined"
              placeholder="Write your article content here..."
              value={content}
              onChange={(e) => setContent(e.target.value)}
              error={!!validationErrors.content}
              helperText={validationErrors.content}
              sx={{
                '& .MuiInputBase-root': {
                  fontFamily: '"Lora", serif',
                  fontSize: 16,
                  lineHeight: 1.7,
                }
              }}
            />
          </Paper>

          {/* Action Buttons */}
          <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2}>
            <Button
              variant="contained"
              size="large"
              startIcon={saving ? <CircularProgress size={20} color="inherit" /> : <SaveIcon />}
              onClick={handleUpdateDraft}
              disabled={saving}
              sx={{
                bgcolor: colors.deepPurple,
                "&:hover": { bgcolor: colors.calmNavy },
                textTransform: "none",
                fontWeight: 600,
                flex: 1,
              }}
            >
              {saving ? 'Saving...' : 'Save Draft'}
            </Button>
            
            <Button
              variant="contained"
              size="large"
              startIcon={saving ? <CircularProgress size={20} color="inherit" /> : <SendIcon />}
              onClick={handlePublishDraft}
              disabled={saving}
              sx={{
                bgcolor: colors.lightSkyBlue,
                color: colors.calmNavy,
                "&:hover": { bgcolor: colors.calmNavy, color: colors.white },
                textTransform: "none",
                fontWeight: 600,
                flex: 1,
              }}
            >
              {saving ? 'Publishing...' : 'Publish'}
            </Button>

            <Button
              variant="outlined"
              size="large"
              onClick={() => navigate("/ArticleDrafts")}
              disabled={saving}
              sx={{
                textTransform: "none",
                fontWeight: 600,
              }}
            >
              Cancel
            </Button>
          </Stack>
        </Container>
      </Box>

      <Box sx={{ pl: { md: "260px" } }}>
        <Footer />
      </Box>

      <Snackbar
        open={snackbarOpen}
        autoHideDuration={6000}
        onClose={handleSnackbarClose}
        anchorOrigin={{ vertical: 'top', horizontal: 'center' }}
      >
        <Alert 
          onClose={handleSnackbarClose} 
          severity={snackbarSeverity} 
          sx={{ 
            width: '100%', 
            fontSize: '16px', 
            fontWeight: 600, 
            boxShadow: 3 
          }}
        >
          {snackbarMessage}
        </Alert>
      </Snackbar>
    </>
  );
}
