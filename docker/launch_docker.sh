# Thanks @dustinfreeman for providing the script
#!/bin/bash
sudo nvidia-docker build -t yangtian/vid2vid:CUDA9-py35 .

sudo nvidia-docker run --rm -ti --ipc=host --shm-size 32G -v ~/my_face_dataset/face_dataset/full_dataset:/vid2vid --workdir=/vid2vid yangtian/vid2vid:CUDA9-py35 /bin/bash
