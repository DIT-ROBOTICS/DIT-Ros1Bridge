# DIT ROS 1 Bridge
This project provides a Docker-based solution to establish a communication bridge between **ROS 1 Noetic** and **ROS 2 Humble** using ```ros1_bridge```.

## Quick Start
### Start the container
```bash
cd DIT-Ros1Bridge/docker
docker compose up -d
```
This will start two docker containers:
- ```ros-core```: Runs the **ROS 1 Master (roscore)** using the *ros:noetic-ros-base* image.
- ```ros1bridge```: Runs the **ros1_bridge (dynamic_bridge)** with both ROS 1 and ROS 2 environments sourced.

### Build the image
If you have modified the ```Dockerfile``` or the installation scripts, you need to rebuild the image.
> **Note:** The build process involves compiling ROS 2 Humble from source, which will take approximately **20-30 minutes** depending on your hardware.
```bash
cd DIT-Ros1Bridge/docker
docker compose build
docker compose up -d
```

## Test Ros1Bridge
### Start containers fot testing
We also provide docker container for ROS1 and ROS2 environment, you can use the command to start the containers:
```bash
cd DIT-Ros1Bridge/docker
docker compose -f compose.example.yaml up -d
```
This will start two additional containers:
- ```ros1```: A container with the ROS Noetic environment.
- ```ros2```: A container with the ROS Humble environment.

### Test the 1to2bridge (ROS 1 Talker -> ROS 2 Listener)
Open two terminals for testing: 

**Termianl 1 (ROS 1 Talker)**
```bash
docker exec -it ros1 bash
source /opt/ros/noetic/setup.bash
rosrun rospy_tutorials talker
```
**Termianl 2 (ROS 2 Listener)**
```bash
docker exec -it ros2 bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_cpp listener
```
**Verification:** If the bridge works correctly, you should see output in Terminal 2 similar to: 
```txt
I heard: [hello world 1769646207.0724797]
``` 

### Test the 2to1bridge (ROS 2 Talker -> ROS 1 Listener)
Open two terminals for testing: 

**Termianl 1 (ROS 2 Talker)**
```bash
docker exec -it ros2 bash
source /opt/ros/humble/setup.bash
ros2 run demo_nodes_cpp listener
```
**Termianl 2 (ROS 1 Listener)**
```bash
docker exec -it ros1 bash
source /opt/ros/noetic/setup.bash
rosrun rospy_tutorials talker
```
**Verification:** If the bridge works correctly, you should see output in Terminal 2 similar to: 
```txt
I heard: [Hello World: 13]
```

## Reference
- [ros1_bridge GitHub Repository](https://github.com/ros2/ros1_bridge)
- [Using ros1_bridge with upstream ROS on Ubuntu 22.04](https://docs.ros.org/en/humble/How-To-Guides/Using-ros1_bridge-Jammy-upstream.html)