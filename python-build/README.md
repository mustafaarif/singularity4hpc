# Building Python inside the container

There are various options to satisfy Python build requirements.

* Find out if there is any official Python container which provides Python 3.8.2 (recommended)
  * Quick build with least effort.
* Otherwise, build Python on top of desired OS.
  * Requires effort, but offers flexibility of choosing various optimization parameters.
  
## Step 01: Build sandbox container

### Option 01 (Build from Python Container)

Explore https://hub.docker.com and identify if Python 382 tag is available.

From your local workstation using terminal/mobaxterm, log in to Dev workstation;

```sh
# Become sudo
$ sudo su - 

# Create a build directory - its good to keep your builds organized
$ mkdir -p ~/container-builds/python && cd ~/container-builds/python

# Did you find Python 382 on Docker? Replace <tag> with tag found on Docker Hub.
$ singularity build --sandbox py382docker docker://python:<tag>

# At this stage, check the size of the container you have downloaded and take a note.
$ du -hs ~/container-builds/python/py382docker

# Connect to container with writable flag because we are going to make some custom changes.
$ singularity shell --writable ~/container-builds/python/py382docker

# Update repo signatures
Singularity> apt-get update

# Install dependencies
Singularity> apt-get -y install wget git vim nano

# Install Python Packages as required
Singularity> pip3 --no-cache-dir install tensorflow pandas keras scikit-learn

# Check if Tensorflow is working as expected inside the container. The import command will not return anything if successful.
Singularity> python3 -c 'import tensorflow as tf'

# Exit fromt he container
Singularity> exit

# Check the size of the container after customizing your container with requirements;
$ du -hs ~/container-builds/python/py382docker

```

### Option 02 (Build from Source)
Log in to Dev workstation;
```sh

sudo su - 

mkdir -p ~/container-builds/python && cd ~/container-builds/python

singularity build --sandbox py382 docker://ubuntu:18.04

singularity shell --writable py382

apt-get update

apt-get -y install build-essential gfortran wget nano

mkdir -p /tmp/downloads && cd /tmp/downloads

wget https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz

tar -xvf Python-3.8.2.tar.xz

cd Python-3.8.2 && mkdir build && cd build

../configure --enable-optimizations --with-ensurepip=install

make -j 4

make install

```
## Step 02

Convert Sandbox Container to Production ready container (.sif image)

```sh
# Make your container production ready by converting sandbox to non-writable image file
$ singularity build ~/container-builds/python/py382docker.sif ~/container-builds/python/py382docker

# Move container to /tmp so that it can be accessed via student account over scp
$ mv ~/container-builds/python/py382docker.sif /tmp
$ chown student:student /tmp/py382docker.sif
```

## Step 03

Transfer container to HPC system raad2

```sh
# From your local system where you have VPN connection to TAMUQ established, do ssh to raad2 and issue following;
# We will be storing all over container builds under /opt in our home directory on raad2
raad2a:~ $ mkdir -p ~/opt/python/382

raad2a:~ $ cd ~/opt/python/382

raad2a:~ $ scp -P <port> student@ml-xx.southcentralus.cloudapp.azure.com:/tmp/py382docker.sif ~/opt/python/382/

# Verify version of Tensorflow and Python inside the container
raad2a:~ $ singularity exec ~/opt/python/382/py382docker.sif python3 -c 'import tensorflow as tf; print(tf.__version__)'

# Run sample application provided in this directory
raad2a:~ $ singularity exec ~/opt/python/382/py382docker.sif python3 linearreg.py 
```

## Submit your application as SLURM Batch Job

Inspect slurm.job file in this directory and make any changes if required;

```sh
$ sbatch slurm.job
$ cat slurm-<jobid>.out
```
