FROM ghcr.io/lsstdesc/txpipe-base
LABEL maintainer=joezuntz@googlemail.com

# I thought this would carry over from the previous build
# but apparently not. Might be a github actions thing.
# or maybe I just didn't wait long enough for the parent
# build to propagate.
ENV TX_MPI_VERSION=4.2.1

ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

# These should go here so that if we change them
# it does not invalidate everything above from the cache
COPY conda-extras.yml conda-extras.yml
ENV TX_TAG_FOR_DEPENDENCIES=library-versions-update
ENV RAIL_TAG_FOR_DEPENDENCIES=v1.0.0



# Install the TXPipe environment, but we need to modify the environment file
# because we want to use the MPICH package that we installed above.
# The "external" version in conda-forge is a meta-package that does not
# include the actual libraries, so the pre-installed ones are used instead.
# We install three sets of conda packages here, TXPipe core, TXPipe NERSC-specific, and RAIL.
# We also install the RAIL package in full here.
# RAIL tries to demand OpenMPI instead of MPICH, so we can't just directly
# follow the RAIL instructions. Instead we put the RAIL deps into the conda-extras.yml
RUN git clone --branch ${TX_TAG_FOR_DEPENDENCIES}  https://github.com/LSSTDESC/TXPipe \
    && cd TXPipe \
    && sed 's/mpich=.*/mpich=${TX_MPI_VERSION}=external_*/' environment-nopip.yml > environment-nopip2.yml \
    && echo "INSTALLING NO-PIP" \
    && echo "FILE 1" \
    && cat environment-nopip2.yml \
    && echo "FILE 2" \
    && cat ../conda-extras.yml \
    && mamba env create --name tx --file  environment-nopip2.yml \
    && source activate tx \
    && mamba env update --name tx --file ../conda-extras.yml \
    && mamba list

RUN cd TXPipe \
    && source activate tx \
    && echo "INSTALLING PIP" \
    && echo "FILE 3" \
    && cat environment-piponly.yml \
    && mamba env update --name tx --file environment-piponly.yml
    # && cd .. \
    # && rm -rf TXPipe


RUN git clone --branch ${RAIL_TAG_FOR_DEPENDENCIES} https://github.com/LSSTDESC/rail \
    && cd rail \
    && source activate tx \
    && echo "PIP = " \
    %% which pip \
    && python -m pip install ".[algos]"


RUN mamba activate tx \
    && pip install git+https://github.com/LSSTDESC/CLMM.git@1e3130188e4d0a4edc1cc8bd4d2cc11130a516ec \
    && pip install git+https://github.com/beckermr/hybrideb

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
CMD ["/bin/bash", "-l"]

ARG TX_DOCKER_VERSION
ENV TX_DOCKER_VERSION=$TX_DOCKER_VERSION

ARG TX_RELEASE_TAG
ENV TX_RELEASE_TAG=$TX_RELEASE_TAG

ARG TX_RELEASE_DATE
ENV TX_RELEASE_DATE=$TX_RELEASE_DATE
ENV LD_LIBRARY_PATH /usr/local/lib

# Make a link to something that will only appear later
# This lets us launch jobs on NERSC SLURM from within the container
RUN mkdir -p /global/common/shared/das/container_proxy/ \
    && touch /global/common/shared/das/container_proxy/client \
    && ln -s  /global/common/shared/das/container_proxy/client /usr/bin/srun \
    && rm -r /global
ENV PATH ${PATH}:/global/common/shared/das/container_proxy/

# avoid stuff in ~/.local getting mixed in on NERSC
ENV PYTHONNOUSERSITE=1

# If we don't do this here then astropy tries to do it per-user the first
# time it is run, even if that is massively parallel
RUN python -c 'import astropy.config; astropy.config.create_config_file("astropy")'
WORKDIR /opt/TXPipe