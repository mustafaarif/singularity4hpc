https://software.intel.com/content/www/us/en/develop/articles/quick-linking-intel-mkl-blas-lapack-to-r.html

https://software.intel.com/content/www/us/en/develop/articles/using-intel-mkl-with-r.html

Some information on MKL on Ubuntu system. http://dirk.eddelbuettel.com/blog/2018/04/15/#018_mkl_for_debian_ubuntu </br>
- For Intel MKL Builds, you should see below
```
R is now configured for x86_64-pc-linux-gnu
  Options enabled:             shared R library, shared BLAS, R profiling
```
To verify if your build is against Intel MKL, once container is generated, you can issue following and make sure you see Blas/lapack pointing to intel library path;</br>
```
singularity shell R-container.sif
R
sessionInfo()
```
