ARG REPO=library
FROM ${REPO}/alpine

COPY --from=multiarch/qemu-user-static /usr/bin/qemu-* /usr/bin/

# Install SSH and set up basic config
RUN apk add openssh-server augeas

# Create sshd configs
RUN mkdir /var/run/sshd
# Allow providing authorized_keys to ~/mole/.ssh/authorized_keys or to /etc/authorized_keys/<user>
RUN augtool 'set /files/etc/ssh/sshd_config/AuthorizedKeysFile ".ssh/authorized_keys /etc/authorized_keys/%u"'
# Prevent running commands or getting an X11 session
RUN augtool 'set /files/etc/ssh/sshd_config/ForceCommand echo no-commands-allowed'
RUN augtool 'set /files/etc/ssh/sshd_config/X11Forwarding no'
# Prevent logging in as root user or with a password
RUN augtool 'set /files/etc/ssh/sshd_config/PermitRootLogin no'
RUN augtool 'set /files/etc/ssh/sshd_config/PasswordAuthentication no'
# Use a non-reserved port so we can run as a non-root user
RUN augtool 'set /files/etc/ssh/sshd_config/Port 2222'
# Ensure we can forward TCP
RUN augtool 'set /files/etc/ssh/sshd_config/AllowTcpForwarding yes'

EXPOSE 2222

# Create mole user
RUN adduser --system --home /mole mole
USER mole
RUN mkdir -p /mole/.ssh

CMD ["/usr/sbin/sshd", "-D"]
