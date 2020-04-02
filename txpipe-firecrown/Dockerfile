FROM joezuntz/txpipe-base

ENV PATH ${PATH}:/opt/firecrown/bin
ENV PYTHONPATH ${PYTHONPATH}:/opt/firecrown

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
RUN pip install --no-cache-dir \
                cosmosis-standalone \
                camb \
                tjpcov \
                threadpoolctl
