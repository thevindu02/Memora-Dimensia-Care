import React, { useState, useMemo } from "react";
import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";

// Import MUI icons
import PersonIcon from '@mui/icons-material/Person';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import SearchIcon from '@mui/icons-material/Search';

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  backgroundWhite: "#FFFFFF",
};

const volunteerName = "Alex Morgan";
const volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg";

const categories = ["All", "Awareness", "Daily Tips", "Nutrition", "Stories"];

const exampleArticles = [
  {
    id: 1,
    title: "Understanding Dementia Care Basics",
    description:
      "An introductory overview of dementia care, its challenges and how volunteers can help caregivers at home.",
    author: "Emily Rogers",
    publishedDate: "August 1, 2025",
    thumbnail:
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80",
    category: "Awareness",
    tags: ["Caregiving", "Basics"],
  },
  {
    id: 2,
    title: "5 Tips For Volunteers",
    description:
      "Practical ways to provide meaningful support and communicate effectively with dementia patients.",
    author: "John Doe",
    publishedDate: "July 26, 2025",
    thumbnail:
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=600&q=80",
    category: "Daily Tips",
    tags: ["Volunteering", "Support"],
  },
  {
    id: 3,
    title: "Healthy Nutrition for Dementia",
    description:
      "A guide to balanced diets and food types that can help improve overall wellbeing for dementia patients.",
    author: "Sarah Kim",
    publishedDate: "July 15, 2025",
    thumbnail:
      "https://images.unsplash.com/photo-1526045612212-70caf35c14df?auto=format&fit=crop&w=600&q=80",
    category: "Nutrition",
    tags: ["Diet", "Health"],
  },
];

function ArticleCard({ article }) {
  const [hovered, setHovered] = React.useState(false);

  const iconStyle = {
    fontSize: 16,
    color: colors.calmNavy,
    userSelect: "none",
    verticalAlign: "middle",
  };

  return (
    <article
      tabIndex={0}
      aria-label={`Article titled ${article.title} by ${article.author}`}
      onClick={() => alert(`Open article: ${article.title} (dummy)`)}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          alert(`Open article: ${article.title} (dummy)`);
        }
      }}
      role="button"
      style={{
        borderRadius: 16,
        boxShadow: hovered
          ? `0 10px 25px ${colors.deepPurple}aa`
          : `0 4px 10px ${colors.softLavender}`,
        backgroundColor: "white",
        cursor: "pointer",
        overflow: "hidden",
        display: "flex",
        flexDirection: "column",
        transition: "box-shadow 0.3s ease",
      }}
      onMouseEnter={() => setHovered(true)}
      onMouseLeave={() => setHovered(false)}
    >
      <img
        src={article.thumbnail}
        alt={`Thumbnail for ${article.title}`}
        style={{ width: "100%", aspectRatio: "16 / 9", objectFit: "cover", flexShrink: 0 }}
        loading="lazy"
        draggable={false}
      />
      <div style={{ padding: 16, display: "flex", flexDirection: "column", flexGrow: 1 }}>
        <h2
          style={{
            fontSize: 20,
            fontWeight: 700,
            color: colors.deepPurple,
            marginBottom: 8,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 2,
            WebkitBoxOrient: "vertical",
          }}
        >
          {article.title}
        </h2>
        <p
          style={{
            fontSize: 14,
            color: colors.calmNavy,
            flexGrow: 1,
            marginBottom: 12,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 3,
            WebkitBoxOrient: "vertical",
          }}
        >
          {article.description}
        </p>
        <div
          style={{
            display: "flex",
            justifyContent: "space-between",
            fontSize: 12,
            color: colors.calmNavy,
            userSelect: "none",
          }}
        >
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <PersonIcon style={iconStyle} aria-hidden="true" />
            <span>{article.author}</span>
          </div>
          <div style={{ display: "flex", alignItems: "center", gap: 6 }}>
            <CalendarTodayIcon style={iconStyle} aria-hidden="true" />
            <time dateTime={new Date(article.publishedDate).toISOString()}>{article.publishedDate}</time>
          </div>
        </div>
      </div>
    </article>
  );
}

