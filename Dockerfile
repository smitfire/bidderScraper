# Build Stage
FROM lacion/alpine-golang-buildimage:1.13 AS build-stage

LABEL app="build-bidderScraper"
LABEL REPO="https://github.com/voodoolabs/bidderScraper"

ENV PROJPATH=/go/src/github.com/voodoolabs/bidderScraper

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

ADD . /go/src/github.com/voodoolabs/bidderScraper
WORKDIR /go/src/github.com/voodoolabs/bidderScraper

RUN make build-alpine

# Final Stage
FROM lacion/alpine-base-image:latest

ARG GIT_COMMIT
ARG VERSION
LABEL REPO="https://github.com/voodoolabs/bidderScraper"
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL VERSION=$VERSION

# Because of https://github.com/docker/docker/issues/14914
ENV PATH=$PATH:/opt/bidderScraper/bin

WORKDIR /opt/bidderScraper/bin

COPY --from=build-stage /go/src/github.com/voodoolabs/bidderScraper/bin/bidderScraper /opt/bidderScraper/bin/
RUN chmod +x /opt/bidderScraper/bin/bidderScraper

# Create appuser
RUN adduser -D -g '' bidderScraper
USER bidderScraper

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/opt/bidderScraper/bin/bidderScraper"]
