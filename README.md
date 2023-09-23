## Singularity containers definition files for High Performance Computing


## Usage

### Install Singularity
[Install Singularity or Apptainer](https://docs.sylabs.io/guides/latest/user-guide/quick_start.html)

### Clone the repo
```bash
git clone https://github.com/mustafaarif/singularity4hpc
```

### Build required container
```bash
cd dir
singularity build container.sif container.def
```

### Run your application
```bash
singularity exec myap.sif mybinary
```
