# Independencies

* docker-ce
* docker-compose
* nvidia-docker 2.0

# Compiling
After copy the Anaconda3 Installation Package under this root directory, u can build the image from the image `nvidia/cuda` with basic softwares installed.
```bash
docker build -t <image_name> .
```

When the 'build' process is finished, launch a new container from the image compiled.
```bash
docker run -it <image_name> /bin/bash
```

Create the new environment & install PyTorch in the container.
```bash
# create environment named py37
conda create -n py37 python=3.7.5

# install PyTorch
conda install pytorch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 cudatoolkit=11.0 -c pytorch
# install tensorboard
pip install tensorboard
```

Optional: U can add `conda activate py37` into `~/.bashrc` to automatically activate the env `(py37)`

Now the vanilla-pytorch docker image can be obtained by commit the container in your host.
```bash
docker commit -m "Vanilla-PyTorch: 1.7.1 with cuda-11.0, Ubuntu18.04." <container_id> <final_image_name>
```
