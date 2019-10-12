FROM golang:1.12.6-stretch

WORKDIR /app

ENV GOOS="linux"
ENV GOARCH="amd64"
ENV GO111MODULE="on"

RUN go get -u golang.org/x/lint/golint
COPY build/ci/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
