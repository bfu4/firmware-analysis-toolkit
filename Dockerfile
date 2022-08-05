FROM amd64/ubuntu:20.04

COPY patches /patches

MAINTAINER Bella Fusari <bfu@greynoise.io>

LABEL version="1.0"

WORKDIR /build

COPY dependencies .

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt update

RUN apt install findutils
RUN xargs apt install --yes < dependencies
RUN bash -c "ln -s $(which python3) /usr/bin/python"

# Copy files
COPY setup.sh .
COPY fat.* .
COPY *.py .
COPY *.txt .
COPY qemu-builds .

RUN pip install -r ./requirements.txt

# Apply our patches
RUN bash -c "./setup.sh"

# Setup binwalk dependencies.
WORKDIR /build/binwalk
RUN bash -c "./deps.sh"

# Install binwalk
RUN python3 setup.py install

WORKDIR /build/firmadyne

RUN useradd -m firmadyne
RUN echo "firmadyne:firmadyne" | chpasswd && adduser firmadyne sudo
RUN echo "root:root" | chpasswd

ENV PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/build/qemu-builds/2.5.0

RUN mkdir /mount
RUN mkdir /out

WORKDIR /build
