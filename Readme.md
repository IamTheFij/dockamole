# Dockamole

Example bridging connections across two distinct Docker networks using [`mole`](https://github.com/davrodpin/mole).

My real use case is something like a remote LDAP server that I don't want to expose to the public internet and some metrics servers only available behind a VPN. This setup will allow me to create a proxy container on a host that will act as a local LDAP or HTTP server.

Eg.

```
+----------+          +----------+          +----------+
|          |          |          |          |          |
|          |          | Firewall |          |          |
|          |          |          |          |          |
|  Local   |  tunnel  +----------+  tunnel  |  Remote  |
| Computer |--------------------------------|   SSH    |
|          |          +----------+          |  Server  |
|          |          |          |          |          |
|          |          | Firewall |          |          |
|          |          |          |          |          |
+----------+          +----------+          +----------+
                                                 |
                                                 |
                                                 | tunnel
                                                 |
                                                 |
                                            +----------+
                                            |          |
                                            |          |
                                            |          |
                                            |          |
                                            |  Remote  |
                                            |  Service |
                                            |          |
                                            |          |
                                            |          |
                                            +----------+
```

## Running

Requires you to provide your own ssh keys as well as provide the local machine IP address

Dockamole is configured using environment variables:

    # Required
    MOLE_LOCAL_?        indexed local host and port
    MOLE_REMOTE_?       indexed remote host and port
    MOLE_SERVER         ssh server to connect to
    # Optional
    MAX_TUNNELS         number of tunnels allowed (default 10)
    SSH_KEY             path to ssh private key that should be used (default ~/.ssh/id_rsa)

## Use in production

This example uses [panubo/sshd](https://github.com/panubo/docker-sshd), which seems well maintained enough. I would advise caution though as this is likely something that will have access to sensitive information.

To be safe you should take precautions from someone logging into your server directly.  In my example, I'm using the following as my `authorized_keys` file:

    no-pty,no-X11-forwarding,command="/bin/echo do-not-send-commands" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeG0iBsd5P9ZwDlav7mWaMGiq4SH5XvYGEGoZPgC3PjKgiEpe5lxH9p5lOFicqG7nNBaTwJwDPnJJaIIeHeCcpKF9f5RhTA5rwLkPcVIwZTh2GL7PD/yDmnsB1L8v04yTzjvJxHAi+xx+yN0fcxw2IOJ4k4FC1mNJKNwHZZHvzEyvRbC0GUB1K32dKSDUAWQHKx7xJqgtpkZ0DV78GzBfNUZcucImRwjQTBlJFumTjB5k0xUt0NRDLEkHwUMyiAeXB13tfjZipEHCWPxIrQnuwmV4Lb3VFbh8UqeObsarxG9t+SMoxnrKxQCAntcS0do1VjfiGr6usGVsV56ua8Tyj ifij@C02V7083HV2V

This prevents getting a shell if my key is ever leaked.

Additionally, if you are actually planning on doing this in production, do not use the `-insecure` flag in ./mole/start.sh`. Instead you should provide pre generated server keys and add those as known hosts for `mole`.
