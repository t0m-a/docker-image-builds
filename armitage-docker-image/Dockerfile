FROM kalilinux/kali-linux-docker:latest
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libxext-dev libxrender-dev libxtst-dev
RUN apt-get install -y metasploit-framework armitage man-db exploitdb
RUN export uid=1000 gid=1000
RUN mkdir -p /home/kali-user
RUN echo "kali-user:x:${uid}:${gid}:kali-user,,,:/home/kali-user:/bin/bash" >> /etc/passwd
RUN echo "kali-user:x:${uid}:" >> /etc/group
RUN echo "kali-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN chown ${uid}:${gid} -R /home/kali-user

USER kali-user
ENV home /home/kali-user
ADD bashrc /home/kali-user/.bashrc
ADD bashrc /root/.bashrc
ADD root /root
#ADD armitage-data /usr/share/armitage
ADD database.yml /usr/share/metasploit-framework/config/database.yml
ADD postgresql /var/lib/postgresql
ADD services.sh /services.sh
CMD sh - /services.sh; /usr/bin/armitage
