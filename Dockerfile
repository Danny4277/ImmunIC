FROM --platform=linux/amd64 ubuntu:20.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

WORKDIR /app

# Install system dependencies and build tools (including tzdata)
RUN apt-get -yqq update && \
    apt-get install -yq --no-install-recommends \
        tzdata \
        python3-pip \
        python3-pandas \
        python3-sklearn \
        wget \
        unzip \
        build-essential \
        python3-dev \
        git \
        cmake && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get autoremove -y && \
    apt-get clean -y
