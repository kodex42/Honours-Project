extends Node

var _current_id = 0

func increment():
	_current_id += 1

func get_next_id():
	increment()
	return get_current_id()

func get_current_id():
	return _current_id
