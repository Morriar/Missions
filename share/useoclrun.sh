#!/bin/sh

# Script to execute a USE-OCL subission.
# Communication is done with the file system:
#
# INPUT
#
# * source.use : the submission source code
# * test*/input.txt : the input for each test
#
# OUTPUT
#
# * test*/output.txt : the produced output for each test
# * test*/execerr.txt : execution error messages, if any
#
# To avoid the submission to look at the expected results or to temper them, the script just compile and run.
# The evaluation of the results has to be done by the caller.

# Transform a bash return value caused by ulimit into a message for a human.
# Not really portable :(
ulimitmsg() {
	code=$1
	file=$2
	# 128+n = signal n
	case "$code" in
		137)
			# 128+9 = KILL = time out
			echo "CPU time limit exceeded" > "$file"
			return 1;;
		153)
			# 128+25 = XFSZ = file limit
			echo "File size limit exceeded" > "$file"
			return 1;;
		*)
			# USE OCL returned 1 (a constraint failed)
			return 0
	esac
}

# Try to compile
compile() {
	# Try to compile
	(
		ulimit -t 5 # 5s CPU time
		ulimit -f 128 # 1kB written files
		use -nogui -nr -c source.use 2> cmperr.txt
	) || {
		ulimitmsg "$?" cmperr.txt
		return 1
	}

	return 0
}

# Run a test of subdirectory
runtest() {
	t=$1

	# Try to execute the program on the test input
	(
		ulimit -t 5 # 5s CPU time
		ulimit -f 128 # 1kB written files
		use -nogui -nr -t -qv source.use $t/input.txt > $t/output.txt 2>&1
		# $t/execerr.txt
		# cat $t/output.txt
		# cat $t/execerr.txt
	) || {
		return ulimitmsg "$?" $t/execerr.txt
	}
	return 0
}

# Main
compile || exit 1
for t in test*; do runtest "$t"; done
exit 0
