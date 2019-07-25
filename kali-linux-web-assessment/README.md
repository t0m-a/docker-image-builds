## Kali Linux Web Assessment Docker Image
##### All versions are based on Kali Linux Official Docker Minimal Image:
https://www.kali.org/news/official-kali-linux-docker-images/

##### What is in the image

From an official Kali Linux minimal Docker image, I have added common useful tools with apt.
* Common tools:
  bmon iftop iptraf nethogs net-tools nmap wireshark htop curl \
  apt-transport-https apt-utils strace sysstat ca-certificates gnupg2 software-properties-common \
  gzip bzip2 whois dnsutils rblcheck unzip vim vim-common vim-runtime httrack 
* Kali Linux Metapackages
  kali-linux-web kali-linux-top10
* Additional applications
  metasploit-framework setoolkit armitage man-db exploitdb
* Dependencies for SET, Metasploit-framework and Armitage in X11 export mode
  python2.7-minimal python3 python-pip pexpect pycrypto requests pyopenssl pefile impacket impacket qrcode pillow libxext-dev libxrender-dev libxtst-dev python-elixir  ldap-utils rwho rsh-client x11-apps finger python-pyside.qtwebkit python-qt4 hydra nmap   libapache2-mod-php python-pefile python-pexpect python-ptyprocess	

##### Before lauching the container
First build the image with:
 docker build -t $IMAGE_NAME:IMAGE_TAG .

##### Metsploit Framework and SET Usage
Run a new container from the image:
 docker run -ti $IMAGE_NAME:IMAGE_TAG 

Run a new container with data persistency
 `docker run -ti --rm \
 --mount type=bind,src=/path/to/your/docker/folder/home/kali-user,dst=/home/kali-user \
 --mount type=bind,src=/path/to/your/docker/folder/data,dst=/data \
 --mount type=bind,src=/path/to/your/docker/folder/root,dst=/root \
 --mount type=bind,src=/path/to/your/docker/folder/postgresql,dst=/var/lib/postgresql \
 $IMAGE_NAME:IMAGE_TAG`

###### Social Engineering Toolkit Nota Bene
In order for some attack vectors to work properly you will need to expose some or all container's ports to host.
Also for remote WAN usage you may need to have these ports open in your firewall too.
In example, Website based attack vectors will need to have at least the port 80 configured properly.

##### Metasploit, SET and Armitage Troubleshouting
It may means that services.sh did not work properly on the container start, please manualy execute following commands :
 /etc/init.d/postgresql start
 msfdb init

##### Armitage Usage
##### Before lauching the container
* Modifiy the Dockerfile lines containing the UID and GUID with your Docker user UID and GUID
  uid=1000 gid=1000
* On the Docker host running the container, you should allowd at least your docker containers network range to connect to X server:
  sudo xhost +

##### Running a new container from the image
   `docker run -ti --rm e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
      --mount type=bind,src=/path/to/your/docker/folder/home/kali-user,dst=/home/kali-user \
      --mount type=bind,src=/path/to/your/docker/folder/data,dst=/data \
      --mount type=bind,src=/path/to/your/docker/folder/root,dst=/root \
      --mount type=bind,src=/path/to/your/docker/folder/postgresql,dst=/var/lib/postgresql \
      $IMAGE_NAME:IMAGE_TAG`

##### Detailed content of Web Metapackage

kali-linux apache2 apache-users	arachni	automater bbqsql beef-xss blindelephant	burpsuite cadaver clusterd cookie-cadger
cutycapt davtest dbpwaudit dirb	dirbuster dnmap	eyewitnessferret-sidejack[i386]	fimap ftester funkload	golismero grabber
hamster-sidejack hexorbase http-tunnel httprint	hydra hydra-gtk	ikat inundator jboss-autopwn jd-gui joomscan jsql laudanum
maltego	maltego-teeth medusa mitmproxy mysql-server ncrack nikto nmap oscanner owasp-mantra-ff padbuster paros patator php5 php5-mysql
plecost	powerfuzzer proxychains	proxystrike proxytunnel	ratproxy recon-ng redsocks sidguesser siege skipfish sqldict[amd64,i386] sqlitebrowser	
sqlmap sqlninja sqlsus sslcaudit ssldump sslh sslscan sslsniff sslstrip sslsplit sslyze	stunnel4 thc-ssl-dos tlssled tnscmd10g ua-testeru niscan
vega[amd64,i386] waffit wapiti webacoo webhandler webscarab webshag webshellswebslayer websploit weevely wfuzz whatweb wireshark wpscan xsser zaprox

##### Detailed content of Kali Top 10 Metapackage

aircrack-ng burpsuite hydra john maltego metasploit-framework nmap zaproxy sqlmap wireshark

##### Blog post
https://tmsi.solutions/2018/06/23/kali-linux-docker-image-web-pentest-metasploit-and-set/
##### Docker Repository
https://hub.docker.com/r/simonthomas/kali-linux-web-assessment/
