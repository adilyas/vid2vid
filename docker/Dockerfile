FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# ENV PATH="/root/miniconda/bin:${PATH}"
# ARG PATH="/root/miniconda/bin:${PATH}"

RUN apt-get update && apt-get install -y rsync htop git openssh-server

# RUN apt-get update && apt-get install software-properties-common -y
# RUN add-apt-repository ppa:deadsnakes/ppa -y && apt-get update && apt-get install python3.7 -y && apt-get install python3-pip -y && apt-get install python3.7-dev -y

# RUN apt-get install -u python3
# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh && bash Miniconda3-latest-Linux-x86.sh -b -p $HOME/miniconda # python 3.7
# RUN conda install python=3.5 -y

RUN apt-get update && apt-get install python-opencv -y && apt install vim -y

RUN apt-get install python3-pip -y
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install --upgrade setuptools==50.3.0 pip==20.2.3

#Torch and dependencies:
RUN pip3 install https://download.pytorch.org/whl/cu90/torch-1.1.0-cp35-cp35m-linux_x86_64.whl 
RUN pip3 install https://download.pytorch.org/whl/cu90/torchvision-0.3.0-cp35-cp35m-manylinux1_x86_64.whl
RUN pip3 install cffi tensorboardX
RUN pip3 install tqdm scipy scikit-image colorama==0.3.7 numpy==1.17.1
RUN pip3 install setproctitle pytz ipython

#vid2vid dependencies
RUN pip3 install scikit-build
RUN apt-get install libglib2.0-0 libsm6 libxrender1 -y
RUN apt-get install cmake -y
RUN pip3 install dominate requests opencv-python 

#pix2pixHD, required for initializing training
RUN git clone https://github.com/NVIDIA/pix2pixHD /pix2pixHD

#vid2vid install
RUN git clone https://github.com/adilyas/vid2vid /vid2vid2
WORKDIR /vid2vid2
#download flownet2 model dependencies
#WARNING: we had an instance where these scripts needed to be re-run after the docker instance was launched
RUN pip3 install dominate requests dlib

RUN python scripts/download_flownet2.py
RUN python scripts/download_models_flownet2.py

RUN python scripts/download_datasets.py
RUN python scripts/face/download_models.py

RUN python data/face_landmark_detection.py train

RUN pip3 install numpy==1.16.0

RUN git clone https://github.com/adilyas/pix2pixHD /pix2pixHD2
