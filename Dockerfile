# Use an official Ubuntu as a parent image
# NOTE! Don't use 22.04 (jammy) There is an issue with: vtkXRenderWindowInteractor 
# More info: https://github.com/PointCloudLibrary/pcl/issues/5237 
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install requirements
RUN apt update && \
    apt install -y \
    sudo \
    curl \
    build-essential \
    cmake \
    git \
    g++ \
    gdb \
    clang-format 

# Install dependencies
RUN apt install -y \
    libcairo2-dev \
    libgraphicsmagick1-dev \
    libpng-dev 

# Build Cairo/Xlib on Linux
RUN cd /tmp && \
    git clone --recurse-submodules https://github.com/cpp-io2d/P0267_RefImpl && \
    cd P0267_RefImpl && \
    mkdir Debug && \
    cd Debug && \
    cmake --config Debug "-DCMAKE_BUILD_TYPE=Debug" .. && \
    cmake --build . && \
    cmake --install . && \
    rm -rf P0267_RefImpl 

# Clean up to keep the image size small
RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create a new user 'user' with sudo privileges
RUN useradd -m user && \
    echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

# Use sed to uncomment the force_color_prompt line in ~/.bashrc
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/user/.bashrc

# Default command
CMD ["/bin/bash"]
