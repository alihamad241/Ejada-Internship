# ==============================================================================
# Ejada Summer Internship 2026 - Cloud Build Track
# Lab 3: Containerized Application Dockerfile
# ==============================================================================

# Use lightweight Nginx Alpine base image
FROM nginx:alpine

# Set working directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx welcome page
RUN rm -rf ./*

# Copy custom application HTML file
COPY app/index.html /usr/share/nginx/html/index.html

# Set appropriate permissions
RUN chmod 644 /usr/share/nginx/html/index.html

# Expose HTTP port 80
EXPOSE 80

# Health check to ensure web server is serving content
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
