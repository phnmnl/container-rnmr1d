#!/bin/bash

# Create required directories
mkdir -p /data/input
mkdir -p /data/expected
mkdir -p /data/output

# Fetch MTBLS1 study
#wget -O /data/input/MTBLS1.zip 'https://www.ebi.ac.uk/metabolights/MTBLS1/files/MTBLS1'
wget -O /data/input/MTBLS1.zip 'https://bitbucket.org/nmrprocflow/rnmr1d/raw/8ec5631f3ef15cd61a4906067a4de72e658787e6/examples/input/MTBLS1/ADG1.zip'

# Fetch parameter files
wget -O /data/input/NP_macro_cmd_MTBLS1.txt 'https://bitbucket.org/nmrprocflow/rnmr1d/raw/8ec5631f3ef15cd61a4906067a4de72e658787e6/examples/input/MTBLS1/NP_macro_cmd_MTBLS1.txt'

# Fetch test files
wget -O /data/input/test_data_matrix.txt.gz 'https://github.com/phnmnl/container-rnmr1d/raw/develop/test_data_matrix.txt.gz'

# Run test
/opt/rnmr1d/exec/Rnmr1D --zip /data/input/MTBLS1.zip \
   --proccmd /data/input/NP_macro_cmd_MTBLS1.txt \
   --outnorm PQN \
   --cpu 8 \
   --outdir /data/output

# Compare results
if [[ "$(cat /data/output/data_matrix.txt)" != "$(zcat /data/input/test_data_matrix.txt.gz)" ]]; then
	echo "Test failed! Results do not match test data."
	exit 1
else
	echo "Test succeeded successfully."
fi

