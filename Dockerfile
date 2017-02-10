FROM alpine:edge
MAINTAINER Senorsen <senorsen.zhang@gmail.com>

ENV GOPATH /go
RUN mkdir -p ${GOPATH}
RUN apk --no-cache add git go bash build-base
COPY 0000-add-git-realip-cors.patch /tmp
RUN go get github.com/mholt/caddy/caddy \
    && go get github.com/abiosoft/caddy-git \
    && go get github.com/captncraig/caddy-realip \
    && go get github.com/captncraig/cors \
    && cd ${GOPATH}/src/github.com/mholt/caddy/caddy \
    && git checkout v0.9.5 \
    && patch caddymain/run.go < /tmp/0000-add-git-realip-cors.patch \
    && ./build.bash \
    && cp caddy /usr/bin/ \
    && rm -rf ${GOPATH}
RUN apk del go bash build-base

COPY Caddyfile /etc/Caddyfile

CMD ["caddy", "--conf", "/etc/Caddyfile"]
