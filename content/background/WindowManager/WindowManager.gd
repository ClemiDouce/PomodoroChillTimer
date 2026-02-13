extends Node2D

var window_list = []
var window_toggled = []

@export var time_for_change: float = 10
@export var max_window: int = 9

@onready var timer = $Timer

func _ready():
	randomize()
	window_list = $Windows.get_children()
	toggle_window()

func _on_Timer_timeout():
	toggle_window()
	timer.wait_time = randf_range(time_for_change - 2, time_for_change)
	timer.start()
	
func toggle_window():
	for window in window_toggled:
		window.toggle()
	window_toggled.clear()
	var window_nbr = randi() % max_window + 1;
	var index_list = range(0, window_list.size())
	index_list.shuffle()
	var final_index = index_list.slice(0, window_nbr - 1)
	for i in final_index:
		window_list[i].toggle()
		window_toggled.append(window_list[i])
