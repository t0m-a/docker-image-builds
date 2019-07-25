## DNS Footprinting Docker Image Kali Linux based

## Read Me ##
#### What is in this image?
 We will install text mode tools on an Officiel Kali Linux Docker Image:
 dnsenum dnsutils tcptraceroute whois dmitry nmap hping3 arping fping amap unicornscan net-tools
 This will enable to enumerate machines based on ICMP, ARP, IP and DNS Protocols

##### Build from the cloned repository ###
 (sudo) docker build -t kali-dns:latest .

##### Before lauching the container ###
* Modifiy the Dockerfile lines containing the UID and GUID with your Docker user UID and GUID.

   Currently used UIDs are: uid=1000 gid=1000

##### Running a new container from the image ###
    docker run -ti --rm \
    --mount type=bind,src=/path/to/docker/folders/root,dst=/root \
    --mount type=bind,src=/path/to/docker/folders/home/kali-user,dst=/home/kali-user \
    kali-dns:latest

##### Running a new container without data persistency
    docker run -ti --rm kali-dns:latest

You can view the image detailed information on my Docker repository:
https://hub.docker.com/r/simonthomas/kali-dns/
