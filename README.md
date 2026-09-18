# TTR-docker Environment

This repository provides a containerized ROS Noetic environment to run [**TTR**](https://github.com/INTER-Robotics/TTR). It handles all the necessary dependencies, workspace configuration, and GUI (X11/Wayland) forwarding so you can run tools like RViz or Gazebo directly from the container.

## Prerequisites

Before you begin, ensure you have the following installed on your host machine:
*   [Docker](https://docs.docker.com/engine/install/)
*   [Docker Compose](https://docs.docker.com/compose/install/) (Usually installed during Docker installation, check running `docker compose version` on your bash).
*   *(Optional but recommended)* **NVIDIA Container Toolkit**: If you have an NVIDIA GPU, you need this installed to enable hardware acceleration inside the container:

```
# Download key from NVIDIA
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

# Add the official repository
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update list of packages and install
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# Configure with docker
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

## Installation

1. **Clone the repository:**
   Since the `TTR` folder acts as an external dependency or submodule, make sure to clone it recursively:
   ```bash
   git clone --recursive https://github.com/INTER-Robotics/TTR-docker.git
   cd TTR-docker
   ```

2. **Allow X11/Wayland connection (GUI apps):**
   To allow the Docker container to display graphics on your screen, run (you may run this line everytime you wnat to run the docker):
   ```bash
   xhost +local:root
   ```

## Running the Docker Container

This project uses a `docker-compose.yml` file that defines two separate services depending on your hardware. 

### Option A: With NVIDIA GPU (Recommended)
If your PC has an NVIDIA graphics card and the NVIDIA Container Toolkit installed, use the `ros-nvidia` service. This ensures full hardware acceleration.

To build and open an interactive terminal inside the container, run:
```bash
sudo docker compose run --rm ros-nvidia bash
```

### Option B: Without NVIDIA GPU (Intel / AMD / CPU)
If your PC has an integrated Intel/AMD GPU or no dedicated graphics card, use the `ros` base service. This maps `/dev/dri` to provide graphics acceleration without requiring NVIDIA drivers.

To build and open an interactive terminal inside the container, run:
```bash
sudo docker compose run --rm ros bash
```

*(Note: The first time you run either of these commands, Docker will download the base images and build the container, which may take a few minutes).*

## Usage
To execute TTR in the Anselm Turmeda building scenario run the following:
```
roslaunch ttr MAV_exploration_indoor_at.launch
```
