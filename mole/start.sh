#! bin/bash

mole -v \
    -local ${MOLE_LOCAL} \
    -remote ${MOLE_REMOTE} \
    -server ${MOLE_SERVER} \
    -key ~/.ssh/id_rsa \
    -insecure
