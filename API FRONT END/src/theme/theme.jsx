import { createTheme } from "@mui/material/styles";

const theme = createTheme({
    palette: {
        primary: {
            main: '#39A900',
        },
        secondary: {
            main: '#007832',
        },
        error: {
            main: '#f44336',
        },
        background: {
            default: 'white',
        },
    },
typography: {
    fontFamily: 'Roboto, sans-serif',
    h1: {
        fontSize: '2.5rem',
    },
    h2: {
        fontSize: '2rem',
    },
    body1: {
        fontSize: '1rem',
    },

},
spacing: 8,
shape: {
    borderRadius: 8,
},
breakpoints: {
    values: {
        xs: 0,
        sm: 600,
        md: 960,
        lg: 1280,
        xl: 1920,
    },
},
components: {
    MuiButton: {
        styleOverrides: {
            root: {
                textTransform: 'none',
            },
        },
    },
},

});

export default theme;