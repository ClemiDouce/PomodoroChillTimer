extends Control

@onready var cycle_input = %InputCycle
@onready var short_input = %InputCourte
@onready var long_input = %InputLongue
@onready var work_input = %InputTravail



func _on_ButtonValider_pressed():
	var session_config = {
		cycle_number = int(cycle_input.text), 
		short_time = int(short_input.text) * 60, 
		long_time = int(long_input.text) * 60, 
		work_time = int(work_input.text) * 60
	}
	E.emit_signal("session_started", session_config)


func _on_ButtonTest_pressed():
	var session_config = {
		cycle_number = 3, 
		short_time = 10, 
		long_time = 20, 
		work_time = 30
	}
	E.emit_signal("session_started", session_config)
