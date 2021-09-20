FROM condaforge/miniforge3:4.10.3-5
MAINTAINER joezuntz@googlemail.com

# Make, which we will need for everything
RUN apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make  \
    && apt-get clean all

# We need a C compiler temporarily to install MPICH, which we want so that we use
# vendored MPI with conda. Not sure if we can get away with removing the gcc and g++
# compilers afterwards to save space but will try. We will use the conda gcc for everything
# else if needed, though ideally everything would come through conda-forge for now.
# I have checked and using the conda-forge supplied MPICH does not seem to work.
# TODO disable gfortran - unlikely to be ABI compatible with the conda version we use for everything else
RUN apt-get update -y  \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc g++ gfortran \
    && mkdir /opt/mpich \
    && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/3.4.2/mpich-3.4.2.tar.gz \
    && tar xvzf mpich-3.4.2.tar.gz \
    && cd mpich-3.4.2 \
    && ./configure --disable-wrapper-rpath && make \
    && make -j 2 install \
    && rm -rf /opt/mpich \
    && apt-get remove --purge -y gcc g++ gfortran

# conda dependencies. As much as possible goes in here!
RUN conda install -y scipy \
                     matplotlib \
                     psutil \
                     numpy \
                     pandas \
                     dask \
                     scikit-learn \
                     'mpich=3.4.*=external_*' \
                     'h5py=*=mpi_mpich_*'\
                     mpi4py \
                     camb \
                     healpy \
                     fitsio \
                     astropy \
                     pyccl \
                     treecorr \
                     namaster \
                     healsparse \
                     qp \
                     cosmosis-standalone \
                     compilers

# pip dependencies
RUN pip install threadpoolctl \
                ceci \
                sacc \
                parallel_statistics \
                git+git://github.com/LSSTDESC/gcr-catalogs#egg=GCRCatalogs \
                git+git://github.com/LSSTDESC/desc_bpz \
                flexcode \
                xgboost==1.1.1 \
                git+https://github.com/dask/dask-mpi \
                git+https://github.com/LSSTDESC/firecrown@v0.4 \
                git+git://github.com/LSSTDESC/desc_bpz
