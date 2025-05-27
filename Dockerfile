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

# Set CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://packagemanager.rstudio.com/all/__linux__/focal/latest"))' >> /etc/R/Rprofile.site

# Install your specific R packages
RUN Rscript -e "install.packages(c('devtools', 'sodium', 'minioclient', 'FaaSr', 'credentials'), dependencies=TRUE)"

# Verify installations
RUN Rscript -e "print(installed.packages()[,c('Package', 'Version')])"

WORKDIR /workspace 