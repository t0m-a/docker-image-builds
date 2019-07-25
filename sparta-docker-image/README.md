# Sparta Docker Image Kali Linux based #

## Description ##
Default Kali Linux Official container with Secforce Sparta version 1.0.3 and dependencies installed: iptraf net-tools curl gzip bzip2 unzip libxext-dev $
python-pyside.qtwebkit python-qt4 hydra cutycapt nmap

##### Build from the source folder ###
  docker build -t sparta:latest .

##### Before lauching the container
* Modifiy the Dockerfile lines containing the UID and GUID with your Docker user UID and GUID
  The currently used are uid=1000 gid=1000
* On the Docker host running the container, you should allowd at least your docker containers network range to connect to X server:
  sudo xhost +

##### Running a new container from the image
   `docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
   --mount type=bind,src=/path/to/docker/folders/home/kali-user,dst=/home/kali-user \
   sparta:latest`

Please note that:
* We are running the latest Sparta development version due to bugs with QT libraries avoiding the GUI to load properly 
 all the elements.
  You can update or downgrade it by downloading the code directly from Secforce's Sparta Github repository into the tool's folder.
* At that point, cutycapt still provokes non blocking errors while trying to display the screenshots. I am working on it. 

The Dockerfile is available on Github.com here > https://github.com/t0m-a/sparta-docker-image
