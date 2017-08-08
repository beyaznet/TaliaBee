#!/bin/bash

DELAY=0.1

while true
do
	# reset
	curl "http://127.0.0.1/api/reset"

	# read di
	for i in $(seq 1 2 16)
	do
		curl "http://127.0.0.1/api/di/$i/read"
		sleep $DELAY
	done

	# read do
	for i in $(seq 1 2 12)
	do
		curl "http://127.0.0.1/api/do/$i/read"
		sleep $DELAY
	done

	# set do
	for i in $(seq 1 12)
	do
		curl "http://127.0.0.1/api/do/$i/set"
		sleep $DELAY
	done

	# set relay / read relay
	for i in $(seq 13 16)
	do
		curl "http://127.0.0.1/api/ro/$i/set"
		curl "http://127.0.0.1/api/ro/$i/read"
		sleep $DELAY
	done

	# read di
	for i in $(seq 2 2 16)
	do
		curl "http://127.0.0.1/api/di/$i/read"
		sleep $DELAY
	done

	# read do
	for i in $(seq 2 2 12)
	do
		curl "http://127.0.0.1/api/do/$i/read"
		sleep $DELAY
	done

	# reset do
	for i in $(seq 1 12)
	do
		curl "http://127.0.0.1/api/do/$i/reset"
		sleep $DELAY
	done

	# reset relay
	for i in $(seq 13 16)
	do
		curl "http://127.0.0.1/api/ro/$i/reset"
		curl "http://127.0.0.1/api/ro/$i/read"
		sleep $DELAY
	done

	# increment ao
	for i in $(seq 0 50 4095)
	do
		curl "http://127.0.0.1/api/ao/1/write?val=$i"
		curl "http://127.0.0.1/api/ao/2/write?val=$i"
		curl "http://127.0.0.1/api/ao/3/write?val=$i"
		curl "http://127.0.0.1/api/ao/4/write?val=$i"
	done

	# read ai / ao
	for i in $(seq 1 4)
	do
		curl "http://127.0.0.1/api/ai/$i/read"
		curl "http://127.0.0.1/api/ao/$i/read"
		sleep $DELAY
	done

	# decrement ao
	for i in $(seq 4095 -50 0)
	do
		curl "http://127.0.0.1/api/ao/1/write?val=$i"
		curl "http://127.0.0.1/api/ao/2/write?val=$i"
		curl "http://127.0.0.1/api/ao/3/write?val=$i"
		curl "http://127.0.0.1/api/ao/4/write?val=$i"
	done

	# write relay
	for i in $(seq 13 16)
	do
		curl "http://127.0.0.1/api/ro/$i/write?val=1"
		sleep $DELAY
	done

	# write do
	for i in $(seq 1 12)
	do
		curl "http://127.0.0.1/api/do/$i/write?val=1"
		sleep $DELAY
	done

	# read temperature
	curl "http://127.0.0.1/api/temperature/read"

	# status
	curl "http://127.0.0.1/api/status"
done
