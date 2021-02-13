#!/bin/bash
# if you want to bind some host directories...
# export SINGULARTY_BINDPATH=/some,/dirs,/to,/bind
dir=$(dirname  "$0")
cmd=$(basename "$0")
arg="$@"
singularity exec $dir/gromacs2020.sif $cmd $arg
