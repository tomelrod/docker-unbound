#!/bin/sh

if [ ! -e /etc/unbound/trusted-key.key ]; then
    cp /usr/share/dnssec-root/trusted-key.key /etc/unbound/
fi
if wget -O /tmp/root.hints https://www.internic.net/domain/named.cache; then
    cat /tmp/root.hints > /etc/unbound/root.hints
else
    touch /etc/unbound/root.hints
fi

exec $@
