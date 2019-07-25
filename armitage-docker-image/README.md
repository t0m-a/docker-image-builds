## Armitage Docker Image Kali Linux based

## Read Me ##

## UPDATE: 20180628 ##
From the Official Kali Linux Docker Image we will install X11 dependencies to export the GUI: libxext-dev libxrender-dev libxtst-dev. And then install metasploit-framework armitage man-db and exploitdb.

The repository has been updated with a postgresql data folder containing an empty MSFDB for data persistency and a database.yml configuration file for the init process. You may have to use sudo to buid the image due to the database import from host.

##### Build from the cloned repository ###
 (sudo) docker build -t armitage:latest .

##### Before lauching the container ###
* Modifiy the Dockerfile lines containing the UID and GUID with your Docker user UID and GUID.

   Currently used UIDs are: uid=1000 gid=1000

* On the Docker host running the container, you should allow at least your docker containers network range to connect to X server:

  sudo xhost +

##### Running a new container from the image ###
    docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    --mount type=bind,src=/path/to/docker/folders/root,dst=/root \
    --mount type=bind,src=/path/to/docker/folders/armitage-data,dst=/usr/share/armitage \
    --mount type=bind,src=/path/to/docker/folders/home/kali-user,dst=/home/kali-user \
    --mount type=bind,src=/path/to/docker/folders/postgresql,dst=/var/lib/postgresql \
    $IMAGE_NAME:IMAGE_TAG

##### Running a new container without data persistency
    docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix armitage


UPDATE: With configured data persistency, you NO LONGER need to connect to the container just right after Armitage poped up and before you click on login and launch postgresql database server (/etc/init.d/postgresql start) or initiate the metasploit framework database for its firt run (msfdb init). 

It is already taken care of by the init script services.sh accordingly to the content of the postgresql folder and the database.yml file.

But, you still can connect to metasploit framework to check everything is ok and build database cache if you'd like to.
   msfconsole
   db_rebuild_cache

You can view the image detailed information on my Docker repository:
https://hub.docker.com/r/simonthomas/armitage/
