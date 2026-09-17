#!/bin/bash
# entrypoint.sh

# Fuente ROS
source /opt/ros/noetic/setup.bash

# Fuente workspace
source /root/catkin_ws/devel/setup.bash

# Ejecutar comando pasado al contenedor, o abrir shell
exec "$@"
