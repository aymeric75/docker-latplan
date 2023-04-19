FROM nvcr.io/nvidia/tensorflow:23.03-tf1-py3

RUN ["/bin/bash", "-c", "apt-get update"]

RUN ["/bin/bash", "-c", "apt-get -y install openssh-server"]

RUN ["/bin/bash", "-c", "wget -P /workspace https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh "]

ENV CONDA_DIR /root/anaconda3

RUN /bin/bash /workspace/Anaconda3-2023.03-Linux-x86_64.sh -b -p /root/anaconda3

ENV PATH=$CONDA_DIR/bin:$PATH

RUN echo 'export PATH=/root/anaconda3/bin:$PATH' >> ~/.bashrc

RUN ["/bin/bash", "-c", "apt-get -y install nano"]

RUN ["/bin/bash", "-c", "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin Yes/g' /etc/ssh/sshd_config"]

RUN ["/bin/bash", "-c", "echo  'root:MyPassword' | chpasswd"]

RUN ["/bin/bash", "-c", "apt-get -y install flex bison g++-multilib build-essential automake libcurl4-openssl-dev libmagic-dev libpng-dev"]

RUN ["/bin/bash", "-c", "mkdir -p /workspace/latplan"]

WORKDIR /workspace/latplan

RUN ["/bin/bash", "-c", "conda create --name latplan"]

SHELL ["conda", "run", "-n", "latplan", "/bin/bash", "-c"]

# RUN ["/bin/bash", "-c", "conda activate latplan"]

RUN git clone -b release https://github.com/roswell/roswell.git

WORKDIR /workspace/latplan/roswell

RUN ["/bin/bash", "-c", "sh bootstrap && ./configure && make && make install && ros setup"]


RUN ["/bin/bash", "-c", "ros install sbcl-bin/2.3.2"]

RUN ["/bin/bash", "-c", "ros install arrival"]

ENV PATH="/root/.roswell/bin:$PATH"

RUN ["/bin/bash", "-c", "ros dynamic-space-size=8000 install numcl eazy-gnuplot magicffi dataloader"]

WORKDIR /workspace/latplan

# RUN make -j 1 -C lisp

RUN ["/bin/bash", "-c", "pip install git+https://github.com/LBonassi95/downward.git@only-grounder-refactoring"]

RUN ["/bin/bash", "-c", "pip install matplotlib protobuf==3.20 keras==2.2.5 keras_radam imageio scikit-image progressbar2"]

