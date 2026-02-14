extends Node

signal big_timer_changed(toggle: bool)

var big_timer : bool = true: set = set_big_timer
var music_stop_on_break : bool = false
var status_scroll := false

func set_big_timer(state: bool):
	big_timer = state
	big_timer_changed.emit(state)
