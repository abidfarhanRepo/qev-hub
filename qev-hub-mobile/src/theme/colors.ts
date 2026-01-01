import { MD3LightTheme, MD3DarkTheme } from 'react-native-paper';

const QATAR_MAROON = '#8A1538';
const ELECTRIC_CYAN = '#00FFFF';
const LIGHT_BG = '#FFFFFF';
const DARK_BG = '#1A1A1A';

export const lightTheme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: QATAR_MAROON,
    secondary: ELECTRIC_CYAN,
    background: LIGHT_BG,
    surface: '#F5F5F5',
    onPrimary: '#FFFFFF',
    onSecondary: '#000000',
    onBackground: '#000000',
    onSurface: '#000000',
    accent: QATAR_MAROON,
  },
};

export const darkTheme = {
  ...MD3DarkTheme,
  colors: {
    ...MD3DarkTheme.colors,
    primary: QATAR_MAROON,
    secondary: ELECTRIC_CYAN,
    background: DARK_BG,
    surface: '#2A2A2A',
    onPrimary: '#FFFFFF',
    onSecondary: '#000000',
    onBackground: '#FFFFFF',
    onSurface: '#FFFFFF',
    accent: '#C74D76',
  },
};
