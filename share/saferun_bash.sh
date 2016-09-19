# Small script that executes in as the main user
#
# usage:
#   ./saferun.sh dir command

dir=$1
cmd=$2

run=$dir/run.sh

echo "$cmd" > "$run"
chmod +x "$run"

if ! test -e "$run"; then
	echo >&2 "Error. '$run' not found."
	exit 1
fi

cd "$dir" && exec ./run.sh
