# First, let's make sure we're in the right directory
pwd
# Should show: /Users/yatinkarnik/autogen

# Replace the Dockerfile with the actual content
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

# Add and commit the changes
git add Dockerfile
git commit -m "Update Dockerfile with proper AutoGen Studio configuration"

# Push to your repository
git push origin main