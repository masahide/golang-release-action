FROM golang:1.17

LABEL name="Golang Release Action"
LABEL maintainer="YAMASAKI Masahide"
LABEL version="0.1.0"
LABEL repository="https://github.com/masahide/golang-release-action"

LABEL com.github.actions.name="Golang Release Action"
LABEL com.github.actions.description="Action for golang binary release"
LABEL com.github.actions.icon="box"
LABEL com.github.actions.color="blue"

RUN apt-get update && apt-get install -y \
    jq \
    zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
