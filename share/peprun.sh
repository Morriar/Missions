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

# Try to compile
compile() {
	# Try to compile
	./asem8 source.pep 2> cmperr.txt

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
	./pep8 < $t/canned_command > /dev/null 2> $t/execerr.txt || return 1

	# Add a mandatory EOL at EOF to simplify diffing
	echo >> $t/output.txt

	# If success, execerr.txt contains the time score in fact.
	mv $t/execerr.txt $t/timescore.txt

	return 0
}

# Main
compile || exit 1
for t in test*; do runtest "$t"; done
