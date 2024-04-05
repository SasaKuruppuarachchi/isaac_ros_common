## ter 1
cd /workspaces/dds/Micro-XRCE-DDS-Agent
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/
sudo MicroXRCEAgent serial --dev /dev/ttyUSB0 -b 921600

## ter 2
cd /workspaces/px4_ros2
source install/setup.bash
ros2 launch px4_ros_com sensor_combined_listener.launch.py

## ter 3
cd /workspaces/isaac_ros-dev && \
  colcon build --symlink-install && \
  source install/setup.bash
ros2 launch isaac_ros_visual_slam isaac_ros_visual_slam_realsense.launch.py

## ter 4
rviz2 -d /workspaces/isaac_ros-dev/src/isaac_ros_visual_slam/isaac_ros_visual_slam/rviz/realsense.cfg.rviz