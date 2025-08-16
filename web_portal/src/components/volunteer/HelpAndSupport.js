// src/components/HelpAndSupport.js
import React, { useState } from "react";
import { Box } from "@mui/material";
import {
  IoArrowBackSharp,
  IoMailOutline,
  IoChatboxEllipsesOutline,
  IoSendSharp,
  IoBookOutline,
  IoDocumentTextOutline,
  IoInformationCircleOutline,
  IoHelpCircleOutline,
  IoCheckmarkCircleOutline,
} from "react-icons/io5";
import Footer from "../home/Footer";

const COLORS = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};

const faqs = [
  {
    question: "How do I reset my password?",
    answer:
      "Click on the 'Forgot Password?' link on the Sign In page, then follow the instructions sent to your email.",
  },
  {
    question: "How can I update my profile information?",
    answer:
      "Navigate to your profile settings via the dashboard and update your personal details there.",
  },
  {
    question: "Who do I contact for technical issues?",
    answer:
      "Use the 'Contact Support' quick help card or email support@yourapp.com for assistance.",
  },
];

export default function HelpAndSupport() {
  const [modal, setModal] = useState(null);
  const [faqOpenIndex, setFaqOpenIndex] = useState(null);

  const siteVersion = "1.2.4";
  const lastUpdated = "July 28, 2025";

  // Handlers
  const openModal = (type) => setModal(type);
  const closeModal = () => setModal(null);

  const submitFeedback = () => {
    alert("Feedback sent! Thank you.");
    closeModal();
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        background: `linear-gradient(135deg, ${COLORS.softLavender} 0%, ${COLORS.lightSkyBlue} 100%)`,
        fontFamily: "Poppins, Nunito, Arial, sans-serif",
        display: "flex",
        flexDirection: "column",
        minHeight: "100vh",
      }}
    >
      {/* Header */}
      <Box
        sx={{
          display: "flex",
          alignItems: "center",
          gap: 2,
          px: { xs: 2, sm: 4 },
          pt: { xs: 3, sm: 5 },
          pb: 1,
        }}
      >
        <button
          onClick={() => window.history.back()}
          aria-label="Go back"
          style={{
            border: "none",
            background: COLORS.softLavender,
            color: COLORS.deepPurple,
            borderRadius: "50%",
            width: 44,
            height: 44,
            boxShadow: `0 2px 8px ${COLORS.softLavender}55`,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontSize: 22,
            cursor: "pointer",
            transition: "background 0.2s",
          }}
        >
          <IoArrowBackSharp size={22} />
        </button>
        <h1
          style={{
            fontSize: 36,
            fontWeight: 800,
            color: COLORS.deepPurple,
            letterSpacing: 1,
            margin: 0,
            userSelect: "text",
          }}
        >
          Help & Support
        </h1>
      </Box>

      {/* Main Content */}
      <Box
        sx={{
          flex: 1,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          width: "100%",
        }}
      >
        {/* Hero Banner */}
        <Box
          sx={{
            mt: { xs: 2, md: 4 },
            mb: { xs: 2, md: 3 },
            width: "100%",
            maxWidth: 900,
            bgcolor: "#fff",
            borderRadius: 3,
            boxShadow: `0 8px 32px ${COLORS.softLavender}55`,
            p: { xs: 2, sm: 4 },
            display: "flex",
            alignItems: "center",
            gap: { xs: 2, sm: 4 },
          }}
        >
          <IoInformationCircleOutline
            size={70}
            style={{
              color: COLORS.calmNavy,
              opacity: 0.85,
              flexShrink: 0,
              marginRight: 12,
            }}
            aria-hidden="true"
          />
          <Box>
            <h2
              style={{
                fontSize: 24,
                fontWeight: 700,
                color: COLORS.deepPurple,
                margin: 0,
                marginBottom: 6,
                letterSpacing: 0.5,
              }}
            >
              We&apos;re here to help!
            </h2>
            <p
              style={{
                color: COLORS.calmNavy,
                fontSize: 17,
                margin: 0,
                opacity: 0.95,
                fontWeight: 500,
              }}
            >
              Reach out with any questions or feedback. Explore the resources below or get in touch anytime!
            </p>
          </Box>
        </Box>

        {/* Quick Help */}
        <Box
          sx={{
            width: "100%",
            maxWidth: 900,
            mt: { xs: 2, md: 3 },
            mb: { xs: 2, md: 3 },
          }}
        >
          <h2
            style={{
              fontSize: 22,
              fontWeight: 700,
              color: COLORS.deepPurple,
              marginBottom: 12,
              letterSpacing: 0.5,
            }}
          >
            Quick Help
          </h2>
          <Box
            sx={{
              display: "flex",
              gap: 4,
              flexWrap: "wrap",
              justifyContent: { xs: "center", sm: "flex-start" },
            }}
          >
            {/* Contact Support */}
            <Box
              onClick={() => openModal("contact")}
              tabIndex={0}
              role="button"
              aria-label="Contact Support"
              sx={{
                flex: "1 1 260px",
                minWidth: 260,
                background: "#fff",
                borderRadius: 3,
                boxShadow: `0 4px 16px ${COLORS.softLavender}55`,
                p: 3,
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                cursor: "pointer",
                transition: "background 0.2s, box-shadow 0.2s",
                outline: "none",
                "&:hover": {
                  background: COLORS.softLavender,
                },
              }}
              onKeyDown={(e) => {
                if (e.key === "Enter" || e.key === " ") openModal("contact");
              }}
            >
              <IoMailOutline size={48} style={{ color: COLORS.deepPurple, marginBottom: 12 }} />
              <span
                style={{
                  fontWeight: 700,
                  fontSize: 20,
                  color: COLORS.deepPurple,
                  marginBottom: 6,
                }}
              >
                Contact Support
              </span>
              <span style={{ color: COLORS.calmNavy, opacity: 0.85, fontSize: 15 }}>
                Get help by phone or email
              </span>
            </Box>
            {/* Send Feedback */}
            <Box
              onClick={() => openModal("feedback")}
              tabIndex={0}
              role="button"
              aria-label="Send Feedback"
              sx={{
                flex: "1 1 260px",
                minWidth: 260,
                background: "#fff",
                borderRadius: 3,
                boxShadow: `0 4px 16px ${COLORS.lightSkyBlue}55`,
                p: 3,
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                cursor: "pointer",
                transition: "background 0.2s, box-shadow 0.2s",
                outline: "none",
                "&:hover": {
                  background: COLORS.lightSkyBlue,
                },
              }}
              onKeyDown={(e) => {
                if (e.key === "Enter" || e.key === " ") openModal("feedback");
              }}
            >
              <IoSendSharp size={48} style={{ color: COLORS.deepPurple, marginBottom: 12 }} />
              <span
                style={{
                  fontWeight: 700,
                  fontSize: 20,
                  color: COLORS.deepPurple,
                  marginBottom: 6,
                }}
              >
                Send Feedback
              </span>
              <span style={{ color: COLORS.calmNavy, opacity: 0.85, fontSize: 15 }}>
                Tell us how we can improve
              </span>
            </Box>
          </Box>
        </Box>

        {/* Resources */}
        <Box
          sx={{
            width: "100%",
            maxWidth: 900,
            mt: { xs: 2, md: 3 },
            mb: { xs: 2, md: 3 },
            bgcolor: "#fff",
            borderRadius: 3,
            boxShadow: `0 4px 16px ${COLORS.softLavender}33`,
            p: { xs: 2, sm: 4 },
          }}
        >
          <h2
            style={{
              fontSize: 20,
              fontWeight: 700,
              color: COLORS.deepPurple,
              marginBottom: 18,
              letterSpacing: 0.5,
            }}
          >
            Resources
          </h2>
          <Box sx={{ display: "flex", gap: 4, flexWrap: "wrap" }}>
            <a
              href="#"
              style={{
                flex: "1 1 260px",
                minWidth: 200,
                background: COLORS.softLavender,
                borderRadius: 2,
                boxShadow: `0 2px 8px ${COLORS.softLavender}33`,
                padding: "18px 12px",
                display: "flex",
                alignItems: "center",
                gap: 16,
                textDecoration: "none",
                color: COLORS.deepPurple,
                fontWeight: 600,
                fontSize: 17,
                transition: "background 0.2s, box-shadow 0.2s",
              }}
            >
              <IoBookOutline size={24} style={{ color: COLORS.deepPurple }} />
              User Guide
            </a>
            <a
              href="#"
              style={{
                flex: "1 1 260px",
                minWidth: 200,
                background: COLORS.lightSkyBlue,
                borderRadius: 2,
                boxShadow: `0 2px 8px ${COLORS.lightSkyBlue}33`,
                padding: "18px 12px",
                display: "flex",
                alignItems: "center",
                gap: 16,
                textDecoration: "none",
                color: COLORS.deepPurple,
                fontWeight: 600,
                fontSize: 17,
                transition: "background 0.2s, box-shadow 0.2s",
              }}
            >
              <IoDocumentTextOutline size={24} style={{ color: COLORS.deepPurple }} />
              Terms of Service
            </a>
          </Box>
        </Box>

        {/* FAQ */}
        <Box
          sx={{
            width: "100%",
            maxWidth: 900,
            mt: { xs: 2, md: 3 },
            mb: { xs: 2, md: 3 },
            bgcolor: "#fff",
            borderRadius: 3,
            boxShadow: `0 4px 16px ${COLORS.lightSkyBlue}33`,
            p: { xs: 2, sm: 4 },
          }}
        >
          <h2
            style={{
              fontSize: 20,
              fontWeight: 700,
              color: COLORS.deepPurple,
              marginBottom: 18,
              letterSpacing: 0.5,
            }}
          >
            Frequently Asked Questions
          </h2>
          <Box sx={{ display: "flex", flexDirection: "column", gap: 2 }}>
            {faqs.map((faq, i) => (
              <Box
                key={i}
                sx={{
                  background: COLORS.softLavender,
                  borderRadius: 2,
                  boxShadow: `0 2px 8px ${COLORS.softLavender}33`,
                  p: 2,
                  mb: 1,
                  cursor: "pointer",
                  transition: "background 0.2s",
                  outline: "none",
                }}
                tabIndex={0}
                onClick={() => setFaqOpenIndex(faqOpenIndex === i ? null : i)}
                onKeyDown={(e) => {
                  if (e.key === "Enter" || e.key === " ") setFaqOpenIndex(faqOpenIndex === i ? null : i);
                }}
              >
                <Box sx={{ display: "flex", alignItems: "center", gap: 1 }}>
                  <IoHelpCircleOutline size={20} style={{ color: COLORS.deepPurple }} />
                  <span style={{ fontWeight: 700, color: COLORS.deepPurple, fontSize: 16 }}>
                    {faq.question}
                  </span>
                  <IoCheckmarkCircleOutline
                    size={18}
                    style={{
                      color: COLORS.calmNavy,
                      marginLeft: "auto",
                      opacity: faqOpenIndex === i ? 1 : 0.2,
                      transition: "opacity 0.2s",
                    }}
                    aria-hidden="true"
                  />
                </Box>
                {faqOpenIndex === i && (
                  <Box
                    sx={{
                      color: COLORS.calmNavy,
                      fontSize: 15,
                      mt: 1,
                      fontWeight: 500,
                      pl: 3,
                    }}
                  >
                    {faq.answer}
                  </Box>
                )}
              </Box>
            ))}
          </Box>
        </Box>
      </Box>

      {/* Modal overlays */}
      {modal && (
        <div
          role="dialog"
          aria-modal="true"
          aria-labelledby={`${modal}-modal-title`}
          tabIndex={-1}
          style={{
            position: "fixed",
            inset: 0,
            zIndex: 50,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            background: "#0008",
            backdropFilter: "blur(2px)",
          }}
          onClick={closeModal}
        >
          {/* Modal content */}
          <div
            style={{
              background: "#fff",
              borderRadius: 18,
              boxShadow: `0 8px 32px ${COLORS.deepPurple}33`,
              padding: "36px 32px 28px 32px",
              maxWidth: 400,
              width: "100%",
              position: "relative",
            }}
            onClick={(e) => e.stopPropagation()}
          >
            <button
              aria-label="Close modal"
              onClick={closeModal}
              style={{
                position: "absolute",
                top: 18,
                right: 18,
                background: "none",
                border: "none",
                color: COLORS.deepPurple,
                fontSize: 26,
                cursor: "pointer",
                fontWeight: 700,
              }}
            >
              ×
            </button>

            {modal === "contact" && (
              <>
                <h3
                  id="contact-modal-title"
                  style={{
                    color: COLORS.deepPurple,
                    fontWeight: 700,
                    fontSize: 22,
                    marginBottom: 18,
                  }}
                >
                  Contact Support
                </h3>
                <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 14 }}>
                  <IoMailOutline size={22} style={{ color: COLORS.deepPurple }} />
                  <a
                    href="mailto:support@yourapp.com"
                    style={{
                      color: COLORS.calmNavy,
                      textDecoration: "underline",
                      fontWeight: 600,
                      fontSize: 16,
                    }}
                  >
                    support@yourapp.com
                  </a>
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                  <IoChatboxEllipsesOutline size={22} style={{ color: COLORS.deepPurple }} />
                  <a
                    href="tel:+1234567890"
                    style={{
                      color: COLORS.calmNavy,
                      textDecoration: "underline",
                      fontWeight: 600,
                      fontSize: 16,
                    }}
                  >
                    +1 234 567 890
                  </a>
                </div>
              </>
            )}
            {modal === "feedback" && (
              <>
                <h3
                  id="feedback-modal-title"
                  style={{
                    color: COLORS.deepPurple,
                    fontWeight: 700,
                    fontSize: 22,
                    marginBottom: 18,
                  }}
                >
                  Send Feedback
                </h3>
                <textarea
                  aria-label="Feedback textarea"
                  rows={5}
                  style={{
                    width: "100%",
                    padding: 14,
                    borderRadius: 12,
                    border: `1.5px solid ${COLORS.softLavender}`,
                    fontSize: 15,
                    color: COLORS.calmNavy,
                    fontWeight: 500,
                    marginBottom: 18,
                    outline: "none",
                    resize: "none",
                  }}
                  placeholder="Write your feedback here..."
                  onChange={(e) => {}}
                />
                <button
                  onClick={submitFeedback}
                  style={{
                    width: "100%",
                    borderRadius: 12,
                    padding: "12px 0",
                    background: COLORS.lightSkyBlue,
                    color: COLORS.calmNavy,
                    fontWeight: 700,
                    fontSize: 16,
                    border: "none",
                    boxShadow: `0 2px 8px ${COLORS.lightSkyBlue}33`,
                    cursor: "pointer",
                    transition: "background 0.2s, color 0.2s",
                  }}
                >
                  Send
                </button>
              </>
            )}
          </div>
        </div>
      )}

      {/* Footer */}
      <Box
        sx={{
          width: "100%",
          bgcolor: COLORS.calmNavy,
          mt: { xs: 4, md: 6 },
          pt: 4,
          pb: 2,
        }}
      >
        <Footer />
      </Box>
    </Box>
  );
}
