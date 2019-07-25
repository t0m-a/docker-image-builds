FROM kalilinux/kali-linux-docker:latest
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y curl net-tools theharvester python-pip
RUN pip install requests
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
CMD echo "Type theharvester command"; /bin/bash
