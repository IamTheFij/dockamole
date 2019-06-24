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
