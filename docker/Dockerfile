FROM ubuntu:22.04 AS base

LABEL maintainer="Yu Hsiang Chen"
LABEL email="seanchen1117@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

# Keep apt cache to speed up subsequent builds
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# Install common tools
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    usbutils \
    v4l-utils \
    htop \
    iputils-ping \
    wget \
    net-tools \
    tmux \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

FROM base AS build

ENV DEBIAN_FRONTEND=noninteractive

# Install ROS 2 Humble
COPY modules/install_ros_humble.sh /tmp/install_ros_humble.sh
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    /tmp/install_ros_humble.sh && rm /tmp/install_ros_humble.sh

# Install ROS Noetic
# ref: https://docs.ros.org/en/iron/How-To-Guides/Using-ros1_bridge-Jammy-upstream.html
# ref: https://github.com/osrf/docker_images/issues/635#issuecomment-1217505552
# If there is still issue, try to comment the command below and enter the container to see the correct file name under /etc/apt/sources.list.d/
RUN rm -rf /etc/apt/sources.list.d/ros2.sources
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update \
    && apt remove -y python3-catkin-pkg python3-catkin-pkg-modules\
    && apt-get install -q -y --no-install-recommends ros-core-dev \
    && rm -rf /var/lib/apt/lists/*

# Install ros1_bridge
WORKDIR /ros2_humble
COPY modules/install_ros_bridge.sh /tmp/install_ros_bridge.sh
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    /tmp/install_ros_bridge.sh && rm /tmp/install_ros_bridge.sh

ENTRYPOINT []
CMD ["/bin/bash"]

FROM base AS deploy

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    apt-get update && apt-get install -y \
    libspdlog-dev \
    python3-packaging \
    ros-core-dev 

RUN mkdir -p /ros2_humble
COPY --from=build /ros2_humble/install /ros2_humble/install

ENTRYPOINT [ ]
CMD ["/bin/bash"]