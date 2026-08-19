import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./src/**/*.{ts,tsx}'],
  theme: {
    extend: {
      colors: {
        base: '#0B0E13',
        surface: '#141922',
        raised: '#1C232E',
        line: '#2A3341',
        ink: '#E8EDF4',
        muted: '#8C99AB',
        signal: '#FF7A18',
        safe: '#3DDC84',
        warn: '#FFC53D',
        critical: '#FF4D4F'
      },
      fontFamily: {
        sans: ['-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'sans-serif'],
        mono: ['ui-monospace', 'SFMono-Regular', 'Menlo', 'Consolas', 'monospace']
      },
      borderRadius: { xl2: '1.25rem' },
      boxShadow: { card: '0 1px 0 0 rgba(255,255,255,0.04) inset, 0 8px 24px -12px rgba(0,0,0,0.8)' }
    }
  },
  plugins: []
};
export default config;
