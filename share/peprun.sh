#!/bin/sh

# Script to compile and execute a pep8 subission.
# Communication is done with the file system:
#
# INPUT
#
# * source.pep : the submission source code
# * test*/input.txt : the input for each test
#
# OUTPUT
#
# * cmperr.txt : compilation error messages
# * test*/output.txt : the produced output for each test
# * test*/execerr.txt : execution error messages, if any (should not occur)
# * test*/timescore.txt : the time execution according to pep8term
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
			;;
		153)
			# 128+25 = XFSZ = file limit
			echo "File size limit exceeded" > "$file"
			;;
		*)
			# Error but empty file. Just say something.
			test -s "$file" || echo "Command failed with error $code" > "$file"
	esac
	cat "$file"
}

# Try to compile
compile() {
	# Try to compile
	(
	ulimit -t 2 # 2s CPU time
	ulimit -f 128 # 1kB written files
	./asem8 source.pep 2> cmperr.txt
	) || {
		ulimitmsg "$?" cmperr.txt
		return 1
	}

	# Compilation failed. Exit
	test -f source.pepo || return 1

	return 0
}

# Run a test of subdirectory
runtest() {
	t=$1

	# Pep8 is interactive and need an input
	cat > $t/canned_command <<EOF
l
source
i
f
$t/input.txt
o
f
$t/output.txt
x
q
EOF

	# Try to execute the program on the test input
	(
	ulimit -t 2 # 2s CPU time
	ulimit -f 128 # 1kB written files
	./pep8 < $t/canned_command > /dev/null 2> $t/execerr.txt
	) || {
		ulimitmsg "$?" $t/execerr.txt
		return 1
	}

	# Add a mandatory EOL at EOF to simplify diffing
	echo >> $t/output.txt

	# If success, execerr.txt contains the time score in fact.
	mv $t/execerr.txt $t/timescore.txt

	return 0
}

# Main
compile || exit 1
for t in test*; do runtest "$t"; done
exit 0
