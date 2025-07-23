import React from 'react';
import memoraLogo from '../assets/memora.png';

const Footer = () => {
  return (
    <div className="footer" style={{minHeight: '80px', padding: '20px 0'}}>
      <div className="footer-logo">
        <img src={memoraLogo} alt="Memora Logo" className="logo-image" />
        <span className="logo-text">Memora Admin</span>
      </div>
      <div className="footer-links">
        <button type="button" className="footer-link">Privacy Policy</button>
        <button type="button" className="footer-link">Terms of Service</button>
        <button type="button" className="footer-link">Support</button>
      </div>
      <div className="footer-copyright">
        © 2025 Memora Dementiacare Platform. All rights reserved.
      </div>
    </div>
  );
};

export default Footer;
