#!/bin/sh

# Script to compile and execute a pep8 subission.
# Communication is done with the file system:
#
# INPUT
#
# * source.nit : the submission source code
# * test*/input.txt : the input for each test
#
# OUTPUT
#
# * cmperr.txt : compilation error messages
# * test*/output.txt : the produced output for each test
# * test*/execerr.txt : execution error messages, if any (should not occur)
# * test*/timescore.txt : the time execution according to `time`
#
# To avoid the submission to look at the expected results or to temper them, the script just compile and run.
# The evaluation of the results has to be done by the caller.

# Try to compile
compile() {
	# Try to compile
	nitc source.nit 2> cmperr.txt
}

# Run a test of subdirectory
runtest() {
	t=$1

	# Try to execute the program on the test input
	time -o $t/timescore.txt ./source < $t/input.txt > $t/output.txt 2> $t/execerr.txt 
}

# Main
compile || exit 1
for t in test*; do runtest "$t"; done
