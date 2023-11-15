FROM shihou/vyos_14:latest
RUN setcap cap_net_admin=ep /sbin/tc
COPY config.boot opt/vyatta/etc/config/
