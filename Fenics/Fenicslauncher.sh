#!/bin/bash
# Fenics Launcher version # 0.1b 
# Author: mustafa.arif@qatar.tamu.edu
# Group: Research Computing @ TAMUQ

if [ $# -eq 0 ]
  then
      printf "Please provide raad2 username.\n Usage: fenicslauncher <username> \n e.g. fenicslauncher kevin876\n"
      read -p 'Username: ' uservar
      usr=$uservar
  else
      usr=$1
  fi

printf "Connecting to raad2 to get port number for Jupyter Lab \n"

port=`ssh -t -Y $usr@raad2-login2 "echo $((50000 + RANDOM % $UID))"`
port=`echo $port | tr -d '\r'`
printf "Port number fetched: $port\n"

printf "Launching Fenics Project\n"

ssh -t -Y -L $port:localhost:$port $usr@raad2-login2 "export SINGULARITYENV_Jport=$port; srun --pty --tunnel=$port:$port --time=04:00:00 --qos=sl --job-name=FenicsProj --partition=s_long --ntasks=1 --cpus-per-task=4 --hint=nomultithread --gres=craynetwork:0 singularity shell --network-args portmap=$port:$port/tcp /lustre/sw/xc40ac/fenics/fenics.exe"
