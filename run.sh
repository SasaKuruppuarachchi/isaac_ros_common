#!/bin/bash

tmux has-session -t nef_issac_vio
if [ $? == 0 ]; then
    tmux kill-session -t nef_issac_vio
fi
tmux new-session -s nef_issac_vio -n main -d # new session
tmux new-window -n debug -t nef_issac_vio # new window
tmux new-window -n sim -t nef_issac_vio # new window
tmux new-window -n gazebo -t nef_issac_vio # new window
tmux new-window -n yolact_test -t nef_issac_vio # new window
tmux new-window -n traj_eval -t nef_issac_vio # new window

tmux select-window -t main

# divide
tmux split-window -h -t 1

# divide
tmux split-window -v -t 1
tmux split-window -v -t 3
tmux split-window -v -t 4

tmux split-window -v -t 5

tmux resize-pane -D -t 1 5

# run
sleep 1
tmux send-keys -t 6 "roscore" C-m
#tmux send-keys -t 3 "ISAAC_PY sim_launch.py" C-m

#OV
sleep 1
tmux send-keys -t 1 "cd ~/workspace/arrf_exp/" C-m
tmux send-keys -t 1 "sorthis" C-m
tmux send-keys -t 1 "rosparam set use_sim_time true" C-m
tmux send-keys -t 1 "roslaunch ov_msckf subscribe_nrf.launch" 

#VinsFUSION
tmux send-keys -t 2 "ISAAC_ROS_WS" C-m
tmux send-keys -t 2 "sorthis" C-m
tmux send-keys -t 2 "rosparam set use_sim_time true" C-m
#tmux send-keys -t 2 "roslaunch isaac_vins new.launch" 
tmux send-keys -t 2 "nrf" C-m
tmux send-keys -t 2 "cd tests/bags/x_movement" C-m
tmux send-keys -t 2 "rosbag record /ground_truth/state /mavros/local_position/pose /mavros/setpoint_position/local /ov_msckf/poseimu /ov_msckf1/poseimu"

#teleop
tmux send-keys -t 4 "rosparam set use_sim_time true" C-m
#tmux send-keys -t 4 "rosrun teleop_twist_keyboard teleop_twist_keyboard.py" 
tmux send-keys -t 4 "cd tests/bags/scenes" C-m
#teleop
tmux send-keys -t 5 "rosparam set use_sim_time true" C-m
tmux send-keys -t 5 "rviz -d ~/workspace/arrf_exp/src/sa-slam_indoor_aerial_nav_for_warehouses/open_vins/ov_msckf/launch/display_final.rviz" 

#recode
tmux send-keys -t 3 "cd ~/workspace/arrf_exp/" C-m
tmux send-keys -t 3 "sorthis" C-m
tmux send-keys -t 3 "rosparam set use_sim_time true" C-m
tmux send-keys -t 3 "roslaunch ov_msckf recode.launch"


#simulation
tmux select-window -t sim

tmux send-keys -t 1 "ISAAC_CD" C-m
tmux send-keys -t 1 "rosparam set use_sim_time true" C-m
tmux send-keys -t 1 "./python.sh standalone_examples/api/omni.isaac.quadruped/carter_stdalone.py"

#eval
tmux select-window -t traj_eval

tmux send-keys -t 1 "rosparam set use_sim_time true" C-m
tmux send-keys -t 1 "cd ~/workspace/arrf_exp/" C-m
tmux send-keys -t 1 "sorthis" C-m
tmux send-keys -t 1 "cd src/sa-slam_indoor_aerial_nav_for_warehouses/tests/loop" C-m
tmux send-keys -t 1 "rosrun ov_eval error_comparison posyaw truth/ algorithms/"

#debug
tmux select-window -t debug
tmux send-keys -t 1 "rosparam set use_sim_time true" C-m
tmux send-keys -t 1 "cd ~/workspace/arrf_exp/" C-m
tmux send-keys -t 1 "sorthis" C-m

#gazebo
tmux select-window -t gazebo
tmux split-window -v -t 1
tmux split-window -h -t 1
tmux split-window -v -t 2


tmux send-keys -t 1 "cd ~/workspace/arrf_exp/" C-m
tmux send-keys -t 1 "sorthis" C-m
#source ~/catkin_ws/devel/setup.bash
tmux send-keys -t 1 "source /home/arrf/PX4-Autopilot/Tools/simulation/gazebo-classic/setup_gazebo.bash /home/arrf/PX4-Autopilot/ /home/arrf/PX4-Autopilot/build/px4_sitl_default" C-m
tmux send-keys -t 1 "export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/home/arrf/PX4-Autopilot/Tools/simulation/gazebo-classic/sitl_gazebo-classic:/home/arrf/PX4-Autopilot/" C-m
#tmux send-keys -t 1 "export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:/home/arrf/PX4-Autopilot/" C-m
tmux send-keys -t 1 "rosparam set use_sim_time true" C-m
tmux send-keys -t 1 "roslaunch nrf_warehouse warehouse.launch"
#tmux send-keys -t 1 "roslaunch dynamic_logistics_warehouse logistics_warehouse.launch"  


tmux send-keys -t 4 "cd ~/workspace/arrf_exp/" C-m
tmux send-keys -t 4 "sorthis" C-m
tmux send-keys -t 4 "rosparam set use_sim_time true" C-m
tmux send-keys -t 4 "rosrun offboard nrf.py"


tmux send-keys -t 2 "cd ~/workspace/arrf_exp/src/sa-slam_indoor_aerial_nav_for_warehouses/tests/bags" C-m
tmux send-keys -t 2 "rosparam set use_sim_time true" C-m
#tmux send-keys -t 2 "rosbag record /ground_truth/state /mavros/local_position/pose /mavros/setpoint_position/local /ov_msckf/poseimu /ov_msckf1/poseimu"
tmux send-keys -t 2 "rosbag record /ground_truth/state /mavros/local_position/pose /mavros/setpoint_position/local /mavros/imu/data /stereo/left/image_raw /stereo/right/image_raw /iris/camera/depth/image_raw /clock"

tmux send-keys -t 3 "cd ~/workspace/arrf_exp/src/sa-slam_indoor_aerial_nav_for_warehouses/tests/bags/scenes" C-m
tmux send-keys -t 3 "rosparam set use_sim_time true" C-m
tmux send-keys -t 3 "rosbag play xy_movement.bag"

#yolact_test
tmux select-window -t yolact_test
tmux send-keys -t 1 "cd ~/workspace/arrf_exp/" C-m
tmux send-keys -t 1 "sorthis" C-m
tmux send-keys -t 1 "rosparam set use_sim_time true" C-m
tmux send-keys -t 1 "rosrun yolact_ros sa_vio_outlier_detector_yedge"


tmux select-window -t main
#----------------------------------------------------------------------------
tmux attach -t nef_issac_vio # needed to run
