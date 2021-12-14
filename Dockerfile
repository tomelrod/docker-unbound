# Original credit:
# - https://github.com/gkweb76/unbound
FROM alpine:latest
LABEL maintainer="Elrod <elrod@thomaselrod.com>"

# Install openvpnUnbound and setup permissions
RUN apk add --update --no-cache unbound && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* && \
    chown unbound:unbound /usr/share/dnssec-root/trusted-key.key && \
    chmod 664 /usr/share/dnssec-root/trusted-key.key && \
    chown -R unbound:unbound /etc/unbound

# add entrypoint
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

# Healtcheck
HEALTHCHECK --start-period=15s --interval=30s --timeout=3s --retries=3 CMD nslookup icann.org 127.0.0.1 || exit 1

# Port available
EXPOSE 53/udp 53/tcp

# Volume where are located config files, must contain unbound.conf
VOLUME ["/etc/unbound"]

# Start unbound daemon
ENTRYPOINT ["/entrypoint.sh"]
CMD ["unbound", "-c", "/etc/unbound/unbound.conf"]
