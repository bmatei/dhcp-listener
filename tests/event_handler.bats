#!/usr/bin/env bats

setup()
{
	PATH=./bin/src:$PATH
	. lib/src/event_handler.sh
	DB_FILE="subscribers.$RANDOM"
	LOG_FILE="log.$RANDOM"
	> "$DB_FILE"
	> "$LOG_FILE"
}

teardown()
{
	rm "$DB_FILE" "$LOG_FILE"
}

file_length_is()
{
	local len=$(cat "$1" | wc -l)
	[ $len -eq $2 ]
}

db_length_is()
{
	file_length_is "$DB_FILE" $1
}

is_subscribed()
{
	grep "$1" "$DB_FILE"
}

@test "new db has no subscribers" {
	db_length_is 0
}

@test "after subscribe call db has that one subscriber" {
	local cb1="test_subscribe_callback"
	subscribe "$cb1" "$DB_FILE"
	db_length_is 1
	is_subscribed "$cb1"
}

@test "after two subscribe calls db has those two subscribers" {
	local cb1="test_subscribe_callback"
	local cb2="test2_subscribe_callback"

	subscribe "$cb1" "$DB_FILE"
	subscribe "$cb2" "$DB_FILE"
	db_length_is 2
	is_subscribed "$cb1"
	is_subscribed "$cb2"
}

@test "unsubscribing deletes subscriber from db" {
	local cb1="test_subscribe_callback"
	local cb2="test2_subscribe_callback"

	subscribe "$cb1" "$DB_FILE"
	subscribe "$cb2" "$DB_FILE"
	unsubscribe "$cb1" "$DB_FILE"
	! is_subscribed "$cb1"
	is_subscribed "$cb2"
	db_length_is 1
}

@test "all unsubscribe then db has no subscribers" {
	local cb1="test_subscribe_callback"
	local cb2="test2_subscribe_callback"

	subscribe "$cb1" "$DB_FILE"
	subscribe "$cb2" "$DB_FILE"
	unsubscribe "$cb1" "$DB_FILE"
	unsubscribe "$cb2" "$DB_FILE"
	! is_subscribed "$cb1"
	! is_subscribed "$cb2"
	db_length_is 0
}

listener1() {
	echo "listener1 received $@" >> "$LOG_FILE"
}

listener2() {
	echo "listener2 received $@" >> "$LOG_FILE"	
}

log_length_is()
{
	file_length_is "$LOG_FILE" $1
}

received_event()
{
	grep -q "$1 received $2" "$LOG_FILE"
}

@test "no subscribers receive no event" {
	notify_all "$DB_FILE" event
	log_length_is 0
}

@test "multiple subscribers each receive own event" {
	subscribe listener1 "$DB_FILE"
	subscribe listener2 "$DB_FILE"
	notify_all "$DB_FILE" event
	log_length_is 2
	received_event listener1 event
	received_event listener2 event
}
