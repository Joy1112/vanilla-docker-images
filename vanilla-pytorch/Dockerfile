# basic image
FROM ubuntu18.04-anaconda3/cuda-11.0:latest

ARG DEBIAN_FRONTEND noninteractive
ARG ENV_NAME="py37"
ARG PYTHON_VERSION="3.7.5"
ARG TORCH_VERSION="1.7.1"
ARG TORCHVISITON_VERSION="0.8.2"
ARG TORCHAUDIO_VERSION="0.7.2"
ARG CUDATOOLKIT_VERSION="11.0"

LABEL author = 'Joy' \
    description="This image is built from ubuntu18.04-anaconda3/cuda-11.0:latest as a vanilla pytorch-"$TORCH_VERSION" image."

# what is ridiculous is that u must call `source deactivate` before other `conda` commands otherwise it will remind u to call `conda init <shell_name>`.
RUN conda create -n $ENV_NAME python=$PYTHON_VERSION && \
    echo -e "\nconda activate "$ENV_NAME >> /home/docker/.bashrc && \
    source /home/docker/.bashrc && source /etc/profile && \
    source deactivate && conda activate $ENV_NAME && \
    conda install pytorch==$TORCH_VERSION torchvision==$TORCHVISITON_VERSION torchaudio==$TORCHAUDIO_VERSION cudatoolkit=$CUDATOOLKIT_VERSION -c pytorch -y && \
    pip install --no-cache-dir tensorboard
