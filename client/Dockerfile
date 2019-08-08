FROM alpine

# Install latest mole
RUN apk --no-cache add bash curl tar openssh-client && \
        bash -c "bash <(curl -fsSL https://raw.githubusercontent.com/davrodpin/mole/master/tools/install.sh | sed 's/\bsudo\b//g')" && \
        apk del curl tar

RUN mkdir /mole
RUN adduser -S -h /mole mole

USER mole

RUN mkdir -p /mole/.ssh
RUN touch /mole/.ssh/config
# Make a volume to persist keys
VOLUME /mole/.ssh

ENV GEN_KNOWN_HOSTS=1

COPY ./start.sh ./

CMD ./start.sh
