FROM rocker/r-base:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libsodium-dev \
    libssh2-1-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libicu-dev \
    make \
    git \
    pandoc \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set CRAN mirror
RUN mkdir -p /usr/local/lib/R/etc && \
    echo 'options(repos = c(CRAN = "https://cloud.r-project.org"))' >> /usr/local/lib/R/etc/Rprofile.site

# Set environment variables
ENV ARROW_R_DEV=false
ENV LIBARROW_BINARY=true
ENV ARROW_USE_PKG_CONFIG=false
ENV NOT_CRAN=false

# Install R packages with better error handling and explicit dependencies
RUN Rscript -e "options(warn = 2); cat('Installing base dependencies...\n'); install.packages(c('jsonlite', 'cli', 'glue'), dependencies=TRUE); cat('Installing crypto/network dependencies...\n'); install.packages(c('openssl', 'httr', 'curl'), dependencies=TRUE); cat('Installing sodium...\n'); install.packages('sodium', dependencies=TRUE); cat('Installing git dependencies...\n'); install.packages(c('credentials', 'gert'), dependencies=TRUE); cat('Installing devtools...\n'); install.packages('devtools', dependencies=TRUE); cat('Installing minioclient...\n'); install.packages('minioclient', dependencies=TRUE); cat('Installing additional dependencies...\n'); install.packages(c('base64enc', 'paws.storage', 'askpass'), dependencies=TRUE); cat('Installing FaaSr...\n'); install.packages('FaaSr', dependencies=TRUE); cat('Verifying FaaSr installation...\n'); library(FaaSr); cat('✓ FaaSr installed successfully! Version:', as.character(packageVersion('FaaSr')), '\n')"

# Create a build verification file
RUN echo 'Container built successfully on:' $(date) > /container-info.txt && \
    echo 'FaaSr version:' >> /container-info.txt && \
    Rscript -e "cat(as.character(packageVersion('FaaSr')))" >> /container-info.txt

WORKDIR /workspace