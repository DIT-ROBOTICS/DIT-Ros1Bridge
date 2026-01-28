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
source install/setup.bash

# Build
colcon build --packages-select ros1_bridge --cmake-force-configure

echo "ROS Bridge installation completed successfully!"