FROM joezuntz/txpipe-base

ENV PATH ${PATH}:/opt/firecrown/bin
ENV PYTHONPATH ${PYTHONPATH}:/opt/firecrown


RUN apt-get update -y \
    && apt-get install -y cmake \
    && apt-get clean all


RUN pip install --no-cache-dir cosmosis-standalone
RUN pip install --no-cache-dir git+https://github.com/LSSTDESC/firecrown@v0.4
