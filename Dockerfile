FROM rocker/r-base:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set CRAN mirror to use binary packages
RUN mkdir -p /usr/local/lib/R/etc && \
    echo 'options(repos = c(CRAN = "https://packagemanager.rstudio.com/all/__linux__/focal/latest"))' >> /usr/local/lib/R/etc/Rprofile.site

# Set environment variables to avoid compiling Arrow from source
ENV ARROW_R_DEV=false
ENV LIBARROW_BINARY=true
ENV ARROW_USE_PKG_CONFIG=false
ENV NOT_CRAN=false

# Install your specific R packages with binary preference
RUN Rscript -e "install.packages(c('devtools', 'sodium', 'minioclient', 'FaaSr', 'credentials'), dependencies=TRUE, type='binary')"

# Verify installations
RUN Rscript -e "print(installed.packages()[,c('Package', 'Version')])"

WORKDIR /workspace 