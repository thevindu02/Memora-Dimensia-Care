// src/components/volunteers/CreateBlog.js
import React, { useState, useRef } from "react";
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
} from "@mui/material";
import AddPhotoAlternateIcon from "@mui/icons-material/AddPhotoAlternate";
import PhotoCameraIcon from "@mui/icons-material/PhotoCamera";
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

// Memora color palette constants
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
  backgroundLight: "#F8F9FB",
};

// Dummy categories
const categories = [
  { value: "general", label: "General" },
  { value: "caregiving", label: "Caregiving" },
  { value: "research", label: "Research" },
  { value: "technology", label: "Technology" },
];

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

export default function CreateBlog({
  volunteerName = "Alex Morgan",
  volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg",
  onNavigate = () => {},
}) {
  // Form state
  const [category, setCategory] = useState("");
  const [title, setTitle] = useState("");
  const [tags, setTags] = useState([]);
  const [tagInput, setTagInput] = useState("");
  const [content, setContent] = useState("");
  const [images, setImages] = useState([]);
  const [loading, setLoading] = useState(false);

  // Rich text formatting states
  const [boldActive, setBoldActive] = useState(false);
  const [italicActive, setItalicActive] = useState(false);
  const [underlineActive, setUnderlineActive] = useState(false);
  const [bulletListActive, setBulletListActive] = useState(false);
  const [numberedListActive, setNumberedListActive] = useState(false);

  // Refs
  const contentRef = useRef(null);

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

  const handleTagDelete = (tagToDelete) => {
    setTags((tags) => tags.filter((tag) => tag !== tagToDelete));
  };

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

  const addImageByUrl = () => {
    const url = window.prompt("Enter image URL");
    if (url) {
      setImages((imgs) => [...imgs, { id: Date.now(), src: url }]);
    }
  };

  const removeImage = (id) => {
    setImages((imgs) => imgs.filter((img) => img.id !== id));
  };

  const clearForm = () => {
    setCategory("");
    setTitle("");
    setTags([]);
    setTagInput("");
    setContent("");
    setImages([]);
    setBoldActive(false);
    setItalicActive(false);
    setUnderlineActive(false);
    setBulletListActive(false);
    setNumberedListActive(false);
  };

  const handlePublish = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      alert("Published! (dummy)");
    }, 2000);
  };

  const handleSaveDraft = () => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      alert("Draft saved! (dummy)");
    }, 1500);
  };

  return (
    <>
      {/* Sidebar fixed on left */}
      <SideBar
        volunteerName={volunteerName}
        profileImage={volunteerProfileImage}
        onNavigate={onNavigate}
      />

      {/* Volunteer Nav at top full width */}
      <VolunteerNav />

      {/* Main content container with left padding for sidebar */}
      <Box
        sx={{
          bgcolor: colors.backgroundLight,
          minHeight: "100vh",
          pl: { md: "260px" }, // sidebar width
          pt: { xs: 2, md: 10 }, // padding top to avoid overlapping with nav
          pb: { xs: 6, md: 8 },
          fontFamily: "Poppins, Lato, Nunito, Arial, sans-serif",
          color: colors.calmNavy,
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
            <Button
              variant="text"
              startIcon={<MenuIcon />}
              sx={{ color: colors.deepPurple, fontWeight: 700 }}
              onClick={() => alert("Go back (dummy)")}
            >
              Back
            </Button>
            <Typography
              variant="h4"
              sx={{ flexGrow: 1, fontWeight: 700, color: colors.deepPurple }}
            >
              Write Blog
            </Typography>
          </Box>

          {/* Optional header/banner image placeholder */}
          <Box
            sx={{
              width: "100%",
              height: 140,
              bgcolor: colors.softLavender,
              borderRadius: 3,
              mb: 5,
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
              color: colors.calmNavy + "aa",
              fontWeight: "bold",
              fontSize: 18,
              userSelect: "none",
            }}
          >
            Header Image Placeholder
          </Box>

          {/* Category Selector */}
          <FormControl fullWidth variant="outlined" sx={{ mb: 4 }}>
            <InputLabel id="category-label" sx={{ color: colors.calmNavy }}>
              Category
            </InputLabel>
            <Select
              labelId="category-label"
              value={category}
              onChange={(e) => setCategory(e.target.value)}
              label="Category"
              sx={{
                "& .MuiSelect-select": { color: colors.calmNavy },
                "& fieldset": { borderColor: colors.softLavender },
                "&:hover fieldset": { borderColor: colors.deepPurple },
              }}
            >
              {categories.map((cat) => (
                <MenuItem key={cat.value} value={cat.value}>
                  {cat.label}
                </MenuItem>
              ))}
            </Select>
          </FormControl>

          {/* Title Field */}
          <TextField
            label="Title"
            variant="outlined"
            fullWidth
            sx={{ mb: 4 }}
            value={title}
            onChange={(e) => setTitle(e.target.value)}
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
                    borderRadius: "16px",
                  }}
                />
              ))}
            </Stack>
          </Box>

          {/* Content Rich Text Area (simulated) */}
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
                  onClick={() => alert("Image upload toolbar button clicked (dummy)")}
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
              onChange={(e) => setContent(e.target.value)}
              sx={{
                bgcolor: colors.white,
                borderRadius: 3,
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

          {/* Image Upload Section */}
          <Paper
            elevation={2}
            sx={{
              p: 2,
              mb: 5,
              borderRadius: 3,
              bgcolor: colors.white,
              boxShadow: `0 4px 12px ${colors.softLavender}aa`,
            }}
          >
            <Typography
              variant="subtitle1"
              sx={{ mb: 1, color: colors.deepPurple, fontWeight: 700 }}
            >
              Upload Images
            </Typography>
            <Stack direction="row" spacing={2} alignItems="center" mb={2}>
              <Button
                variant="outlined"
                startIcon={<AddPhotoAlternateIcon />}
                onClick={() => alert("Choose from gallery (dummy)")}
                sx={{ textTransform: "none", color: colors.calmNavy, borderColor: colors.lightSkyBlue }}
              >
                Choose Gallery
              </Button>
              <Button
                variant="outlined"
                startIcon={<PhotoCameraIcon />}
                onClick={() => alert("Take photo (dummy)")}
                sx={{ textTransform: "none", color: colors.calmNavy, borderColor: colors.lightSkyBlue }}
              >
                Take Photo
              </Button>
              <Button
                variant="outlined"
                startIcon={<LinkIcon />}
                onClick={addImageByUrl}
                sx={{ textTransform: "none", color: colors.calmNavy, borderColor: colors.lightSkyBlue }}
              >
                Add URL
              </Button>
            </Stack>

            {/* Thumbnails */}
            <Box
              sx={{
                display: "flex",
                overflowX: "auto",
                gap: 1,
                pt: 1,
                pb: 0.5,
              }}
            >
              {images.length === 0 && (
                <Typography variant="caption" color={colors.softLavender} sx={{ fontStyle: "italic" }}>
                  No images added
                </Typography>
              )}
              {images.map((img) => (
                <Box
                  key={img.id}
                  sx={{
                    position: "relative",
                    width: 90,
                    height: 70,
                    borderRadius: 2,
                    overflow: "hidden",
                    boxShadow: `0 0 6px ${colors.calmNavy}55`,
                    flexShrink: 0,
                  }}
                >
                  <img
                    src={img.src}
                    alt="Blog upload thumbnail"
                    style={{
                      width: "100%",
                      height: "100%",
                      objectFit: "cover",
                      userSelect: "none",
                    }}
                    draggable={false}
                  />
                  <IconButton
                    size="small"
                    onClick={() => removeImage(img.id)}
                    sx={{
                      position: "absolute",
                      top: 2,
                      right: 2,
                      bgcolor: "rgba(255,255,255,0.8)",
                      ":hover": { bgcolor: colors.deepPurple, color: colors.white },
                    }}
                    aria-label="Remove image"
                  >
                    <DeleteIcon fontSize="small" />
                  </IconButton>
                </Box>
              ))}
            </Box>
          </Paper>

          {/* Action Buttons */}
          <Stack direction="row" spacing={3} justifyContent="flex-end" mb={6}>
            <Button
              startIcon={<ClearAllIcon />}
              variant="text"
              onClick={clearForm}
              sx={{ color: colors.calmNavy, fontWeight: 600, fontFamily: "Poppins" }}
            >
              Clear Form
            </Button>
            <Button
              startIcon={<SaveIcon />}
              variant="outlined"
              onClick={handleSaveDraft}
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
              }}
            >
              Save Draft
            </Button>
            <Button
              startIcon={<SendIcon />}
              variant="contained"
              onClick={handlePublish}
              sx={{
                bgcolor: colors.calmNavy,
                color: colors.white,
                fontWeight: 700,
                fontFamily: "Poppins",
                "&:hover": {
                  bgcolor: colors.deepPurple,
                },
              }}
            >
              Publish
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

      {/* Footer at bottom */}
      <Footer />
    </>
  );
}


