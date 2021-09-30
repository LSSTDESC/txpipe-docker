FROM condaforge/miniforge3:4.10.3-5
MAINTAINER joezuntz@googlemail.com

# Make, which we will need for everything
RUN apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make  \
    && apt-get clean all

# We need a C compiler temporarily to install MPICH, which we want so that we use
# vendored MPI with conda. Not sure if we can get away with removing the gcc and g++
# compilers afterwards to save space but will try. We will use the conda gcc for everything
# else, though ideally everything would come through conda-forge.
# I have found that using the conda-forge supplied MPICH does not work.
RUN apt-get update -y  \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc \
    && mkdir /opt/mpich \
    && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/3.4.2/mpich-3.4.2.tar.gz \
    && tar xvzf mpich-3.4.2.tar.gz \
    && cd mpich-3.4.2 \
    && ./configure --disable-wrapper-rpath --disable-fortran --disable-cxx --with-device=ch3 && make \
    && make install \
    && rm -rf /opt/mpich \
    && apt-get remove --purge -y gcc

# conda dependencies. As much as possible goes in here!
# should we be pinning versions?
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
                     pygraphviz \
                     compilers
                     # cudatoolkit-dev \
                     # cupy

# pip dependencies
RUN pip install threadpoolctl \
                ceci>=1.6 \
                sacc \
                parallel_statistics \
                git+git://github.com/LSSTDESC/gcr-catalogs#egg=GCRCatalogs \
                git+git://github.com/LSSTDESC/desc_bpz \
                flexcode \
                xgboost==1.1.1 \
                git+https://github.com/dask/dask-mpi \
                git+https://github.com/LSSTDESC/firecrown@v0.4 \
                git+git://github.com/LSSTDESC/desc_bpz \
                git+https://github.com/LSSTDESC/desc-dc2-dm-data \
                mockmpi

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
CMD ["/bin/bash", "-l"]
ARG TX_DOCKER_VERSION
ENV TX_DOCKER_VERSION=$TX_DOCKER_VERSION
ENV PATH ${PATH}:/global/common/shared/das/container_proxy/

# Make a link to something that will only appear later
RUN mkdir -p /global/common/shared/das/container_proxy/ \
    && touch /global/common/shared/das/container_proxy/client \
    && ln -s  /global/common/shared/das/container_proxy/client /usr/bin/srun \
    && rm -r /global

# avoid stuff in ~/.local getting mixed in on NERSC
ENV PYTHONNOUSERSITE=1

# might not work, let's find out
RUN python -c 'import astropy.config; astropy.config.create_config_file("astropy")'
