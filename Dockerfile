FROM ubuntu:latest

COPY patches /patches

WORKDIR /build

COPY dependencies .

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt update

RUN apt install findutils
RUN xargs apt install --yes < dependencies

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
