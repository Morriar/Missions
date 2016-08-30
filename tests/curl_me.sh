#!/bin/bash

# Performance tests based on curl

# The server configuration
host=localhost
port=3000
base=http://$host:$port

# Busy waiting for the port to open
wait_port() {
	while ! nc -z "$host" "$port"; do sleep 0.1; done;
}

# Visit an API page with curl and time(1) the server
# $1 the api path to visit. e.g. `api/players`
visit_api() {
	mkdir -p out
	out=out/${1////_}
	echo -n "$1 -> $out"

	# Run the server in background
	cd ..
	env time -o tests/"$out".time -f "real %e user %U sys %S maxmem %M" bin/app > /dev/null 2>&1 &
	cd - > /dev/null

	# Wait, get then kill the server
	wait_port
	curl -s -w "[%{http_code}]" "$base/$1" -o "$out".resp > "$out".code
	killall app
	wait

	code=`cat "$out".code`
	time=`tail -n 1 "$out".time`

	# Display the result
	echo " $code $time"
}

# Visit all the pages from the argument. One page per line.
visit_apis()
{
	echo "$1" | while read -r page; do
		test -z "$page" && continue
		visit_api "$page"
	done
}

visit_apis '
api/players
api/missions
api/player
api/player/notifications
api/tracks
'
