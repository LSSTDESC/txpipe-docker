#!/usr/bin/env bash

# This is not a full-scale test since TXPipe is developing rapidly and we will often
# want this image to stay ahead of the repository. So right now we just test that
# things import okay. We could think more about this.
set -e
set -x

# Some miscellaneous dependency checks
python -c 'import tjpcov'
python -c 'import rail.stages'

# Pipeline dry run
git clone https://github.com/LSSTDESC/TXPipe
cd TXPipe
ceci --dry-run examples/metadetect/pipeline.yml

