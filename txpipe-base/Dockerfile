FROM condaforge/mambaforge:23.3.1-1
LABEL maintainer=joezuntz@googlemail.com

ENV TX_MPI_VERSION=4.2.1


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
    && wget http://www.mpich.org/static/downloads/${TX_MPI_VERSION}/mpich-${TX_MPI_VERSION}.tar.gz \
    && tar xvzf mpich-${TX_MPI_VERSION}.tar.gz \
    && cd mpich-${TX_MPI_VERSION} \
    && ./configure --disable-wrapper-rpath  --disable-cxx --with-device=ch3 && make \
    && make install \
    && rm -rf /opt/mpich \
    && apt-get remove --purge -y gcc gfortran

