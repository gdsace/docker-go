ARG ALPINE_VERSION="3.8"
FROM alpine:${ALPINE_VERSION}
LABEL maintainer="dev@joeir.net" \
      version="1.0.0" \
      description="A minimal Go base image to build Go applications with."
ARG GO_VERSION="go1.9.3"
ENV APK_TO_INSTALL="bash curl git gcc g++ make linux-headers binutils-gold gnupg" \
    APK_TO_REMOVE="bash curl git gcc g++ make linux-headers binutils-gold gnupg" \
    GO_REPO_URL="https://go.googlesource.com/go" \
    GO_VERSION_LAST_C_TOOLCHAIN="go1.4" \
    GOROOT_BOOTSTRAP="/usr/local/go" \
    GOPATH="/app" \
    PATHS_TO_REMOVE="\
      /tmp/* \
      /usr/include/* \
      /usr/share/man/* \
      /var/cache/apk/*" \
    SYSTEM_BIN_PATH=/usr/local/bin/
WORKDIR /tmp
COPY ./version-info /usr/bin/
RUN apk add --update --upgrade --no-cache ${APK_TO_INSTALL} \
    && curl -sSL https://golang.org/dl/ | egrep "go[0-9]+\.[0-9]+\.[0-9]+" | grep "div class=\"toggleVisible" | head -n 1 | cut -d ' ' -f 3 | cut -d '"' -f 2 > /tmp/go_version \
    && git clone ${GO_REPO_URL} \
    && cp -r go go1.4 \
    && cd /tmp/go1.4/src \
    && git checkout release-branch.${GO_VERSION_LAST_C_TOOLCHAIN} \
    && ./make.bash \
    && cd /tmp/go/src \
    && mv /tmp/go1.4 ${GOROOT_BOOTSTRAP} \
    && git checkout $(cat /tmp/go_version) \
    && ./make.bash \
    && rm -rf ${GOROOT_BOOTSTRAP} \
    && mv /tmp/go ${GOROOT_BOOTSTRAP} \
    && ln -s ${GOROOT_BOOTSTRAP}/bin/go ${SYSTEM_BIN_PATH} \
    && ln -s ${GOROOT_BOOTSTRAP}/bin/gofmt ${SYSTEM_BIN_PATH} \
    && go get -u -v golang.org/x/tools/cmd/callgraph \
    && go get -u -v golang.org/x/tools/cmd/cover \
    && go get -u -v golang.org/x/tools/cmd/gorename \
    && go get -u -v golang.org/x/tools/cmd/guru \
    && go get -u -v golang.org/x/tools/cmd/godoc \
    && go get -u -v golang.org/x/tools/cmd/goimports \
    && go get -u -v golang.org/x/tools/cmd/gorename \
    && go get -u -v golang.org/x/tools/cmd/stress \
    && go get -u -v golang.org/x/tools/go/ast/astutil \
    && go get -u -v golang.org/x/tools/go/buildutil \
    && go get -u -v golang.org/x/tools/go/callgraph \
    && go get -u -v golang.org/x/tools/go/loader \
    && go get -u -v golang.org/x/tools/go/pointer \
    && go get -u -v golang.org/x/tools/go/ssa \
    && go get -u -v golang.org/x/tools/godoc/analysis \
    && go get -u -v golang.org/x/tools/godoc/redirect \
    && go get -u -v golang.org/x/tools/godoc/static \
    && go get -u -v golang.org/x/tools/godoc/util \
    && go get -u -v golang.org/x/tools/refactor/satisfy \
    && go get -u -v sourcegraph.com/sqs/goreturns \
    && go get -u -v github.com/golang/lint/golint \
    && chmod +x /usr/bin/version-info \
    && apk del ${APK_TO_REMOVE} \
    && rm -rf ${PATHS_TO_REMOVE}
WORKDIR ${GOPATH}
USER root