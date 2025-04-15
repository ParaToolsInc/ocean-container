## Use this repository to build the Ocean Docker image

### 1. Obtain Rift Source Code
The ParaTools modifications to Rift source code are in a private repository. Clone these sources using a GitHub token, and checkout the **paratools-v1.0** tag.
```
$> git clone https://<USER>:<TOKEN>@github.com/eugeneswalker/rift.git ~/rift
$> git -C ~/rift checkout paratools-v1.0
```

### 2. Place Ocean VM QCOW Images into Central Directory

All Ocean VM images should be placed into a single directory. 
```
$> ls -l ~/ocean-vms
total 12149824
-rw-r----- 1 eugeneswalker eugeneswalker 2466512896 Apr 24 22:54 alma-8.8-v3.8.qcow
-rw-r----- 1 eugeneswalker eugeneswalker 2466512896 Jul 23 18:33 alma-8.8-v3.x.qcow
-rw-r----- 1 eugeneswalker eugeneswalker 1410072576 Jul 24 17:11 centos-7.6.1810-v2.x.qcow
-rw-r----- 1 eugeneswalker eugeneswalker 2093613056 Jul 24 17:11 centos-7.7.1908-v2.8.qcow
-rw-r----- 1 eugeneswalker eugeneswalker 1874984960 Jul 24 17:11 centos-7.9.2009-v2.9.qcow
-rw-r----- 1 eugeneswalker eugeneswalker 2129723392 Jul 11 01:55 centos-9.4-v4.4-x86_64.qcow
```

### 3. Tell the build script how to find Rift source and Ocean VMs from (1) and (2) above

Set the following environment variables to tell the container build script how to find the Rift source code and Ocean VMs from (1) and (2) above.
```
export RIFT_REPO=~/rift
export OCEAN_VM_PATH=~/ocean-vms
```

### 4. Build the Ocean Docker image using the build script

```
$> cd ocean-container/images/fedora-39-v3.x
$> ./build.sh
+ . vars.env
+ cp -r /home/eugeneswalker/rift assets/rift
+ cp /home/eugeneswalker/ocean-vms/alma-8.8-v3.8.qcow assets/.
+ cp /home/eugeneswalker/ocean-vms/alma-8.8-v3.x.qcow assets/.
+ cp /home/eugeneswalker/ocean-vms/centos-7.6.1810-v2.x.qcow assets/.
+ cp /home/eugeneswalker/ocean-vms/centos-7.7.1908-v2.8.qcow assets/.
+ cp /home/eugeneswalker/ocean-vms/centos-7.9.2009-v2.9.qcow assets/.
+ cp /home/eugeneswalker/ocean-vms/centos-9.4-v4.4-x86_64.qcow assets/.
+ docker build -t "ocean-container:fedora39-202508172118" -f ./Dockerfile assets >output.log 2>&1
image build succeeded!
new image name = ocean-container:fedora39-202508172118
```

### 5. Run the Ocean Docker image with proper flags

```
$> docker run \
    -it \
    --privileged \
    --entrypoint /bin/bash \
    --device /dev/kvm \
    --name ocean-container \
    ocean-container:fedora39-202508172118

[root@b643cd62a4a1 ~]# rift --version
rift 0.12
```

### 6. Finished Product

The Ocean Docker image produced by the build script in this repository will have:
* Rift, with ParaTools, Inc. enhancements to enable S3 and HTTP(S) annexes and authentication routines for pushing packages to temporary, S3-based staging annex.
* Rift, with all necessary improvements to support the new GitLab workflow (i.e. `rift gitlab`, updates to `rift validdiff`)
* Pre-requisite system packages for running the RPM Mock tool
* Python environment with the modules needed by enhanced Rift

The Ocean Docker image is used in the GitLab Ocean port and may also be used by contributors to Ocean.