export default function Articles() {
  const [categoryFilter, setCategoryFilter] = useState("All");
  const [searchTerm, setSearchTerm] = useState("");

  const filteredArticles = useMemo(() => {
    return (exampleArticles || []).filter((article) => {
      const matchCategory = categoryFilter === "All" || article.category === categoryFilter;

      const lowerSearch = searchTerm.toLowerCase();
      const matchSearch =
        article.title.toLowerCase().includes(lowerSearch) ||
        article.description.toLowerCase().includes(lowerSearch) ||
        article.author.toLowerCase().includes(lowerSearch) ||
        article.tags.some((tag) => tag.toLowerCase().includes(lowerSearch));

      return matchCategory && matchSearch;
    });
  }, [categoryFilter, searchTerm]);

  // Responsive padding left based on window width
  const [windowWidth, setWindowWidth] = React.useState(window.innerWidth);
  React.useEffect(() => {
    const handleResize = () => setWindowWidth(window.innerWidth);
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  const pageStyle =
    windowWidth >= 768
      ? {
          fontFamily: `"Poppins", "Lato", "Nunito", Arial, sans-serif`,
          color: colors.calmNavy,
          backgroundColor: colors.backgroundWhite,
          minHeight: "100vh",
          paddingTop: 96, // increased top padding for navbar space
          paddingBottom: 80,
          paddingLeft: 260, // sidebar width space
          paddingRight: 24,
          boxSizing: "border-box",
        }
      : {
          fontFamily: `"Poppins", "Lato", "Nunito", Arial, sans-serif`,
          color: colors.calmNavy,
          backgroundColor: colors.backgroundWhite,
          minHeight: "100vh",
          paddingTop: 96,
          paddingBottom: 80,
          paddingLeft: 24,
          paddingRight: 24,
          boxSizing: "border-box",
        };

  const headerStyles = {
    maxWidth: 1200,
    margin: "auto",
    marginBottom: 40,
    display: "flex",
    flexWrap: "wrap",
    justifyContent: "space-between",
    alignItems: "center",
    gap: 16,
  };

  const titleStyles = {
    fontSize: 32,
    fontWeight: 700,
    color: colors.deepPurple,
    flex: "1 1 300px",
    margin: 0,
  };

  const selectStyles = {
    minWidth: 160,
    fontSize: 16,
    padding: "8px 12px",
    borderRadius: 8,
    border: `1px solid #ccc`,
    color: colors.deepPurple,
    outline: "none",
    cursor: "pointer",
    flex: "0 0 auto",
  };

  const searchContainerStyles = {
    position: "relative",
    flex: "1 1 280px",
    minWidth: 240,
  };

  const searchInputStyles = {
    width: "100%",
    padding: "8px 40px 8px 36px",
    fontSize: 16,
    borderRadius: 8,
    border: `1px solid #ccc`,
    outlineColor: colors.deepPurple,
    boxSizing: "border-box",
  };

  const searchIconStyles = {
    position: "absolute",
    left: 10,
    top: "50%",
    transform: "translateY(-50%)",
    fontSize: 22,
    color: colors.deepPurple,
    userSelect: "none",
    pointerEvents: "none",
  };

  const articlesGridStyles = {
    maxWidth: 1200,
    margin: "auto",
    display: "grid",
    gridTemplateColumns: "repeat(auto-fill, minmax(320px, 1fr))",
    gap: 24,
  };

  const emptyStateStyles = {
    textAlign: "center",
    color: colors.softLavender,
    marginTop: 60,
    userSelect: "none",
  };

  const emptyStateImgStyles = {
    width: 140,
    marginBottom: 16,
    opacity: 0.6,
    pointerEvents: "none",
    userSelect: "none",
  };

  return (
    <>
      {/* Top navigation bar fixed full width */}
      <div
        style={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          zIndex: 1400,
          backgroundColor: colors.backgroundWhite,
          boxShadow: "0 2px 8px rgba(0, 0, 0, 0.1)",
          height: 64,
        }}
      >
        <VolunteerNav />
      </div>

      {/* Sidebar fixed on left */}
      <SideBar
        volunteerName={volunteerName}
        profileImage={volunteerProfileImage}
        onNavigate={(page) => alert(`Navigate to ${page} (dummy)`)}
      />

      {/* Main page container */}
      <main style={pageStyle} role="main" aria-label="Volunteer articles main content">
        <section style={headerStyles}>
          <h1 style={titleStyles}>Explore Articles & Insights</h1>

          {/* Category filter */}
          <select
            aria-label="Filter articles by category"
            style={selectStyles}
            value={categoryFilter}
            onChange={(e) => setCategoryFilter(e.target.value)}
          >
            {categories.map((cat) => (
              <option key={cat} value={cat}>
                {cat}
              </option>
            ))}
          </select>

          {/* Search input */}
          <div style={searchContainerStyles}>
            <input
              type="search"
              aria-label="Search articles, authors, tags"
              placeholder="Search articles, authors, tags..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              style={searchInputStyles}
            />
            <SearchIcon style={searchIconStyles} aria-hidden="true" />
          </div>
        </section>

        {/* Articles list or empty state */}
        {filteredArticles.length > 0 ? (
          <div style={articlesGridStyles}>
            {filteredArticles.map((article) => (
              <ArticleCard key={article.id} article={article} />
            ))}
          </div>
        ) : (
          <div style={emptyStateStyles}>
            <img
              src="https://images.unsplash.com/photo-1535223289827-42f1e9919769?auto=format&fit=crop&w=200&q=80"
              alt="No articles illustration"
              style={emptyStateImgStyles}
              aria-hidden="true"
              draggable={false}
            />
            <p style={{ fontSize: 20, fontWeight: "600" }}>No articles available yet.</p>
          </div>
        )}
      </main>

      {/* Footer */}
      <Footer />
    </>
  );
}


