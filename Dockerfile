FROM golang:1.13.0-buster

WORKDIR /go/src

# add apt dependencies 
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# install tools
RUN apt-get update
RUN apt-get -y install zip unzip

# install protocol buffers
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.9.1/protoc-3.9.1-linux-x86_64.zip
RUN unzip protoc-3.9.1-linux-x86_64.zip -d protoc3
RUN mv protoc3/bin/* /usr/local/bin/
RUN mv protoc3/include/* /usr/local/include/
RUN go get -u github.com/golang/protobuf/protoc-gen-go

# install grpc for golang lib
RUN go get -u google.golang.org/grpc

# build synerex daemon
WORKDIR /go/src/github.com/synerex/provider/harmovis
COPY . .
RUN sed -i 's/\r//' ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

EXPOSE 10080

ENTRYPOINT [ "./entrypoint.sh" ]
