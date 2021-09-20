FROM condaforge/miniforge3:4.10.3-5
MAINTAINER joezuntz@googlemail.com

# Make, which we will need for everything
RUN apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make  \
    && apt-get clean all

# We need a C compiler to install MPICH, which we want so that we use
# vendored MPI with conda. Not sure if we can get away with removing the gcc and g++
# compilers afterwards to save space but will try. We will use the conda gcc for everything
# else if needed, though ideally everything would come through conda-forge for now.
# I have checked and using the conda-forge supplied MPICH does not seem to work.
# Do we even need to install this? Let's try without later.
RUN apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc \
    mkdir /opt/mpich && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz \
    && tar xvzf mpich-3.3.1.tar.gz &&  cd mpich-3.3.1 && ./configure --disable-wrapper-rpath && make \
    && make install && rm -rf /opt/mpich \
    && apt-get remove --purge -y gcc

RUN conda install -y 'mpich=3.4.*=external_*' mpi4py

# RUN conda install -y scipy matplotlib camb healpy psutil numpy scikit-learn fitsio pandas astropy pyccl mpi4py treecorr namaster  dask 'mpich=3.4.*=external_*' 'h5py=*=mpi_mpich_*'

# pip installations
#RUN pip install threadpoolctl ceci sacc parallel_statistics git+git://github.com/LSSTDESC/gcr-catalogs#egg=GCRCatalogs  git+git://github.com/LSSTDESC/qp git+git://github.com/LSSTDESC/desc_bpz healsparse flexcode  xgboost==1.1.1  git+https://github.com/dask/dask-mpi cosmosis-standalone git+https://github.com/LSSTDESC/firecrown@v0.4 git+git://github.com/LSSTDESC/desc_bpz git+git://github.com/LSSTDESC/qp

#RUN /bin/bash -c "source activate mro_env"