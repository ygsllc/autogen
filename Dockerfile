FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir autogenstudio

RUN useradd -m -u 1000 autogenuser
USER autogenuser

ENV AUTOGENSTUDIO_APPDIR=/home/autogenuser/.autogenstudio
ENV HOME=/home/autogenuser

RUN mkdir -p $AUTOGENSTUDIO_APPDIR

EXPOSE 8081

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8081/ || exit 1

CMD ["autogenstudio", "ui", "--host", "0.0.0.0", "--port", "8081"]
