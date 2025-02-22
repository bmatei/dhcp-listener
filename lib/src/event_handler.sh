#!/bin/bash

subscribe()
{
	echo "$1" >> "$2"
}

unsubscribe()
{
	sed -i '/^'"$1"'$/d' "$2"
}

notify()
{
	local callback="$1"
	shift
	$callback "$@"
}

notify_all()
{
	local listeners
	listeners="$(cat "$1")"
	shift
	for listener in $listeners; do
		notify "$listener" "$@"
	done
}

event_handler()
{
	local db="$1"
	while read -r event; do
		# shellcheck disable=SC2086
		notify_all "$db" $event
	done
}


