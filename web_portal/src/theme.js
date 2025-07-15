// src/theme.js
import { createTheme } from '@mui/material/styles';

const theme = createTheme({
  palette: {
    background: {
      default: '#fff',
    },
    primary: {
      main: '#390797', // Deep Purple
      contrastText: '#fff',
    },
    secondary: {
      main: '#A0C4FD', // Light Sky Blue
    },
    accent: {
      main: '#C3B1E1', // Soft Lavender
    },
    info: {
      main: '#2B3F99', // Calm Navy
      contrastText: '#fff',
    },
    deep: {
      main: '#1c1c84', // Deep Navy, 
      contrastText: '#fff',
    },
    text: {
      primary: '#2B3F99',
      secondary: '#390797',
    },
  },
  typography: {
    fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
    h1: { fontWeight: 700 },
    h2: { fontWeight: 600 },
    h3: { fontWeight: 600 },
    h4: { fontWeight: 600 },
    h5: { fontWeight: 500 },
    h6: { fontWeight: 500 },
    body1: { fontSize: 18 },
    button: { fontWeight: 600, fontSize: 16 },
  },
  shape: {
    borderRadius: 16,
  },
  components: {
    MuiButton: {
      styleOverrides: {
        root: {
          borderRadius: 24,
          textTransform: 'none',
        },
      },
    },
  },
});

export default theme;
