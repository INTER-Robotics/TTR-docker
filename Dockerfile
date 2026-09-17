FROM osrf/ros:noetic-desktop-full

# Set environment variables for ROS development
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC \
    ROS_WORKSPACE=/root/catkin_ws \
    # Evita errores de memoria compartida en Docker/Wayland
    QT_X11_NO_MITSHM=1 \
    # Forzar a que use la GPU NVIDIA (no renderizado por software)
    LIBGL_ALWAYS_SOFTWARE=0 \
    # Variables para que NVIDIA Container Toolkit habilite los drivers gráficos
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=graphics,compute,utility \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Tools setup
RUN apt-get update && apt-get install -y \
    git \
    wget \
    nano \
    python3-wstool \
    python3-catkin-tools \
    build-essential \
    rsync \
    ros-noetic-cmake-modules \
    protobuf-compiler \
    autoconf \
    automake \
    libtool \
    pkg-config \
    ros-noetic-geographic-msgs \
    python-is-python3 \
    ros-noetic-mavros-msgs \
    ros-noetic-octomap-server \
    ros-noetic-teleop-twist-joy \
    # Per Wayland (Ub 24)
    libglvnd0 \
    libgl1 \
    libglx0 \
    libegl1 \
    libxext6 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Clean workspace if it exists
RUN rm -rf /root/catkin_ws/src/*

# Create workspace
RUN mkdir -p /root/catkin_ws/src

# Copy the TTR repository on the host into the docker container
COPY TTR /root/catkin_ws/src/TTR


RUN apt-get update && apt-get install -y git ca-certificates && update-ca-certificates

# Initialize wstool using the rosinstall file
RUN cd /root/catkin_ws && \
    wstool init . ./src/TTR/ttr_installer.rosinstall && \
    wstool update

# Inicializar, configurar y construir workspace en Release
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    cd /root/catkin_ws && \
    catkin init && \
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release && \
    catkin build"

RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    echo "if [ -f /root/catkin_ws/devel/setup.bash ]; then source /root/catkin_ws/devel/setup.bash; fi" >> /root/.bashrc

# Copiar entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
