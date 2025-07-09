# Replace the Dockerfile with the correct content (just the Docker instructions)
cat > Dockerfile << 'EOF'
# Official AutoGen Studio Dockerfile
# This installs the official Microsoft AutoGen Studio via pip

FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install AutoGen Studio from pip (official Microsoft package)
RUN pip install --no-cache-dir autogenstudio

# Create non-root user
RUN useradd -m -u 1000 autogenuser
USER autogenuser

# Set environment variables
ENV AUTOGENSTUDIO_APPDIR=/home/autogenuser/.autogenstudio
ENV HOME=/home/autogenuser

# Create app directory
RUN mkdir -p $AUTOGENSTUDIO_APPDIR

# Expose port
EXPOSE 8081

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

# Start AutoGen Studio
CMD ["autogenstudio", "ui", "--host", "0.0.0.0", "--port", "8081"]
EOF

# Check the file looks correct now
cat Dockerfile

# Add, commit, and push the corrected Dockerfile
git add Dockerfile
git commit -m "Fix Dockerfile content - remove shell commands"
git push origin main