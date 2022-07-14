FROM ubuntu:latest as build

COPY patches /patches

WORKDIR /build

COPY dependencies .

RUN apt update

RUN apt install findutils
RUN xargs apt install --yes < dependencies

COPY 
