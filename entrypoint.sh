#!/bin/sh
/usr/local/bin/stubby -g -C /usr/local/etc/stubby/stubby.yml
/usr/sbin/dnsmasq -C /etc/dnsmasq.d/dnsmasq.CONF
tail -f /dev/null
