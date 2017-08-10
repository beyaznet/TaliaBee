#!/bin/bash

DELAY=0.1

function reset_on_exit {
	curl -s "http://127.0.0.1/api/reset"
}

trap reset_on_exit EXIT

while true
do
	# reset
	curl -s "http://127.0.0.1/api/reset"

	# read di
	for i in $(seq 1 2 16)
	do
		curl -s "http://127.0.0.1/api/di/$i/read"
		sleep $DELAY
	done

	# read do
	for i in $(seq 1 2 12)
	do
		curl -s "http://127.0.0.1/api/do/$i/read"
		sleep $DELAY
	done

	# set do
	for i in $(seq 1 12)
	do
		curl -s "http://127.0.0.1/api/do/$i/set"
		sleep $DELAY
	done

	# set relay / read relay
	for i in $(seq 13 16)
	do
		curl -s "http://127.0.0.1/api/ro/$i/set"
		curl -s "http://127.0.0.1/api/ro/$i/read"
		sleep $DELAY
	done

	# read di
	for i in $(seq 2 2 16)
	do
		curl -s "http://127.0.0.1/api/di/$i/read"
		sleep $DELAY
	done

	# read do
	for i in $(seq 2 2 12)
	do
		curl -s "http://127.0.0.1/api/do/$i/read"
		sleep $DELAY
	done

	# reset do
	for i in $(seq 1 12)
	do
		curl -s "http://127.0.0.1/api/do/$i/reset"
		sleep $DELAY
	done

	# reset relay
	for i in $(seq 13 16)
	do
		curl -s "http://127.0.0.1/api/ro/$i/reset"
		curl -s "http://127.0.0.1/api/ro/$i/read"
		sleep $DELAY
	done

	# write ao
	curl -s "http://127.0.0.1/api/ao/1/write?val=$((RANDOM % 4096))"
	curl -s "http://127.0.0.1/api/ao/2/write?val=$((RANDOM % 4096))"
	curl -s "http://127.0.0.1/api/ao/3/write?val=$((RANDOM % 4096))"
	curl -s "http://127.0.0.1/api/ao/4/write?val=$((RANDOM % 4096))"

	# read ai / ao
	for i in $(seq 1 4)
	do
		curl -s "http://127.0.0.1/api/ai/$i/read"
		curl -s "http://127.0.0.1/api/ao/$i/read"
		sleep $DELAY
	done

	# read temperature
	curl -s "http://127.0.0.1/api/temperature/read"

	# status
	curl -s "http://127.0.0.1/api/status"

	# wait
	for i in $(seq 1 20)
	do
	    V=$(($i % 2))
	    curl -s "http://127.0.0.1/api/ro/13/write?val=$V"
	    curl -s "http://127.0.0.1/api/do/4/write?val=$V"
	    sleep 0.25
	done
done
