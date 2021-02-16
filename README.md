# dnsmasq-getdns
Dnsmasq &amp; Getdns Stubby container built out of Alpine linux base image

## To build container:
 (Change directory to the folder where `Dockerfile` is located.
 
 Run:
`docker build -t yangxh/getdns .`

## To run the container:
`docker run -d --restart always --name dnsmasq-getdns --cap-add=NET_ADMIN -p 127.0.0.1:53:53/udp -v <DNSMASQ_CONF_DIR>:/etc/dnsmasq.d -v <HOST_DIRECTORY>:/usr/local/etc/stubby yangxh/getdns`.

There must be a `stubby.yml` configuration file in <HOST_DIRECTORY>. There MUST be at least a main configuration file `dnsmasq.CONF` in <DNSMASQ_CONF_DIR>.

`dnsmasq.CONF` should contain `server=127.0.0.1#8053` (Ex: Dot Stubby listens at port 8053)

An example `stubby.yml` file is provided in the repo.
