FROM kalilinux/kali-linux-docker:latest
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libxext-dev libxrender-dev libxtst-dev bmon iftop iptraf nethogs net-tools nmap wireshark htop curl apt-transport-https apt-utils \
strace sysstat ca-certificates gnupg2 software-properties-common gzip bzip2 whois dnsutils rblcheck unzip vim vim-common vim-runtime httrack \
python2.7-minimal python3 python-pip pexpect pycrypto requests pyopenssl pefile impacket impacket qrcode pillow libxext-dev libxrender-dev libxtst-dev \
python-elixir ldap-utils rwho rsh-client x11-apps finger python-pyside.qtwebkit python-qt4 hydra nmap libapache2-mod-php python-pefile python-pexpect \
python-ptyprocess metasploit-framework setoolkit armitage kali-linux-web kali-linux-top10 man-db exploitdb
RUN export uid=1000 gid=1000
RUN mkdir -p /home/kali-user
RUN echo "kali-user:x:${uid}:${gid}:kali-user,,,:/home/kali-user:/bin/bash" >> /etc/passwd
RUN echo "kali-user:x:${uid}:" >> /etc/group
RUN echo "kali-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN chown ${uid}:${gid} -R /home/kali-user
USER kali-user
ENV home /home/kali-user
ADD data /data
ADD root /root
ADD database.yml /usr/share/metasploit-framework/config/database.yml
ADD postgresql /var/lib/postgresql
ADD services.sh /services.sh
CMD sh - /services.sh; /bin/bash
