## The Harvester Docker Image Kali Linux based

## Read Me ##
This will enable the use of The Harvester Information Gathering Tool in a Bash shell.
Just type `theharvester -d domain.name` once the container is running.
##### Build from the cloned repository ###
 (sudo) docker build -t theharvester:latest .

##### Before lauching the container ###
* Modifiy the Dockerfile lines containing the UID and GUID with your Docker user UID and GUID.

   Currently used UIDs are: uid=1000 gid=1000

##### Running a new container from the image ###
    docker run -ti --rm \
    --mount type=bind,src=/path/to/docker/folders/root,dst=/root \
    --mount type=bind,src=/path/to/docker/folders/home/kali-user,dst=/home/kali-user \
    theharvester:latest

##### Running a new container without data persistency
    docker run -ti --rm theharvester:latest

You can view the image detailed information on my Docker repository:
https://hub.docker.com/r/simonthomas/theharvester/
