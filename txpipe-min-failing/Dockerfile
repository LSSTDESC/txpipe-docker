FROM condaforge/mambaforge:24.3.0-0

# This is matching what the NERSC docs use
ENV MPI_VERSION=4.0.2

# Show some linux version info
RUN cat /etc/*-release

# Install make
RUN apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make  \
    && apt-get clean all

# We need a C compiler temporarily to install MPICH.
# Then we install following instructions at 
# https://docs.nersc.gov/development/containers/shifter/how-to-use/#using-mpi-in-shifter
# We remove the installation afterwards
RUN apt-get update -y  \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc gfortran \
    && mkdir /opt/mpich \
    && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/${MPI_VERSION}/mpich-${MPI_VERSION}.tar.gz \
    && tar xvzf mpich-${MPI_VERSION}.tar.gz \
    && cd mpich-${MPI_VERSION} \
    && ./configure --disable-cxx \
    && make \
    && make install \
    && rm -rf /opt/mpich
RUN /sbin/ldconfig

# check we are using the conda python
RUN which python3
RUN python3 --version
RUN python3 -m pip install mpi4py
