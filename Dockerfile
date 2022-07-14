FROM ubuntu:latest as build

COPY patches /patches

WORKDIR /build

COPY dependencies .

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt install findutils
RUN xargs apt install --yes < dependencies

COPY setup.sh .
COPY fat.* .
COPY *.py .
COPY *.txt .
COPY qemu-builds . i

RUN bash -c "./setup.sh"

WORKDIR /build/binwalk
RUN bash -c "./deps.sh"

CMD "echo hi"
