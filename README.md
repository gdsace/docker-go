# Go Containers

[![Build Status](https://travis-ci.com/gdsace/docker-go.svg?branch=master)](https://travis-ci.com/gdsace/docker-go/)

This repository is a collection of Docker images we use internally for go applications.

Daily builds are run against these images and automatically sent to our DockerHub repository at:

https://hub.docker.com/r/govtechsg/go/

## Methodology
All runtimes are built from official sources using the methods documented in the runtimes' official documentation.

### Usage/Description
Canonical Tag: `go-<GO_VERSION>`
Latest URL: `govtechsg/go-latest`

## How to use

### Build
The build script creates the build for the specified image. For instance to build image with go v1.10.4:

```bash
DH_REPO=govtechsg/go
IMAGE_NAME=go
./build.sh "${DH_REPO}" "${IMAGE_NAME}"
```

### Publish
The publish script sends your built image to DockerHub and relies on the build script being run prior to it. For instance to publish a previously built image with go v1.10.4:

```bash
DH_REPO=govtechsg/go
IMAGE_NAME=go
./publish.sh "${DH_REPO}" "${IMAGE_NAME}"
```