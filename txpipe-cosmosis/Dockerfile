FROM joezuntz/txpipe-base

# The environment variables needed by the CosmoSIS build and runtime.
ENV COSMOSIS_SRC_DIR /opt/cosmosis
ENV GSL_INC /usr/include
ENV GSL_LIB /usr/lib/x86_64-linux-gnu
ENV CFITSIO_INC /usr/include
ENV CFITSIO_LIB /usr/lib/x86_64-linux-gnu
ENV FFTW_LIBRARY /usr/lib/x86_64-linux-gnu
ENV FFTW_INC_DIR /usr/include
ENV LAPACK_LINK -L/usr/local/lib -lopenblas
ENV LD_LIBRARY_PATH ${COSMOSIS_SRC_DIR}/cosmosis/datablock:${COSMOSIS_SRC_DIR}/cosmosis-standard-library/likelihood/planck2015/plc-2.0/lib/:/usr/lib/x86_64-linux-gnu:/usr/local/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH ${COSMOSIS_SRC_DIR}:${PYTHONPATH}
ENV PATH ${COSMOSIS_SRC_DIR}/bin:${PATH}
ENV OMP_NUM_THREADS=1

RUN pip install --no-cache-dir \
                asn1crypto==0.24.0 \
                attrs==17.4.0 \
                backports.functools-lru-cache==1.5 \
                funcsigs==1.0.2 \
                pluggy==0.6.0 \
                py==1.5.2 \
                pytz==2018.3 \
                kiwisolver==1.0.1 \
                llvmlite==0.22.0 \
                python-dateutil==2.6.1 \
                sklearn==0.0 \
                cosmolopy==0.1.104 \
                matplotlib==2.2.0 \
                numba==0.37.0 \
                future \
                configparser

RUN pip install --no-cache-dir git+https://github.com/CobayaSampler/cobaya

