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
                     pyccl>=2.5.0 \
                     namaster \
                     healsparse \
                     qp \
                     "firecrown>=1.4.0" \
                     pygraphviz \
                     compilers \
                     guppy3 \
                     jax \
                     dm-tree \
                     cosmosis

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

# pip dependencies
RUN pip install threadpoolctl \
                git+https://github.com/LSSTDESC/ceci@1cefb57770296f5a325eae9cf5512aefedb24c84 \
                sacc>=0.7 \
                parallel_statistics \
                git+https://github.com/LSSTDESC/gcr-catalogs#egg=GCRCatalogs \
                git+https://github.com/dask/dask-mpi \
                git+https://github.com/LSSTDESC/desc-dc2-dm-data \
                mockmpi \
                git+https://github.com/rmjarvis/TreeCorr@fdb75d2f77e5b3a3fd095770fff86f472ffde8cb \
                Cython \
                pz-rail-hub==0.0.4 \
                pzflow \
                jupyter \
                nbconvert \
                ipykernel \
                healpix

RUN pip install git+https://github.com/LSSTDESC/RAIL
RUN pip install git+https://github.com/LSSTDESC/rail_bpz@main
RUN pip install git+https://github.com/LSSTDESC/CLMM.git@1e3130188e4d0a4edc1cc8bd4d2cc11130a516ec

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
CMD ["/bin/bash", "-l"]
ARG TX_DOCKER_VERSION
ENV TX_DOCKER_VERSION=$TX_DOCKER_VERSION
ARG TX_RELEASE_TAG
ENV TX_RELEASE_TAG=$TX_RELEASE_TAG
ARG TX_RELEASE_DATE
ENV TX_RELEASE_DATE=$TX_RELEASE_DATE
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
