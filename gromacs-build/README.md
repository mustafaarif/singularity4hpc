# Building Gromacs Container with MPI Support

GROMACS is a versatile package to perform molecular dynamics, i.e. simulate the Newtonian equations of motion for systems with hundreds to millions of particles.

This example demonstrates building Gromacs Package with MPI support inside a container and porting it to HPC system "raad2"


## Step 01
Explore Gromacs website and identify package requirements.
http://manual.gromacs.org/documentation/2020/install-guide

Note: You can skip Step 02 and Step 03, if you already have a MPICH base container. Instead issue following to make a copy of exisiting MPICH base container
```sh
$ mkdir -p ~/container-builds/gromacs/ && cd ~/container-builds/gromacs/

$ singularity build --sandbox gromacs2020 ~/container-builds/mpich/mpich33
```

## Step 02
Prepare sandbox container with development packages installed. You dont have to do this step if you are using base MPICH container which was already built.

```sh
$ sudo su - 

$ mkdir -p ~/container-builds/gromacs2020 && cd ~/container-builds/gromacs2020

$ singularity build --sandbox gromacs2020 docker://ubuntu:18.04

$ singularity shell --writable gromacs2020

Singularity> apt-get update

Singularity> export DEBIAN_FRONTEND=noninteractive

Singularity> apt-get -y install build-essential wget nano git locales-all tzdata

Singularity> ln -fs /usr/share/zoneinfo/Asia/Qatar /etc/localtime
```

## Step 03
Install MPICH inside the container. You dont have to do this step if you are using base MPICH container which was already built.
```sh
Singularity> export MPICH_VERSION=3.3

Singularity> export MPICH_URL="http://www.mpich.org/static/downloads/$MPICH_VERSION/mpich-$MPICH_VERSION.tar.gz"

Singularity> mkdir -p /tmp/downloads

Singularity> cd /tmp/downloads && wget -O mpich-$MPICH_VERSION.tar.gz $MPICH_URL && tar xzf mpich-$MPICH_VERSION.tar.gz

Singularity> cd /tmp/downloads/mpich-$MPICH_VERSION

Singularity> ./configure
# Did config failed? Are we missing any package? Hint: apt-get install gfortran

Singularity> make -j 4

Singularity> make install

Singularity> exit
```

## Step 04
Download and build Gromacs
```sh
$ cd ~/container-builds/gromacs

$ singularity shell --writable ~/container-builds/gromacs/gromacs2020

Singularity> mkdir -p /tmp/downloads

Singularity> cd /tmp/downloads && wget http://ftp.gromacs.org/pub/gromacs/gromacs-2020.tar.gz

Singularity> tar -xvzf /tmp/downloads/gromacs-2020.tar.gz

Singularity> cd /tmp/downloads/gromacs-2020

Singularity> mkdir build && cd build

Singularity> cmake .. -DGMX_BUILD_OWN_FFTW=ON -DCMAKE_C_COMPILER=mpicc -DCMAKE_CXX_COMPILER=mpicxx -DGMX_MPI=on
# Did you get error that cmake not found? Hint: apt-get install cmake

Singularity> make -j 4

Singularity> make install
```

## Step 05
Setup environment variables inside the container

Gromacs supplies a bash script which should be exectued before launching Gromacs simulation.
However when you are running singularity on raad2 on multi-node it is not possible to interactively set environment variables. Therefore we need to identify which variables are required and set them in container in advance. This approach applies to various other packages which supply scripts to setup environment.

```sh
Singularity> cd /.singularity.d/
Singularity> touch 99-gromacs2020.sh
# Open '99-gromacs2020.sh' via nano or vim editor and paste below variables;
LD_LIBRARY_PATH=/usr/local/gromacs/lib:$LD_LIBRARY_PATH
GMXBIN=/usr/local/gromacs/bin
GMXDATA=/usr/local/gromacs/share/gromacs
GMXLDLIB=/usr/local/gromacs/lib
GMXMAN=/usr/local/gromacs/share/man
PATH=/usr/local/gromacs/bin:$PATH
PKG_CONFIG_PATH=/usr/local/gromacs/lib/pkgconfig:$PKG_CONFIG_PATH
GROMACS_DIR=/usr/local/gromacs
```

## Step 06

Convert Sandbox Container to Production ready container (.sif image)
```sh
# Make your container production ready by converting sandbox to non-writable image file
$ singularity build ~/container-builds/gromacs2020/gromacs2020.sif ~/container-builds/gromacs2020

# Move container to /tmp so that it can be accessed via student account over scp

$ mv ~/container-builds/gromacs2020/gromacs2020.sif /tmp

$ chown student:student /tmp/gromacs2020.sif
```

## Step 07
Transfer container to HPC system raad2
```sh
# From your local system where you have VPN connection to TAMUQ established, do ssh to raad2 and issue following;

raad2a:~ $ mkdir -p ~/opt/gromacs/2020/bin
raad2a:~ $ cd ~/opt/gromacs/2020/bin
raad2a:~ $ scp -P <port> student@ml-xx.southcentralus.cloudapp.azure.com:/tmp/gromacs2020.sif .

# Verify version of Tensorflow and Python inside the container
raad2a:~ $ singularity exec ~/opt/gromacs/2020/bin/gromacs2020.sif gmx_mpi --version
```

## Step 08
Make this container act like system native application

* Write a wrapper script which takes all the arguments and pass them to container via exec command
* Create soft link to this wrapper of all possible executables your application has to offer

```sh
raad2a:~ $ ~/workshops/containers-hpc/gromacs-build/gromacs.sh ~/opt/gromacs/2020/bin
raad2a:~ $ ln -s ~/opt/gromacs/2020/bin/gromacs.sh gmx_mpi
raad2a:~ $ export PATH=~/opt/gromacs/2020/bin:$PATH
```
Now see if we call gmx_mpi natively on system;
```sh
raad2a:~ $ gmx_mpi --version
```
## Create Batch Job file to run computation on multiple nodes

Inspect slurm.job in this directory;

```sh
sbatch slurm.job
cat slurm-<jobid>.out
```

