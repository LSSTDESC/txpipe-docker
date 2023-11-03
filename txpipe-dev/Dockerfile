FROM condaforge/mambaforge:23.3.1-1
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
RUN mamba install -c conda-forge -y scipy=1.8.0 \
                     matplotlib=3.5.1 \
                     psutil \
                     "numpy=1.23.*" \
                     "pandas=1.4.1" \
                     "dask=2023.5.0" \
                     scikit-learn \
                     'mpich=4.0.*=external_*' \
                     'h5py=*=mpi_mpich_*'\
                     mpi4py \
                     "camb=1.5.*" \
                     "healpy=1.16.*" \
                     "fitsio=1.1.*" \
                     "astropy=5.2.*" \
                     "pyccl=2.6.*" \
                     namaster \
                     healsparse \
                     qp \
                     "firecrown=1.4.*" \
                     pygraphviz \
                     compilers \
                     guppy3 \
                     "jax=0.4.14" \
                     "jaxlib=0.4.14=*cpu*" \
                     "dm-tree=0.1.7" \
                     "cosmosis=3.4" \
                     threadpoolctl \
                     "sacc>=0.8.1" \
                     cython \
                     healpix \
                     jupyter \
                     nbconvert \
                     ipykernel \
                     "dask-mpi=2022.4.0" \
                     lsstdesc-gcr-catalogs \
                     "treecorr>=4.3.3" \
                     parallel_statistics \
                     mockmpi \
                     pzflow \
                     lsstdesc-dc2-dm-data \
                     psycopg2

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

# pip dependencies - fast-moving DESC packages that have not made conda yet
RUN pip install "ceci>=1.17" \
                "tjpcov==0.3.2" \
                "pz-rail[dev]==0.99.1" \
                "pz-rail-astro-tools==0.0.2" \
                "pz-rail-base==0.0.4" \
                "pz-rail-bpz==0.1.0" \
                "pz-rail-dsps==0.0.2" \
                "pz-rail-flexzboost==0.1.1" \
                "pz-rail-fsps==0.0.2" \
                "pz-rail-gpz-v1==0.1.2" \
                "pz-rail-pipelines==0.1.0" \
                "pz-rail-pzflow==0.0.1" \ 
                "pz-rail-sklearn==0.0.1" \
                "pz-rail-som==0.0.2"

# Force a version of qp that is on pypi but not yet conda
RUN mamba uninstall --force qp && pip install qp-prob==0.8.5

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
RUN pip install glass