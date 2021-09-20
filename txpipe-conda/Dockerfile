FROM condaforge/miniforge3:4.10.3-5
MAINTAINER joezuntz@googlemail.com

# # Make, which we will need for everything
# RUN apt-get update -y \
#     && DEBIAN_FRONTEND="noninteractive" apt-get install -y make  \
#     && apt-get clean all

# # We need a C compiler to install MPICH, which we want so that
# RUN apt-get update -y && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc g++ \
#     mkdir /opt/mpich && cd /opt/mpich \
#     && wget http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz \
#     && tar xvzf mpich-3.3.1.tar.gz &&  cd mpich-3.3.1 && ./configure --disable-wrapper-rpath && make -j4 \
#     && make install && rm -rf /opt/mpich \
#     && apt-get remove --purge -y gcc g++

RUN conda install -y mpich mpi4py

# RUN conda install -y scipy matplotlib camb healpy psutil numpy scikit-learn fitsio pandas astropy pyccl mpi4py treecorr namaster  dask 'mpich=3.4.*=external_*' 'h5py=*=mpi_mpich_*'

# pip installations
#RUN pip install threadpoolctl ceci sacc parallel_statistics git+git://github.com/LSSTDESC/gcr-catalogs#egg=GCRCatalogs  git+git://github.com/LSSTDESC/qp git+git://github.com/LSSTDESC/desc_bpz healsparse flexcode  xgboost==1.1.1  git+https://github.com/dask/dask-mpi cosmosis-standalone git+https://github.com/LSSTDESC/firecrown@v0.4 git+git://github.com/LSSTDESC/desc_bpz git+git://github.com/LSSTDESC/qp

#RUN /bin/bash -c "source activate mro_env"