#!/bin/bash
# Build RStudio 
# Usage: ./build-release.sh 4.3.1 4

R_VERSION=$1
R_MAJOR=$2
#RSTUDIO_VERSION=2024.04.0-735-amd64
RSTUDIO_VERSION=2023.12.1-402-amd64

mkdir -p logs buildfiles output

cp ./template/rstudio-build.def ./buildfiles/rstudio-build-$R_VERSION.def

sed -i "s/R_VERSION=.*/R_VERSION=$R_VERSION/" ./buildfiles/rstudio-build-$R_VERSION.def
sed -i "s/R_MAJOR=.*/R_MAJOR=$R_MAJOR/" ./buildfiles/rstudio-build-$R_VERSION.def
sed -i "s/RSTUDIO_VERSION=.*/RSTUDIO_VERSION=$RSTUDIO_VERSION/" ./buildfiles/rstudio-build-$R_VERSION.def

singularity build ./output/rstudio_${R_VERSION}_${RSTUDIO_VERSION}.sif ./buildfiles/rstudio-build-$R_VERSION.def | tee ./logs/rstudio-$R_VERSION-$(date +"%d-%m-%Y")-build.log
