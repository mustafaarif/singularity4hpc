https://software.intel.com/content/www/us/en/develop/articles/using-intel-mkl-with-r.html

Some information on MKL on Ubuntu system. http://dirk.eddelbuettel.com/blog/2018/04/15/#018_mkl_for_debian_ubuntu </br>
```
Singularity> ./configure --with-blas="$MKL" --with-lapack --enable-R-shlib --with-x=no
R is now configured for x86_64-pc-linux-gnu

  Source directory:            .
  Installation directory:      /usr/local

  C compiler:                  gcc  -g -O2
  Fortran fixed-form compiler: gfortran -fno-optimize-sibling-calls -g -O2

  Default C++ compiler:        g++ -std=gnu++11  -g -O2
  C++98 compiler:              g++ -std=gnu++98  -g -O2
  C++11 compiler:              g++ -std=gnu++11  -g -O2
  C++14 compiler:              g++ -std=gnu++14  -g -O2
  C++17 compiler:              g++ -std=gnu++17  -g -O2
  Fortran free-form compiler:  gfortran -fno-optimize-sibling-calls -g -O2
  Obj-C compiler:

  Interfaces supported:
  External libraries:          readline, curl
  Additional capabilities:     NLS
  Options enabled:             shared R library, shared BLAS, R profiling

  Capabilities skipped:        PNG, JPEG, TIFF, cairo, ICU
  Options not enabled:         memory profiling

  Recommended packages:        yes
```

To verify if your build is against Intel MKL, once container is generated, you can do following;</br>
```
singularity shell R-container.sif
R
sessionInfo()
```
