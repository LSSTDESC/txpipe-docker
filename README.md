Purpose
-------

This repo contains the Docker files used to compile containers
for running TXPipe, both at NERSC and elsewhere.

You don't need to run anything from this repo yourself - Joe does
that for you and pushes things to docker hub NERSC.


Using this image
----------------

See the TXPipe documentation for usage info.

Versions
--------

Currently two versions are built.

- Production builds are triggered whenever a release is created. They build from the txpipe-conda directory.

- Development builds must be manually triggered using the "Run workflow" button under the Actions tab after selecting the job.

The production builds are designed to be more stable, and should be used for most purposes. The development builds are to test TXPipe branches that need new things installed.