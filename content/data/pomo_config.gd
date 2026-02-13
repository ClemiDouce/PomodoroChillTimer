class_name PomodoroConfig extends RefCounted

var total_cycle : int
var current_cycle : int = 0

var short_break := 0
var long_break := 0
var work := 0

func _init(cycle_count: int, _short_break: int, _long_break: int, _work: int) -> void:
	short_break = _short_break
	long_break = _long_break
	work = _work
	total_cycle = cycle_count
