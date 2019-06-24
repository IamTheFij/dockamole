# Dockamole

Example bridging connections across two distinct Docker networks using [`mole`](https://github.com/davrodpin/mole).

My real use case is something like a remote LDAP server that I don't want to expose to the public internet and some metrics servers only available behind a VPN. This setup will allow me to create a proxy container on a host that will act as a local LDAP or HTTP server.

If I get time, I'll draw a diagram as well.

## Running

Requires you to provide your own ssh keys as well as provide the local machine IP address
