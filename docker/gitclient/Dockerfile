FROM alpine:3.12.3

RUN apk update && \
    apk upgrade && \
    apk add git bash && \
    rm -rf /var/cache/apk/*

RUN git config --system user.email "gitclient@git.com"    &&  \
    git config --system user.name "Git Client"

WORKDIR /gitclient
