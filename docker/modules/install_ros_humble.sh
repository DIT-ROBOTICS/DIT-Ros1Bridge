#!/bin/bash
set -e

echo "Installing ROS Humble from source..."

# Ref: https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html
# Set locale
apt update && apt install -y locales
locale-gen en_US en_US.UTF-8
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Setup sources
apt install -y software-properties-common
add-apt-repository universe

apt update && apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
dpkg -i /tmp/ros2-apt-source.deb

# Install development tools and ROS tools
apt update && apt install -y \
    python3-flake8-docstrings \
    python3-pip \
    python3-pytest-cov \
    ros-dev-tools \
    python3-flake8-blind-except \
    python3-flake8-builtins \
    python3-flake8-class-newline \
    python3-flake8-comprehensions \
    python3-flake8-deprecated \
    python3-flake8-import-order \
    python3-flake8-quotes \
    python3-pytest-repeat \
    python3-pytest-rerunfailures  

python3 -m pip install -U colcon-common-extensions vcstool  

mkdir -p /ros2_humble/src \
    && cd /ros2_humble \
    && vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

apt update && apt upgrade -y

rosdep init \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -y --skip-keys="fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

colcon build
echo "ROS Humble installation completed successfully!"