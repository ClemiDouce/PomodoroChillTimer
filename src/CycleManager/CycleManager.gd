extends Control

@onready var cycle_input = %InputCycle
@onready var short_input = %InputCourte
@onready var long_input = %InputLongue
@onready var work_input = %InputTravail

func _on_ButtonValider_pressed():
	if [
		cycle_input.text,
		short_input.text,
		long_input.text,
		work_input.text
	].any(func(el: String): return el == ""):
		return
	var session_config = {
		cycle_number = int(cycle_input.text), 
		short_time = int(short_input.text) * 60, 
		long_time = int(long_input.text) * 60, 
		work_time = int(work_input.text) * 60
	}
	E.emit_signal("session_started", session_config)
