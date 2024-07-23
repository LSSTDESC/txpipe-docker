FROM ghcr.io/lsstdesc/txpipe-base
LABEL maintainer=joezuntz@googlemail.com

# This is here so I can force a rebuild when changing
# stuff in the TXPipe repo.
RUN echo Build version 3

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


# This line makes sure that if the TXPipe version we are using is updated
# then the cache is invalidated and the new version is used.
# It doesn't seem to work though.
ADD https://api.github.com/repos/LSSTDESC/TXPipe/git/refs/heads/${TX_TAG_FOR_DEPENDENCIES} txpipe-version.json


# Install the TXPipe environment, but we need to modify the environment file
# because we want to use the MPICH package that we installed above.
# The "external" version in conda-forge is a meta-package that does not
# include the actual libraries, so the pre-installed ones are used instead.
# We install three sets of conda packages here, TXPipe core, TXPipe NERSC-specific, and RAIL.
# RAIL tries to demand OpenMPI instead of MPICH, so we can't just directly
# follow the RAIL instructions. Instead we put the RAIL deps into the conda-extras.yml
RUN git clone --branch ${TX_TAG_FOR_DEPENDENCIES}  https://github.com/LSSTDESC/TXPipe \
    && cd TXPipe \
    && sed 's/mpich=.*/mpich='${TX_MPI_VERSION}'=external_*/' environment-nopip.yml > environment-nopip2.yml \
    && echo cat environment-nopip2.yml \
    && cat environment-nopip2.yml \
    && echo cat ../conda-extras.yml \
    && cat ../conda-extras.yml \
    && echo cat environment-piponly.yml \
    && cat environment-piponly.yml \
    && mamba env update --name base --file  environment-nopip2.yml \
    && mamba env update --name base --file ../conda-extras.yml \
    && mamba env update --name base --file environment-piponly.yml \
    && cd .. \
    && rm -rf TXPipe \
    && pip uninstall -y jaxlib \ 
    && mamba install -y --force-reinstall -c conda-forge jaxlib=0.4.23 \
    && conda remove --force mpi4py \
    && pip install mpi4py

# ^^ conda insists on uninstalling and reinstalling an incorrect jaxlib version

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