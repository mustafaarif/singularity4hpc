https://software.intel.com/content/www/us/en/develop/articles/quick-linking-intel-mkl-blas-lapack-to-r.html

https://software.intel.com/content/www/us/en/develop/articles/using-intel-mkl-with-r.html
- Build sandbox container ``` singularity build -s r-intel-build ./r-intel-threaded.def ```
- Export sif file ```singularity build r-intel-threaded.sif r-intel-threaded```
- For Intel MKL Builds, you should see ```  Options enabled: shared R library, shared BLAS, R profiling```
- To verify if your build is against Intel MKL, once container is generated, you can issue following and make sure you see Blas/lapack pointing to intel library path;</br>
```
singularity shell R-container.sif
R
sessionInfo()
```
