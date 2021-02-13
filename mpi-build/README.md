# Building container with MPICH

The Message Passing Interface (MPI) is a standard extensively used by HPC applications to implement various communication across compute nodes of a single system or across compute platforms. There are two main open-source implementations of MPI at the moment - OpenMPI and MPICH, both of which are supported by Singularity.

In this tutorial users will learn how to build a base container with MPICH installed. This container can be used as a starting point for other packages which requires MPI support.
We will also port this container to raad2 and will test a sample MPI C application 

## Step 01
Prepare a sandbox container and install build requirements. Login to development workstation and issue following commands;

```sh
$ sudo su - 

$ mkdir -p ~/container-builds/mpich && cd ~/container-builds/mpich

$ singularity build --sandbox mpich33 docker://ubuntu:18.04

$ singularity shell --writable ~/container-builds/mpich/mpich33

Singularity> apt-get update

Singularity> export DEBIAN_FRONTEND=noninteractive

Singularity> apt-get -y install build-essential wget nano git locales-all tzdata

Singularity> ln -fs /usr/share/zoneinfo/Asia/Qatar /etc/localtime
```

## Step 02
Install MPICH inside the container

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
```

# Step 03
Convert Sandbox Container to Production ready container (.sif image)

```sh
$ singularity build mpich33.sif mpich33

$ mv mpich33.sif /tmp/

$ chown student:student /tmp/mpich33.sif
```

# Step 04
Copy production ready container to raad2

```sh
# From your local system where you have VPN connection to TAMUQ established, do ssh to raad2 and issue following;

raad2a:~ $ mkdir -p ~/opt/mpich/33

raad2a:~ $ cd ~/opt/mpich/33

raad2a:~ $ scp -P <port> student@ml-xx.southcentralus.cloudapp.azure.com:/tmp/mpich33.sif ~/opt/mpich/33/mpich33.sif

# Verify version of mpiexec
raad2a:~ $ singularity exec ~/opt/mpich/33/mpich33.sif mpiexec --version

# Run sample application provided in this directory
raad2a:~ $ singularity exec ~/opt/mpich/33/mpich33.sif mpicc -o pi.out pi.c

raad2a:~ $ singularity exec ~/opt/mpich/33/mpich33.sif ./pi.out
```
# Step 05
Submit a batch job which spans over 02 nodes to verify that if MPI communication is working fine

Inspect slurm.job file placed in this directory

```sh
raad2a:~ $ sbatch slurm.job
raad2a:~ $ cat slurm-<jobid>.out
```

