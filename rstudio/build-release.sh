#!/bin/bash
# Build RStudio 
# Usage: ./build-release.sh 4.3.1 4

R_VERSION=$1
R_MAJOR=$2
RSTUDIO_VERSION=2024.04.0-735-amd64

cp ./template/rstudio-build.def ./buildfiles/rstudio-build-$R_VERSION.def

sed -i "s/R_VERSION=.*/R_VERSION=$R_VERSION/" ./buildfiles/rstudio-build-$R_VERSION.def
sed -i "s/R_MAJOR=.*/R_MAJOR=$R_MAJOR/" ./buildfiles/rstudio-build-$R_VERSION.def
sed -i "s/RSTUDIO_VERSION=.*/RSTUDIO_VERSION=$R_MAJOR/" ./buildfiles/rstudio-build-$R_VERSION.def

singularity build ./output/rstudio-$R_VERSION.sif ./buildfiles/rstudio-build-$R_VERSION.def | tee ./logs/rstudio-$R_VERSION-$(date +"%d-%m-%Y")-build.log
