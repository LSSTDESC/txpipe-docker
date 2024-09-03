FROM condaforge/mambaforge:24.3.0-0

# This is matching what the NERSC docs use
ENV MPI_VERSION=4.0.2

# Show some linux version info
RUN cat /etc/*-release

RUN mamba install compilers=1.7.0 make

# Following:
# https://docs.nersc.gov/development/containers/shifter/how-to-use/#using-mpi-in-shifter
RUN apt-get update -y  \
    && mkdir /opt/mpich \
    && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/${MPI_VERSION}/mpich-${MPI_VERSION}.tar.gz \
    && tar xvzf mpich-${MPI_VERSION}.tar.gz \
    && cd mpich-${MPI_VERSION} \
    && ./configure --disable-cxx --with-channel=ch3 \
    && make \
    && make install \
    && rm -rf /opt/mpich

RUN /sbin/ldconfig

# check we are using the conda python
RUN which python3
RUN python3 --version
RUN python3 -m pip install mpi4py
