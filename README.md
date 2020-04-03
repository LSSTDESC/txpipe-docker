Purpose
-------

This repo contains the Docker files used to compile containers
for running TXPipe, TXPipe+CosmoSIS, and TXPipe+FireCrown, both
at NERSC and elsewhere.

You don't need to run anything from this repo yourself - Joe does
that for you and pushes things to NERSC.

Installing
----------

On NERSC, it's faster to do all this in $SCRATCH.  On other machines,
anywhere is fine:
```

cd $SCRATCH

```


Clone the repositories.  Only the dependencies are installed because
these are still under active development.  The CosmoSIS develop branch
is the most up-to-date, for both repos (one will be cloned inside the other):

```
git clone https://github.com/LSSTDESC/TXPipe
git clone https://github.com/LSSTDESC/FireCrown
git clone -b develop https://bitbucket.org/joezuntz/cosmosis
git clone -b develop https://bitbucket.org/joezuntz/cosmosis-standard-library cosmosis/cosmosis-standard-library
```

Running TXPipe+CosmoSIS at NERSC
--------------------------------

Launch the container using shifter.
We use -V to map container cosmosis paths to SCRATCH paths.

```
shifter --image=joezuntz/txpipe-cosmosis -V $PWD/cosmosis:/opt/cosmosis -V $PWD/TXPipe:/opt/txpipe bash
```

Compile CosmoSIS:
```
cd /opt/cosmosis
make
```

Run CosmoSIS:
```
cosmosis demos/demo5.ini
```

Or when running jobs with SLURM:
```
srun -n 8 --env OMP_NUM_THREADS=4 shifter --image joezuntz/txpipe-cosmosis cosmosis --mpi demos/demo9.ini
```

Running TXPipe+CosmoSIS elsewhere
---------------------------------

Launch the container.
We use -V to map container cosmosis paths to SCRATCH paths.

```
docker run -v $PWD/cosmosis:/opt/cosmosis -v $PWD/TXPipe:/opt/txpipe --rm -it joezuntz/txpipe-cosmosis bash
```

Compile CosmoSIS:
```
cd /opt/cosmosis
make
```

Run CosmoSIS:
```
cosmosis demos/demo5.ini
```

Or under MPI:
```
mpirun -n 4 cosmosis --mpi demos/demo9.ini
```

Running TXPipe+FireCrown at NERSC
---------------------------------

Launch the alternative container:

```
shifter --image=joezuntz/txpipe-firecrown -V $PWD/firecrown:/opt/firecrown -V $PWD/TXPipe:/opt/txpipe bash
```

And run commands using:

```
cd /opt/firecrown/examples/des_y1_3x2pt
firecrown run-cosmosis  des_y1_3x2pt.yaml
```


Running TXPipe+FireCrown elsewhere
---------------------------------

Launch the alternative container:

```
docker run --rm -it -v $PWD/firecrown:/opt/firecrown -v $PWD/TXPipe:/opt/txpipe joezuntz/txpipe-firecrown bash
```

And run commands using:

```
cd /opt/firecrown/examples/des_y1_3x2pt
firecrown run-cosmosis  des_y1_3x2pt.yaml
```
