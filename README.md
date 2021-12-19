# Vanilla Docker Images
This repository aims to build vanilla Docker images to create desktop versions of docker container (with CUDA, Anaconda3, Pytorch, etc.).

## Independencies
* docker-ce
* docker-compose
* nvidia-docker 2.0

## Build
### Basic Image: Ubuntu18.04 with Anaconda3
You can build the image from the base-image [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) with basic softwares installed & some basic settings.
```bash
# download the source code
git clone git@github.com:Joy1112/vanilla-docker-images.git
cd vanilla-docker-images

docker build -t <image_name>:<tag> ubuntu-anaconda

# etc.
docker build -t ubuntu18.04-anaconda3/cuda-11.0:latest ubuntu-anaconda
```

**Softwares have benn installed**:
* vim
* wget
* curl
* openssh-server
* git
* Anaconda3 (The sources of pip & conda have been all changed to [Tsinghua Open Source](https://mirrors.tuna.tsinghua.edu.cn/))
* libgl1-mesa-glx (libGL.so.1)
* python3 (/usr/local/bin/python -> /usr/local/bin/python3.6)
* iputils-ping
* net-tools
* iptables
* graphviz
* tzdata
* bzip2
* fixuid

### Vanilla Pytorch Image
Furthermore, a vanilla pytorch image can be built based on the base-image built above.
```bash
docker build -t <image_name>:<tag> vanilla-pytorch

# etc.
docker build -t vanilla-pytorch:1.7.1-cu110-py37 vanilla-pytorch

# or u can adjust the version of python/pytorch/others with argument `--build-arg <var_name>=<var_value>`
docker build -t vanilla-pytorch:1.7.1-cu110-py38 \
--build-arg ENV_NAME="py38" \
--build-arg PYTHON_VERSION="3.8.0" \
vanilla-pytorch
```

## Usage
Command `run` can be used to launch a new container from the image built and please note the `-u` argument must be specified.

When u call `run` command, it will automatically run the script `/home/start.sh`, which will use [fixuid](https://github.com/boxboat/fixuid) to set the container_user `docker`'s user_id and group_id to your host_user's user_id and group_id and start the ssh service as well.
```bash
# arg `-u` must be specified
docker run -it -u $(id -u):$(id -g) <image_name>

# full command
docker run --name <container_name> -it -u $(id -u):$(id -g) -p <new_port>:22 --gpus all -v <path_to_home>/.ssh:/root/.ssh:ro <image_name>
```
