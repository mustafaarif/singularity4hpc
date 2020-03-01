#!/bin/bash

echo "# Welcome to FEniCS Project
Fenics Build: `fenics-version`
This is a customized build for raad2 on top of FEniCS docker container.
If this is the first time you are luanching FEniCS on raad2, you should first copy demo files to your home directory
  cp -R /usr/fenics $HOME/fenics

To help you get started this image contains a number of demo programs.
Explore the demos by entering the 'demo' directory, for example:
  cd ~/fenics/demo/python/documented/poisson
  python3 demo_poisson.py

You can use FEniCS with Jupyter Lab interface or via python command line.

To start Jupyter Lab, issue:

  jupyter lab --port $Jport

To start python, issue:

  python3

To reprint this introduction, issue:
  fenics-help

For any issues, please email mustafa.arif@qatar.tamu.edu
"
