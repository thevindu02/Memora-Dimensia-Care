// src/components/volunteers/CreateBlog.js
import React, { useState, useRef, useEffect } from "react";
import {
  Box,
  Typography,
  Container,
  TextField,
  MenuItem,
  FormControl,
  InputLabel,
  Select,
  Chip,
  Stack,
  Button,
  IconButton,
  Tooltip,
  CircularProgress,
  Divider,
  Paper,
  Alert,
  Snackbar,
} from "@mui/material";
import AddPhotoAlternateIcon from "@mui/icons-material/AddPhotoAlternate";
import LinkIcon from "@mui/icons-material/Link";
import BoldIcon from "@mui/icons-material/FormatBold";
import ItalicIcon from "@mui/icons-material/FormatItalic";
import UnderlineIcon from "@mui/icons-material/FormatUnderlined";
import FormatListBulletedIcon from "@mui/icons-material/FormatListBulleted";
import FormatListNumberedIcon from "@mui/icons-material/FormatListNumbered";
import ClearAllIcon from "@mui/icons-material/ClearAll";
import SendIcon from "@mui/icons-material/Send";
import SaveIcon from "@mui/icons-material/Save";
import DeleteIcon from "@mui/icons-material/Delete";
import MenuIcon from "@mui/icons-material/Menu";

import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";
import SideBar from "./SideBar";
import articleService from '../../services/articleService';
import authService from '../../services/authService';
import VolunteerService from '../../services/volunteerService';
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

// Toolbar button helper
const ToolbarButton = ({ label, IconComp, active, onClick, disabled }) => (
  <Tooltip title={label} arrow>
    <IconButton
      size="small"
      onClick={onClick}
      disabled={disabled}
      aria-pressed={active}
      sx={{
        color: active ? colors.deepPurple : colors.calmNavy,
        bgcolor: active ? colors.softLavender : "transparent",
        borderRadius: 1,
        mx: 0.25,
        transition: "background-color 0.3s ease",
        "&:hover": {
          bgcolor: colors.softLavender,
          color: colors.deepPurple,
        },
      }}
    >
      <IconComp />
    </IconButton>
  </Tooltip>
);

