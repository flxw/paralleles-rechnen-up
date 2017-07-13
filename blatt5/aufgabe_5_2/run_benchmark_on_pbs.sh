#!/bin/bash

# extra node hostnames from stupid PBS_NODEFILE
IFS=$'\r\n' GLOBIGNORE='*' command eval  'NODEARRAY=($(sort -u $PBS_NODEFILE))'
COMPUTENODE="${NODEARRAY[0]}"
echo "Running the whole thing on $COMPUTENODE"

# PBS script gets executed in node home directory, even on master node
# also the home directory is copied everywhere, so there is no need to copy binary files

# run script on node
ssh "$COMPUTENODE" 'bash -s' << 'ENDSSH'
cd ~/cluster-computing-up/blatt2/aufgabe_2_3
for EXE in "montecarlo_pi" "affine_montecarlo_pi"; do
	./benchmark.sh "./$EXE" 10000000 16 benchmark_results_$EXE.txt

	for SAMPLESIZE in 10000 100000 1000000 10000000; do
		./test_consistency.sh "./$EXE" "$SAMPLESIZE" 8 100 consistency_results_$EXE.txt
	done
done
ENDSSH
