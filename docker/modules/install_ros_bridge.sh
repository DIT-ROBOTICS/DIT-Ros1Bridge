#!/bin/bash
set -e

echo "Installing ROS Bridge..."

apt update && apt install -y git

# Create a workspace for the ros1_bridge
mkdir -p src/ros1_bridge/src \
    && cd src/ros1_bridge/src \
    && git clone https://github.com/ros2/ros1_bridge \
    && cd /ros2_humble

# Source the ROS 2 workspace
. /ros2_humble/install/local_setup.bash

# Build
colcon build --packages-select ros1_bridge --cmake-args -DCMAKE_BUILD_TYPE=Release

echo "ROS Bridge installation completed successfully!"