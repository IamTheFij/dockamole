FROM alpine

RUN apk add bash curl tar
RUN bash -c "bash <(curl -fsSL https://raw.githubusercontent.com/davrodpin/mole/master/tools/install.sh | sed 's/\bsudo\b//g')"

RUN mkdir /mole
RUN adduser -S -h /mole mole

USER mole

RUN mkdir -p /mole/.ssh
RUN touch /mole/.ssh/config

COPY ./start.sh ./

CMD ./start.sh
