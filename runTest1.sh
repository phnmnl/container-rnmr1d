#!/bin/bash

# Create required directories
mkdir -p /data/input
mkdir -p /data/expected
mkdir -p /data/output

# Fetch MTBLS1 study
wget -O /data/input/MTBLS1.zip 'https://www.ebi.ac.uk/metabolights/MTBLS1/files/MTBLS1'
#wget -O /data/input/MTBLS1.zip 'https://bitbucket.org/nmrprocflow/rnmr1d/raw/8ec5631f3ef15cd61a4906067a4de72e658787e6/examples/input/MTBLS1/ADG1.zip'

# Fetch parameter files
wget -O /data/input/NP_macro_cmd_MTBLS1.txt 'https://bitbucket.org/nmrprocflow/rnmr1d/raw/8ec5631f3ef15cd61a4906067a4de72e658787e6/examples/input/MTBLS1/NP_macro_cmd_MTBLS1.txt'

# Fetch test data
wget -O /data/expected/MTBLS1_nmrML.zip 'https://bitbucket.org/nmrprocflow/rnmr1d/raw/8ec5631f3ef15cd61a4906067a4de72e658787e6/examples/input/MTBLS1/ADG19007_nmrML.zip'

# Run test
/opt/rnmr1d/exec/Rnmr1D --zip /data/input/MTBLS1.zip \
   --proccmd /data/input/NP_macro_cmd_MTBLS1.txt \
   --outnorn PQN \
   --cpu 4 \
   --outdir /data/output | tee ./examples/output/stdout.log

# Compare results
#if [[ "$(cat data_spectra.csv | head -n 1)" != "$(zcat test_data_spectra.csv.gz | head -n 1)" ]]; then
#	echo "Test failed! Results do not match test data."
#	exit 1
#else
#	echo "Test succeeded successfully."
#fi

#if [[ "$(cat data_fid.csv | head -n 1)" != "$(zcat test_data_fid.csv.gz | head -n 1)" ]]; then
#	echo "Test failed! Results do not match test data."
#	exit 1
#else
#	echo "Test succeeded successfully."
#fi

