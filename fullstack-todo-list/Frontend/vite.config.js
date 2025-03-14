import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: "0.0.0.0", // Allow external access from Docker
    port: 5137, // Ensure it's running on the right port
    strictPort: true, // Prevent fallback to another port
  },
});
