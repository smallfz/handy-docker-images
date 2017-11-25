FROM centos:7
LABEL app=strongswan

RUN [ -d /work ] || mkdir /work
RUN mkdir /data
VOLUME [ "/data", "/sys/fs/cgroup" ]

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum update -y

RUN echo "(setq backup-inhibited t)" | cat >> /root/.emacs

RUN yum install -y http://mirror.compevo.com/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
RUN yum install -y strongswan haveged firewalld emacs
RUN systemctl enable haveged
RUN systemctl enable firewalld

COPY vars.sh /work/vars.sh
COPY set_fw.sh /work/set_fw.sh
COPY gen_ca_certs.sh /etc/strongswan/ipsec.d/gen_ca_certs.sh
COPY gen_vpn_certs.sh /etc/strongswan/ipsec.d/gen_vpn_certs.sh
RUN chmod +x /work/*.sh
RUN source /work/vars.sh
RUN chmod +x /etc/strongswan/ipsec.d/gen_ca_certs.sh && /etc/strongswan/ipsec.d/gen_ca_certs.sh
RUN chmod +x /etc/strongswan/ipsec.d/gen_vpn_certs.sh
RUN /etc/strongswan/ipsec.d/gen_vpn_certs.sh

RUN echo $'\n: RSA vpnHostKey.der' | cat >> /etc/strongswan/ipsec.secrets
RUN echo $'\nsmall %any% : EAP "small123456"' | cat >> /etc/strongswan/ipsec.secrets

COPY ipsec.conf /etc/strongswan/ipsec.conf
COPY sysctl.conf /etc/sysctl.conf
RUN sysctl -p

EXPOSE 22

ENTRYPOINT [ "/usr/sbin/init" ]
CMD ["true"]

