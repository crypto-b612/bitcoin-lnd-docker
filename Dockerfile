FROM ubuntu:latest
MAINTAINER Crypto B612 "crypto.b612@gmail.com"

# Install dependencies for compiling Bitcoin
USER root
RUN apt-get update
RUN apt-get install -y golang-1.10-go git-core

RUN useradd -ms /bin/bash lnd
USER lnd
WORKDIR /home/lnd

RUN mkdir /home/lnd/gocode
ENV GOPATH /home/lnd/gocode
ENV PATH $GOPATH/bin:/usr/lib/go-1.10/bin:$PATH

RUN go get -u github.com/golang/dep/cmd/dep

# Clone lightning code
RUN git clone https://github.com/lightningnetwork/lnd $GOPATH/src/github.com/lightningnetwork/lnd
WORKDIR  $GOPATH/src/github.com/lightningnetwork/lnd
RUN dep ensure
RUN go install . ./cmd/...

CMD lnd
