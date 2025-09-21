## Contributing

Overview of steps:
1. [Obtain the Ocean Docker Image](#1-obtain-the-ocean-docker-image)
2. [Launch a container using the Ocean Docker image](#2-launch-the-container)
3. [Clone the Ocean sources](#3-clone-the-ocean-sources)
4. [Make your source modifications](#4-make-your-modifications)
5. Test your changes, locally
6. Submit your changes for review via a merge-request

### 1. Obtain the Ocean docker image

```
# 1. Download the image
$> wget -q https://cache.e4s.io/ocean/paratools-ocean-container-latest.tgz

# 2. Load the image into Docker
$> docker load --input paratools-ocean-container-latest.tgz
Loaded image: ocean-container:latest

# 3. You should now see the image
$> docker images | grep ocean-container
REPOSITORY                  TAG            IMAGE ID       CREATED         SIZE
ocean-container             latest         81339e29b027   4 days ago      15.4GB
```


### 2. Launch the container

```
$> docker run -it --privileged --device /dev/kvm --name ocean ocean-container:latest

[root@85763b49a628 ~]# rift --version
rift 0.12

[root@85763b49a628 ~]# cat /etc/os-release
NAME="Fedora Linux"
VERSION="39 (Container Image)"
ID=fedora
VERSION_ID=39
VERSION_CODENAME=""
PLATFORM_ID="platform:f39"
PRETTY_NAME="Fedora Linux 39 (Container Image)"
```


### 3. Clone the Ocean sources

In this example we use a Personal Access Token (PAT) to clone the Ocean sources.

To obtain a PAT, see the instructions here:
* https://docs.gitlab.com/user/profile/personal_access_tokens/#create-a-personal-access-token

```
$> docker run -it --privileged --device /dev/kvm --name ocean ocean-container:latest

[root@85763b49a628 ~]# TOKEN_NAME=...
[root@85763b49a628 ~]# TOKEN_VALUE=...
[root@85763b49a628 ~]# git clone https://$TOKEN_NAME:$TOKEN_VALUE@gitlab-forge.ccc.ocre.cea.fr/paratools/ocean.git
Cloning into 'ocean'...
remote: Enumerating objects: 19848, done.
remote: Counting objects: 100% (34/34), done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 19848 (delta 15), reused 0 (delta 0), pack-reused 19814 (from 1)
Receiving objects: 100% (19848/19848), 41.67 MiB | 34.84 MiB/s, done.
Resolving deltas: 100% (8103/8103), done.

[root@498abeb8f3f3 ~]# cd ocean
[root@498abeb8f3f3 ocean]# git branch
* master
```


### 4. Make your modifications

Here we will create a new branch