export default function CreateBlog() {
  // Form state
  const [category, setCategory] = useState("");
  const [title, setTitle] = useState("");
  const [summary, setSummary] = useState("");
  const [tags, setTags] = useState([]);
  const [tagInput, setTagInput] = useState("");
  const [content, setContent] = useState("");
  const [selectedImage, setSelectedImage] = useState(null);
  const [loading, setLoading] = useState(false);
  const [showUrlInput, setShowUrlInput] = useState(false);
  const [imageUrl, setImageUrl] = useState("");
  
  // Backend state
  const [categories, setCategories] = useState([]);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(null);
  const [validationErrors, setValidationErrors] = useState({});
  const [currentUser, setCurrentUser] = useState(null);
  const [userVolunteerId, setUserVolunteerId] = useState(null);
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMessage, setSnackbarMessage] = useState('');
  const [snackbarSeverity, setSnackbarSeverity] = useState('success');

  // Rich text formatting states
  const [boldActive, setBoldActive] = useState(false);
  const [italicActive, setItalicActive] = useState(false);
  const [underlineActive, setUnderlineActive] = useState(false);
  const [bulletListActive, setBulletListActive] = useState(false);
  const [numberedListActive, setNumberedListActive] = useState(false);

  // Refs
  const contentRef = useRef(null);

  // Load categories and user data on component mount
  useEffect(() => {
    loadCategories();
    loadCurrentUser();
  }, []);

  // Load categories from backend
  const loadCategories = async () => {
    try {
      const result = await articleService.getCategories();
      if (result.success) {
        setCategories(result.data);
      } else {
        console.error('Failed to load categories:', result.message);
        // Fallback to dummy categories if backend fails
        setCategories([
          { categoryId: 1, categoryName: "General" },
          { categoryId: 2, categoryName: "Caregiving" },
          { categoryId: 3, categoryName: "Research" },
          { categoryId: 4, categoryName: "Technology" },
        ]);
      }
    } catch (error) {
      console.error('Error loading categories:', error);
      // Fallback to dummy categories
      setCategories([
        { categoryId: 1, categoryName: "General" },
        { categoryId: 2, categoryName: "Caregiving" },
        { categoryId: 3, categoryName: "Research" },
        { categoryId: 4, categoryName: "Technology" },
      ]);
    }
  };

  // Load current user data
  const loadCurrentUser = async () => {
    try {
      const user = authService.getCurrentUser();
      setCurrentUser(user);
      
      if (user && user.id) {
        // Get the volunteer ID for this user
        console.log("🔍 Fetching volunteer ID for user ID:", user.id);
        const volunteerResponse = await VolunteerService.getVolunteerIdByUserId(user.id);
        
        if (volunteerResponse.success && volunteerResponse.volunteerId) {
          setUserVolunteerId(volunteerResponse.volunteerId);
          console.log("✅ User's volunteer ID:", volunteerResponse.volunteerId);
        } else {
          console.error("❌ Failed to get volunteer ID:", volunteerResponse.message);
        }
      }
    } catch (error) {
      console.error("❌ Error loading user data:", error);
    }
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
  const validateForm = (isDraft = false) => {
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

  // Handler: Add tag on Enter or comma or Tab
  const handleTagInputKeyDown = (e) => {
    if (e.key === "Enter" || e.key === "," || e.key === "Tab") {
      e.preventDefault();
      const newTag = tagInput.trim();
      if (newTag && !tags.includes(newTag)) {
        setTags((prev) => [...prev, newTag]);
      }
      setTagInput("");
    }
  };

  // Remove tag
  const handleTagDelete = (tagToDelete) => {
    setTags((tags) => tags.filter((tag) => tag !== tagToDelete));
  };

  // Toggle formatting button state
  const toggleFormat = (formatType) => {
    switch (formatType) {
      case "bold":
        setBoldActive((b) => !b);
        break;
      case "italic":
        setItalicActive((i) => !i);
        break;
      case "underline":
        setUnderlineActive((u) => !u);
        break;
      case "bullet":
        setBulletListActive((b) => !b);
        if (numberedListActive) setNumberedListActive(false);
        break;
      case "numbered":
        setNumberedListActive((n) => !n);
        if (bulletListActive) setBulletListActive(false);
        break;
      default:
        break;
    }
  };

  // Add image by URL
  const addImageByUrl = () => {
    setShowUrlInput(true);
  };

  // Handle URL input confirmation
  const handleUrlConfirm = () => {
    if (imageUrl.trim()) {
      // Just set the URL, don't upload yet
      setSelectedImage({ 
        id: Date.now(), 
        src: imageUrl.trim(), 
        type: 'url',
        fileName: 'External Image'
      });
      setImageUrl("");
      setShowUrlInput(false);
      setSuccess('Image URL added successfully! It will be saved when you publish/save draft.');
      clearMessages();
    }
  };

  // Handle URL input cancel
  const handleUrlCancel = () => {
    setImageUrl("");
    setShowUrlInput(false);
  };

  // Handle file selection (not upload yet)
  const handleFileSelection = (event) => {
    const file = event.target.files[0];
    if (file) {
      // Validate file
      if (!file.type.startsWith('image/')) {
        setError('Please select a valid image file');
        clearMessages();
        return;
      }
      
      if (file.size > 5 * 1024 * 1024) { // 5MB limit
        setError('Image size should be less than 5MB');
        clearMessages();
        return;
      }

      // Create preview URL and store file for later upload
      const previewUrl = URL.createObjectURL(file);
      setSelectedImage({ 
        id: Date.now(), 
        src: previewUrl,
        file: file,
        fileName: file.name,
        type: 'file'
      });
      setSuccess('Image selected! It will be uploaded when you publish/save draft.');
      clearMessages();
    }
    // Clear the input value to allow re-selecting the same file
    event.target.value = '';
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

  // Remove selected image
  const removeSelectedImage = () => {
    if (selectedImage && selectedImage.type === 'file' && selectedImage.src.startsWith('blob:')) {
      // Clean up blob URL
      URL.revokeObjectURL(selectedImage.src);
    }
    setSelectedImage(null);
  };

  // Remove image thumbnail
  const removeImage = (id) => {
    setSelectedImage(null);
  };

  // Clear form
  const clearForm = () => {
    setCategory("");
    setTitle("");
    setSummary("");
    setTags([]);
    setTagInput("");
    setContent("");
    setSelectedImage(null);
    setShowUrlInput(false);
    setImageUrl("");
    setBoldActive(false);
    setItalicActive(false);
    setUnderlineActive(false);
    setBulletListActive(false);
    setNumberedListActive(false);
    setValidationErrors({});
    setError(null);
    setSuccess(null);
  };

  // Handle article submission (publish)
  const handlePublish = async () => {
    setError(null);
    setSuccess(null);
    setValidationErrors({});

    // Validate form for publishing
    if (!validateForm(false)) {
      setError('Please correct the errors below');
      clearMessages();
      return;
    }

    if (!currentUser || !currentUser.id) {
      setError('User information not found. Please sign in again.');
      clearMessages();
      return;
    }

    setLoading(true);

    try {
      // Handle image upload if file is selected
      let finalImageUrl = '';
      if (selectedImage) {
        if (selectedImage.type === 'file') {
          // Upload file to backend
          console.log('Uploading image file:', selectedImage.fileName);
          finalImageUrl = await uploadImageFile(selectedImage.file);
        } else if (selectedImage.type === 'url') {
          // Validate URL with backend
          console.log('Validating image URL:', selectedImage.src);
          const validation = await articleService.validateImageUrl(selectedImage.src);
          if (validation.success && validation.valid) {
            finalImageUrl = selectedImage.src;
          } else {
            throw new Error(validation.message || 'Invalid image URL');
          }
        }
      }

      // Prepare article data
      const articleData = {
        title: title.trim(),
        summary: summary.trim() || articleService.generateSummary(content),
        content: articleService.cleanContent(content),
        categoryId: parseInt(category),
        volunteerId: userVolunteerId || parseInt(currentUser.id), // Use userVolunteerId (actual volunteer ID)
        draft: false,
        articleImg: finalImageUrl
      };

      console.log('Submitting article for publication:', articleData);

      // Submit article
      const result = await articleService.createArticle(articleData);

      if (result.success) {
        const successMsg = 'Article submitted successfully! It will be published after admin approval.';
        setSuccess(successMsg);
        setSnackbarMessage(successMsg);
        setSnackbarSeverity('success');
        setSnackbarOpen(true);
        clearForm();
        console.log('Article published successfully:', result.data);
      } else {
        setError(result.message);
        setSnackbarMessage(result.message || 'Failed to publish article');
        setSnackbarSeverity('error');
        setSnackbarOpen(true);
      }

    } catch (error) {
      console.error('Error publishing article:', error);
      const errorMsg = 'An unexpected error occurred. Please try again.';
      setError(errorMsg);
      setSnackbarMessage(errorMsg);
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
    } finally {
      setLoading(false);
      clearMessages();
    }
  };

  // Handle save as draft
  const handleSaveDraft = async () => {
    setError(null);
    setSuccess(null);
    setValidationErrors({});

    // Validate form for draft (less strict)
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

    setLoading(true);

    try {
      // Handle image upload if file is selected
      let finalImageUrl = '';
      if (selectedImage) {
        if (selectedImage.type === 'file') {
          // Upload file to backend
          console.log('Uploading image file for draft:', selectedImage.fileName);
          finalImageUrl = await uploadImageFile(selectedImage.file);
        } else if (selectedImage.type === 'url') {
          // Validate URL with backend
          console.log('Validating image URL for draft:', selectedImage.src);
          const validation = await articleService.validateImageUrl(selectedImage.src);
          if (validation.success && validation.valid) {
            finalImageUrl = selectedImage.src;
          } else {
            throw new Error(validation.message || 'Invalid image URL');
          }
        }
      }

      // Prepare article data for draft
      const articleData = {
        title: title.trim(),
        summary: summary.trim() || articleService.generateSummary(content),
        content: articleService.cleanContent(content),
        categoryId: parseInt(category),
        volunteerId: userVolunteerId || parseInt(currentUser.id), // Use userVolunteerId (actual volunteer ID)
        draft: true,
        articleImg: finalImageUrl
      };

      console.log('Saving article as draft:', articleData);

      // Save as draft
      const result = await articleService.createArticle(articleData);

      if (result.success) {
        const successMsg = 'Draft saved successfully! You can edit it anytime from the Drafts section.';
        setSuccess(successMsg);
        setSnackbarMessage(successMsg);
        setSnackbarSeverity('success');
        setSnackbarOpen(true);
        clearForm();
        console.log('Draft saved successfully:', result.data);
      } else {
        setError(result.message);
        setSnackbarMessage(result.message || 'Failed to save draft');
        setSnackbarSeverity('error');
        setSnackbarOpen(true);
      }

    } catch (error) {
      console.error('Error saving draft:', error);
      const errorMsg = 'An unexpected error occurred. Please try again.';
      setError(errorMsg);
      setSnackbarMessage(errorMsg);
      setSnackbarSeverity('error');
      setSnackbarOpen(true);
    } finally {
      setLoading(false);
      clearMessages();
    }
  };

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
          ml: { md: "260px" }, // Shift right for sidebar on medium and up
          pt: "50px", // top padding to avoid nav overlap on md up
          pb: 10, // bottom padding for visual comfort / footer space
        }}
      >
        <Container maxWidth="md">
          {/* App Bar */}
          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              mb: 4,
              gap: 2,
            }}
          >
            <Typography
              variant="h4"
              sx={{ flexGrow: 1, fontWeight: 700, color: colors.deepPurple }}
            >
              Write Blog
            </Typography>
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

          {/* Article Image Section */}
          <Paper
            elevation={2}
            sx={{
              p: 2,
              mb: 5,
              borderRadius: 2,
              bgcolor: colors.white,
              boxShadow: `0 4px 12px ${colors.softLavender}aa`,
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
                  sx={{
                    textTransform: "none",
                    color: colors.calmNavy,
                    borderColor: colors.lightSkyBlue,
                    "&:hover": {
                      bgcolor: colors.lightSkyBlue,
                      color: colors.white,
                    },
                  }}
                >
                  Choose Image
                </Button>
              </label>
              <Button
                variant="outlined"
                startIcon={<LinkIcon />}
                onClick={addImageByUrl}
                sx={{
                  textTransform: "none",
                  color: colors.calmNavy,
                  borderColor: colors.lightSkyBlue,
                  "&:hover": {
                    bgcolor: colors.lightSkyBlue,
                    color: colors.white,
                  },
                }}
              >
                Add URL
              </Button>
            </Stack>

            {/* URL Input Field */}
            {showUrlInput && (
              <Box sx={{ mb: 2 }}>
                <TextField
                  fullWidth
                  label="Image URL"
                  placeholder="Enter image URL (e.g., https://example.com/image.jpg)"
                  value={imageUrl}
                  onChange={(e) => setImageUrl(e.target.value)}
                  variant="outlined"
                  sx={{
                    mb: 1,
                    "& .MuiOutlinedInput-root": {
                      "& fieldset": { borderColor: colors.softLavender },
                      "&:hover fieldset": { borderColor: colors.deepPurple },
                    },
                  }}
                />
                <Stack direction="row" spacing={1}>
                  <Button
                    variant="contained"
                    size="small"
                    onClick={handleUrlConfirm}
                    disabled={!imageUrl.trim()}
                    sx={{
                      bgcolor: colors.calmNavy,
                      "&:hover": { bgcolor: colors.deepPurple },
                      "&:disabled": { bgcolor: colors.softLavender },
                    }}
                  >
                    Add Image
                  </Button>
                  <Button
                    variant="outlined"
                    size="small"
                    onClick={handleUrlCancel}
                    sx={{
                      color: colors.calmNavy,
                      borderColor: colors.softLavender,
                      "&:hover": { borderColor: colors.calmNavy },
                    }}
                  >
                    Cancel
                  </Button>
                </Stack>
              </Box>
            )}

            {/* Selected Image Preview */}
            <Box sx={{ mt: 2 }}>
              {!selectedImage && (
                <Typography
                  variant="caption"
                  color={colors.softLavender}
                  sx={{ fontStyle: "italic" }}
                >
                  No image selected
                </Typography>
              )}
              
              {selectedImage && (
                <Box
                  sx={{
                    position: "relative",
                    width: "100%",
                    maxWidth: 400,
                    height: 200,
                    borderRadius: 2,
                    overflow: "hidden",
                    boxShadow: `0 0 12px ${colors.calmNavy}33`,
                    bgcolor: colors.backgroundLight,
                  }}
                >
                  <img
                    src={selectedImage.src}
                    alt="Selected article image"
                    style={{
                      width: "100%",
                      height: "100%",
                      objectFit: "cover",
                      userSelect: "none",
                    }}
                    draggable={false}
                    onError={(e) => {
                      e.target.style.display = 'none';
                      e.target.nextSibling.style.display = 'flex';
                    }}
                  />
                  {/* Error placeholder */}
                  <Box
                    sx={{
                      position: 'absolute',
                      top: 0,
                      left: 0,
                      width: '100%',
                      height: '100%',
                      bgcolor: colors.softLavender,
                      display: 'none',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontSize: '14px',
                      color: colors.calmNavy,
                      textAlign: 'center',
                    }}
                  >
                    Failed to load image
                  </Box>
                  <IconButton
                    size="small"
                    onClick={removeSelectedImage}
                    sx={{
                      position: "absolute",
                      top: 8,
                      right: 8,
                      bgcolor: "rgba(255,255,255,0.9)",
                      "&:hover": { bgcolor: colors.deepPurple, color: colors.white },
                    }}
                    aria-label="Remove image"
                  >
                    <DeleteIcon fontSize="small" />
                  </IconButton>
                </Box>
              )}
              
              {selectedImage && (
                <Typography
                  variant="caption"
                  sx={{ mt: 1, color: colors.calmNavy, fontStyle: "italic", display: 'block' }}
                >
                  Selected: {selectedImage.fileName}
                </Typography>
              )}
            </Box>
          </Paper>

          {/* Category Selector */}
          <FormControl fullWidth variant="outlined" sx={{ mb: 4 }} error={!!validationErrors.category}>
            <InputLabel id="category-label" sx={{ color: colors.calmNavy }}>
              Category *
            </InputLabel>
            <Select
              labelId="category-label"
              value={category}
              onChange={(e) => {
                setCategory(e.target.value);
                if (validationErrors.category) {
                  setValidationErrors(prev => ({ ...prev, category: null }));
                }
              }}
              label="Category *"
              sx={{
                "& .MuiSelect-select": { color: colors.calmNavy },
                "& fieldset": { borderColor: colors.softLavender },
                "&:hover fieldset": { borderColor: colors.deepPurple },
              }}
            >
              {categories.map((cat) => (
                <MenuItem key={cat.categoryId} value={cat.categoryId}>
                  {cat.categoryName}
                </MenuItem>
              ))}
            </Select>
            {validationErrors.category && (
              <Typography variant="caption" color="error" sx={{ mt: 0.5, ml: 1 }}>
                {validationErrors.category}
              </Typography>
            )}
          </FormControl>

          {/* Title Field */}
          <TextField
            label="Title *"
            variant="outlined"
            fullWidth
            sx={{ mb: 4 }}
            value={title}
            onChange={(e) => {
              setTitle(e.target.value);
              if (validationErrors.title) {
                setValidationErrors(prev => ({ ...prev, title: null }));
              }
            }}
            error={!!validationErrors.title}
            helperText={validationErrors.title}
            InputProps={{
              sx: {
                color: colors.calmNavy,
              },
            }}
          />

          {/* Summary Field */}
          <TextField
            label="Summary (Optional)"
            variant="outlined"
            fullWidth
            multiline
            minRows={2}
            maxRows={4}
            sx={{ mb: 4 }}
            value={summary}
            onChange={(e) => {
              setSummary(e.target.value);
              if (validationErrors.summary) {
                setValidationErrors(prev => ({ ...prev, summary: null }));
              }
            }}
            error={!!validationErrors.summary}
            helperText={validationErrors.summary || "Brief description of your blog post (auto-generated if left empty)"}
            InputProps={{
              sx: {
                color: colors.calmNavy,
              },
            }}
          />

          {/* Tags Field */}
          <Box sx={{ mb: 4 }}>
            <TextField
              label="Tags"
              variant="outlined"
              fullWidth
              placeholder="Add tags, press Enter"
              value={tagInput}
              onChange={(e) => setTagInput(e.target.value)}
              onKeyDown={handleTagInputKeyDown}
              InputProps={{
                startAdornment: (
                  <Box
                    sx={{
                      mr: 1,
                      display: "flex",
                      alignItems: "center",
                      color: colors.calmNavy,
                    }}
                  >
                    <Typography variant="body1" component="span" sx={{ mr: 0.5 }}>
                      #
                    </Typography>
                  </Box>
                ),
                sx: {
                  color: colors.calmNavy,
                },
              }}
            />
            {/* Tags chips */}
            <Stack direction="row" spacing={1} mt={1} flexWrap="wrap">
              {tags.map((tag) => (
                <Chip
                  key={tag}
                  label={tag}
                  onDelete={() => handleTagDelete(tag)}
                  sx={{
                    bgcolor: colors.lightSkyBlue,
                    color: colors.deepPurple,
                    fontWeight: "600",
                    borderRadius: 2,
                  }}
                />
              ))}
            </Stack>
          </Box>

          {/* Content Rich Text Area */}
          <Box sx={{ mb: 2 }}>
            {/* Toolbar */}
            <Paper
              elevation={2}
              sx={{
                display: "flex",
                alignItems: "center",
                gap: 1,
                p: 1,
                borderRadius: 2,
                mb: 1,
                bgcolor: colors.white,
              }}
            >
              <ToolbarButton
                label="Bold"
                IconComp={BoldIcon}
                active={boldActive}
                onClick={() => toggleFormat("bold")}
              />
              <ToolbarButton
                label="Italic"
                IconComp={ItalicIcon}
                active={italicActive}
                onClick={() => toggleFormat("italic")}
              />
              <ToolbarButton
                label="Underline"
                IconComp={UnderlineIcon}
                active={underlineActive}
                onClick={() => toggleFormat("underline")}
              />
              <Divider orientation="vertical" flexItem sx={{ mx: 1 }} />
              <ToolbarButton
                label="Bullet List"
                IconComp={FormatListBulletedIcon}
                active={bulletListActive}
                onClick={() => toggleFormat("bullet")}
              />
              <ToolbarButton
                label="Numbered List"
                IconComp={FormatListNumberedIcon}
                active={numberedListActive}
                onClick={() => toggleFormat("numbered")}
              />
              <Box sx={{ flexGrow: 1 }} />
              <Tooltip title="Add Image" arrow>
                <IconButton
                  size="small"
                  onClick={() =>
                    alert("Image upload toolbar button clicked (dummy)")
                  }
                  sx={{
                    color: colors.calmNavy,
                    "&:hover": { color: colors.deepPurple },
                  }}
                  aria-label="add image"
                >
                  <AddPhotoAlternateIcon />
                </IconButton>
              </Tooltip>
            </Paper>

            <TextField
              multiline
              minRows={10}
              placeholder="Start writing your blog content here..."
              fullWidth
              variant="outlined"
              value={content}
              inputRef={contentRef}
              onChange={(e) => {
                setContent(e.target.value);
                if (validationErrors.content) {
                  setValidationErrors(prev => ({ ...prev, content: null }));
                }
              }}
              error={!!validationErrors.content}
              helperText={validationErrors.content}
              sx={{
                bgcolor: colors.white,
                borderRadius: 2,
                "& textarea": {
                  fontFamily: "Nunito, Arial, sans-serif",
                  fontWeight: 400,
                  color: colors.calmNavy,
                  ...(boldActive && { fontWeight: "bold" }),
                  ...(italicActive && { fontStyle: "italic" }),
                  ...(underlineActive && { textDecoration: "underline" }),
                  outline: "none",
                },
              }}
            />
          </Box>

          {/* Action Buttons */}
          <Stack direction="row" spacing={3} justifyContent="flex-end" mb={6}>
            <Button
              startIcon={<ClearAllIcon />}
              variant="text"
              onClick={clearForm}
              disabled={loading}
              sx={{ color: colors.calmNavy, fontWeight: 600, fontFamily: "Poppins" }}
            >
              Clear Form
            </Button>
            <Button
              startIcon={loading ? <CircularProgress size={16} /> : <SaveIcon />}
              variant="outlined"
              onClick={handleSaveDraft}
              disabled={loading}
              sx={{
                borderColor: colors.lightSkyBlue,
                color: colors.deepPurple,
                fontWeight: 700,
                fontFamily: "Poppins",
                "&:hover": {
                  bgcolor: colors.lightSkyBlue,
                  color: colors.white,
                  borderColor: colors.lightSkyBlue,
                },
                "&:disabled": {
                  borderColor: colors.softLavender,
                  color: colors.softLavender,
                },
              }}
            >
              {loading ? 'Saving...' : 'Save Draft'}
            </Button>
            <Button
              startIcon={loading ? <CircularProgress size={16} /> : <SendIcon />}
              variant="contained"
              onClick={handlePublish}
              disabled={loading}
              sx={{
                bgcolor: colors.calmNavy,
                color: colors.white,
                fontWeight: 700,
                fontFamily: "Poppins",
                "&:hover": {
                  bgcolor: colors.deepPurple,
                },
                "&:disabled": {
                  bgcolor: colors.softLavender,
                  color: colors.white,
                },
              }}
            >
              {loading ? 'Publishing...' : 'Publish'}
            </Button>
          </Stack>
        </Container>
      </Box>

      {/* Loading Spinner Overlay */}
      {loading && (
        <Box
          sx={{
            position: "fixed",
            inset: 0,
            bgcolor: "rgba(0,0,0,0.1)",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            zIndex: 1500,
          }}
          aria-label="Loading"
          role="alert"
        >
          <CircularProgress size={60} sx={{ color: colors.deepPurple }} />
        </Box>
      )}

      {/* Footer with left padding to align with sidebar */}
      <Box sx={{ pl: { md: "260px" } }}>
        <Footer />
      </Box>

      {/* Success/Error Snackbar */}
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

