FROM ubuntu:20.04
MAINTAINER joezuntz@googlemail.com
#Joe's note to himself.  Compile this with: docker build -t joezuntz/cosmosis-base .
#then docker push joezuntz/cosmosis-base

# Basic compilers and tools dependencies
RUN apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc g++ gfortran \
    cmake swig wget make libopenblas-dev libchealpix-dev \
    pkg-config curl python3 python3-distutils python3-dev python3-pip \
    libcfitsio-dev  libfftw3-dev   git  libgsl-dev autoconf \
    && apt-get clean all

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10

# Manual installation of mpich seems to be required to work on NERSC
RUN mkdir /opt/mpich && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz \
    && tar xvzf mpich-3.3.1.tar.gz &&  cd mpich-3.3.1 && ./configure --disable-wrapper-rpath && make -j4 \
    && make install && rm -rf /opt/mpich



# Also need a manual install of mpi4py so that it uses the right libraries - pip seems not to work
RUN pip install -vv --no-binary=mpi4py mpi4py

# Need to install manually because we want MPI-enabled version
RUN mkdir /opt/hdf && cd /opt/hdf \
    && wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz \
    && tar xvf hdf5-1.12.0.tar.gz \
    && cd hdf5-1.12.0 \
    && ./configure --enable-parallel --prefix=/usr/local CC=mpicc \
    && make \
    && make install \
    && rm -rf /opt/hdf



# Some env vars
ENV HDF5_MPI ON
ENV HDF5_USE_FILE_LOCKING FALSE
ENV LD_LIBRARY_PATH /usr/local/lib
ENV C_INCLUDE_PATH /usr/local/include

# Ceci

RUN pip install --no-cache-dir --upgrade pip

# fitsio needs this to be installed first

RUN pip install --no-cache-dir numpy>=1.17

RUN pip install --no-cache-dir cffi

RUN apt-get install -y libbz2-dev && apt-get clean all

# Basic python requirements
RUN pip install --no-cache-dir \
                Cython==0.29.13 \
                nose==1.3.7 \
                pyparsing==2.2.0 \
                pyyaml==5.1.2 \
                scikit-learn==0.24.2 \
                setuptools==57.4.0 \
                astropy==4.1 \
                scipy>=1.4 \
                fitsio==1.1.4 \
                healpy==1.15.0 \
                descformats \
                mlz_desc \
                six

RUN pip install --no-cache-dir  pandas
RUN pip install --no-cache-dir  psutil


# Install h5py, recompiling so that we use HDF5 with MPI
RUN pip install --no-cache-dir --no-binary=h5py h5py==3.1.0

RUN pip install --no-cache-dir  treecorr==4.2.3

# Manual namaster install
# RUN mkdir -p /opt/namaster && cd /opt/namaster \
#     && git clone https://github.com/Libsharp/libsharp \
#     && cd libsharp \
#     && autoconf \
#     && ./configure --enable-pic  --enable-openmp \
#     && make \
#     && cp -v auto/lib/* /usr/local/lib/ \
#     && cp -v auto/include/* /usr/local/include/ \
#     && rm -rf /opt/namaster

RUN pip install --no-cache-dir  xgboost==1.1.0
RUN pip install --no-cache-dir  healsparse
RUN pip install --no-cache-dir  numba
# fixes a tab completion bug in ipython
# https://github.com/ipython/ipython/issues/12748
RUN pip install --no-cache-dir  jedi==0.17.2

RUN apt-get update -y \
    && apt-get install -y cmake \
    && apt-get clean all

RUN apt-get update -y && apt-get install -y graphviz libgraphviz-dev pkg-config && apt-get clean all


RUN pip install --no-cache-dir cosmosis-standalone

# Manual namaster install
RUN pip install pymaster

RUN pip install --no-cache-dir  flexcode



RUN pip install --no-cache-dir  \
                emcee \
                camb \
                pyarrow \
                ipython

RUN pip install git+https://github.com/LSSTDESC/CCL@v2.2.0

RUN pip install --no-cache-dir  ceci[parsl,cwl,test]==v1.4.1
RUN pip install --no-cache-dir  git+https://github.com/LSSTDESC/gcr-catalogs@v1.3.4
RUN pip install --no-cache-dir  git+https://github.com/LSSTDESC/desc-dc2-dm-data

RUN pip install --no-cache-dir  tjpcov threadpoolctl
RUN pip install --no-cache-dir  parallel_statistics
RUN pip install --no-cache-dir  sacc



ENV PYTHONPATH ${PYTHONPATH}:/opt/txpipe
# These prevent errors all over the place on NERSC
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
CMD ["/bin/bash", "-l"]

WORKDIR /opt/txpipe




RUN pip install --no-cache-dir git+https://github.com/LSSTDESC/firecrown@v0.4
RUN pip install --no-cache-dir pygraphviz


# I had to split these up - they are all just installing cuda stuff,
# but on my laptop I kept getting "Bad request error 400" when installing
# lots of stuff at once
RUN apt-get update -y \
    && apt-get install -y libpulse-mainloop-glib0 \
    && apt-get clean all

RUN apt-get update -y \
    && apt-get install -y nvidia-cuda-dev \
    && apt-get clean all

RUN apt-get update -y \
    && apt-get install -y nvidia-cuda-toolkit \
    && apt-get clean all

RUN pip install --no-cache-dir cupy-cuda101

RUN pip install --no-cache-dir git+https://github.com/joezuntz/xpysom@torus
