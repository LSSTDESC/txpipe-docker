FROM condaforge/mambaforge:4.11.0-4
MAINTAINER joezuntz@googlemail.com

# Make, which we will need for everything
RUN apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y make  \
    && apt-get clean all

# We need a C compiler temporarily to install MPICH, which we want so that we use
# vendored MPI with conda. Not sure if we can get away with removing the gcc and g++
# compilers afterwards to save space but will try. We will use the conda gcc for everything
# else, though ideally everything would come through conda-forge.
# I have found that using the conda-forge supplied MPICH does not work
# with shifter on NERSC.
RUN apt-get update -y  \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y gcc gfortran \
    && mkdir /opt/mpich \
    && cd /opt/mpich \
    && wget http://www.mpich.org/static/downloads/4.0.2/mpich-4.0.2.tar.gz \
    && tar xvzf mpich-4.0.2.tar.gz \
    && cd mpich-4.0.2 \
    && ./configure --disable-wrapper-rpath  --disable-cxx --with-device=ch3 && make \
    && make install \
    && rm -rf /opt/mpich \
    && apt-get remove --purge -y gcc gfortran


# conda dependencies. As much as possible goes in here!
# should we be pinning versions?
RUN mamba install -y scipy=1.8.0 \
                     matplotlib=3.5.1 \
                     psutil \
                     numpy=1.22.2 \
                     pandas=1.4.1 \
                     dask \
                     scikit-learn \
                     'mpich=4.0.*=external_*' \
                     'h5py=*=mpi_mpich_*'\
                     mpi4py \
                     camb \
                     healpy \
                     fitsio \
                     astropy \
                     pyccl \
                     namaster \
                     healsparse \
                     qp \
                     cosmosis-standalone \
                     pygraphviz \
                     compilers

# pip dependencies
RUN pip install threadpoolctl \
                ceci>=1.8 \
                sacc>=0.4.9 \
                parallel_statistics \
                git+https://github.com/LSSTDESC/gcr-catalogs#egg=GCRCatalogs \
                git+https://github.com/LSSTDESC/desc_bpz \
                flexcode \
                xgboost==1.1.1 \
                git+https://github.com/dask/dask-mpi \
                git+https://github.com/LSSTDESC/firecrown@v0.4 \
                git+https://github.com/LSSTDESC/desc_bpz \
                git+https://github.com/LSSTDESC/desc-dc2-dm-data \
                mockmpi \
                git+https://github.com/rmjarvis/TreeCorr@fdb75d2f77e5b3a3fd095770fff86f472ffde8cb \
                pzflow \
                git+https://github.com/LSSTDESC/Delight \
                Cython


ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
CMD ["/bin/bash", "-l"]
ARG TX_DOCKER_VERSION
ENV TX_DOCKER_VERSION=$TX_DOCKER_VERSION
ARG TX_RELEASE_TAG
ENV TX_RELEASE_TAG=$TX_RELEASE_TAG
ENV PATH ${PATH}:/global/common/shared/das/container_proxy/
ENV LD_LIBRARY_PATH /usr/local/lib

# Make a link to something that will only appear later
RUN mkdir -p /global/common/shared/das/container_proxy/ \
    && touch /global/common/shared/das/container_proxy/client \
    && ln -s  /global/common/shared/das/container_proxy/client /usr/bin/srun \
    && rm -r /global

# avoid stuff in ~/.local getting mixed in on NERSC
ENV PYTHONNOUSERSITE=1

# might not work, let's find out
RUN python -c 'import astropy.config; astropy.config.create_config_file("astropy")'
WORKDIR /opt/TXPipe
