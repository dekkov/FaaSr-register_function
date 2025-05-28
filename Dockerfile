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
RUN Rscript -e "install.packages(c('jsonlite', 'cli', 'glue'), dependencies=TRUE, repos='https://cloud.r-project.org')"

RUN Rscript -e "install.packages(c('openssl', 'httr', 'curl'), dependencies=TRUE, repos='https://cloud.r-project.org')"

RUN Rscript -e "install.packages('sodium', dependencies=TRUE, repos='https://cloud.r-project.org')"

RUN Rscript -e "install.packages(c('credentials', 'gert'), dependencies=TRUE, repos='https://cloud.r-project.org')"

RUN Rscript -e "install.packages('devtools', dependencies=TRUE, repos='https://cloud.r-project.org')"

RUN Rscript -e "install.packages('minioclient', dependencies=TRUE, repos='https://cloud.r-project.org')"

RUN Rscript -e "install.packages(c('base64enc', 'paws.storage', 'askpass'), dependencies=TRUE, repos='https://cloud.r-project.org')"

RUN Rscript -e "devtools::install_github('FaaSr/FaaSr-package',force=TRUE)"


# Create a build verification file
RUN echo 'Container built successfully on:' $(date) > /container-info.txt && \
    echo 'FaaSr version:' >> /container-info.txt && \
    Rscript -e "cat(as.character(packageVersion('FaaSr')))" >> /container-info.txt

WORKDIR /workspace