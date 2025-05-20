FROM --platform=linux/amd64 ubuntu:20.04 AS base

# Prevent interactive prompts (e.g. tzdata)
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

WORKDIR /app

# Lock timezone before apt installs
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install system dependencies and build tools
RUN apt-get -yqq update && \
    apt-get install -yq --no-install-recommends \
        python3-pip \
        python3-pandas \
        python3-sklearn \
        wget \
        unzip \
        build-essential \
        python3-dev \
        git \
        cmake && \
    apt-get autoremove -y && \
    apt-get clean -y

# Clone and build XGBoost v0.90 from source
RUN git clone --branch v0.90 https://github.com/dmlc/xgboost.git && \
    cd xgboost && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    cd ../python-package && \
    python3 setup.py install

# Copy source code
COPY ImmunIC /app/ImmunIC

# Make the bash script executable and set entrypoint
RUN chmod +x /app/ImmunIC/runImmunIC.bash
ENTRYPOINT ["/bin/bash", "/app/ImmunIC/runImmunIC.bash"]
