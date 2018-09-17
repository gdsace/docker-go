# Golang Development Container

[![Build Status](https://travis-ci.com/gdsace/docker-golang.svg?branch=master)](https://travis-ci.com/gdsace/docker-golang/)

Daily builds are run against these images and automatically sent to our DockerHub repository at:

https://hub.docker.com/r/govtechsg/golang/





## Contents
- [Included Tooling](#included-tooling)
- [Example Usage](#example-usage)
- [Notes on Contributing](#notes-on-contributing)
- [Forking and Using](#forking-and-using)
- [License](#license)





## Included Tooling
- [Golint for linting](https://github.com/golang/lint)
- [Realize for live-reloads](https://github.com/oxequa/realize)
- [GoConvey for test watching](https://github.com/smartystreets/goconvey)
- [Dep for dependency management](https://github.com/golang/dep)





## Example Usage
The following example is also available in [the example directory](./example).

- [Example Dockerfile](#example-dockerfile)
- [Initialise Dependencies](#initialise-dependencies)
- [Developing with Live-Reload](#developing-with-live-reload)
- [Linting the Code](#linting-the-code)
- [Running Tests in Development](#running-tests-in-development)
- [Running Automated Tests](#running-automated-tests)
- [Compiling the Binary](#compiling-the-binary)



### Example Dockerfile
```dockerfile
FROM govtechsg/golang:1.11
ARG PROJECT_NAME=app
WORKDIR /go/src/${PROJECT_NAME}
COPY . /go/src/${PROJECT_NAME}
```

Build it with:

```bash
docker build --build-arg PROJECT_NAME=${PROJECT_NAME} -t app .
```

> In example directory: `make build`



### Initialise Dependencies
For initialising a dependency management strategy:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app dep init
```

For ensuring all dependencies are installed:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app dep ensure
```

> In example directory: `make init` (does both depending on whether `dep init` fails)



### Developing with Live-Reload
To start development in live-reload mode, run:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app realize start --run main.go
```

> In example directory: `make run`



### Linting the Code
To lint the project code, run:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app go lint
```

> In example directory: `make lint`



### Running Tests in Development
To run the tests in watch-mode during development, use:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app goconvey
```

> In example directory: `make test.watch`



### Running Automated Tests
To run the tests in a continuous integration pipeline with the coverage being output to `./coverage.out`, use:

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app gotest -v -cover -coverprofile=coverage.out
```

> In example directory: `make test`



### Compiling the Binary

```bash
docker run -v "$(pwd):/go/src/${PROJECT_NAME}" app go build -o app
```

> In example directory: `make compile`





## Notes on Contributing



### Add a Makefile.properties
Copy the `./samples.properties` into a `./Makefile.properties` to get started.

The `./Makefile.properties` file defines three variables, `DOCKERUSER`, `IMAGENAME`, and `DOCKERREGISTRY`.

When building, the image will be labelled with `${DOCKERUSER}/${IMAGENAME}`.

When publishing, the image will be tagged as `${DOCKERREGISTRY}/${DOCKERUSER}/${IMAGENAME}:latest`.





## Forking and Using
The `Makefile.properties` file is not included as part of this project. After forking, you can manually insert your repository's URL using the `Makefile.properties` file before running the `make` commands so that the images get pushed to your own repositories.

- [Example Travis Script](#example-travis-script)



### Example Travis Script

```yaml
sudo:     required
language: bash
services:
  - docker
before_script:
  - docker login -u "${REGISTRY_USERNAME}" -p "${REGISTRY_PASSWORD}";
after_script:
  - docker logout
script:
  # prepare Makefile.properties
  - echo "DOCKERREGISTRY=docker.io" > Makefile.properties
  - echo "DOCKERUSER=govtechsg" >> Makefile.properties
  - echo "IMAGENAME=golang" >> Makefile.properties
  # check if example works
  - make test.example 
  # run the build/publish, see Makefile for more info
  - make publish
```


## License
This project is licensed under the [MIT license](./LICENSE)



# Cheers
