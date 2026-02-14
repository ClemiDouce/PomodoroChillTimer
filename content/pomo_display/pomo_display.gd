class_name PomodoroDisplay extends Node

# Display Nodes
@onready var status_label: Label = %CycleStatusLabel
@onready var time_label: Label = %TimeLabel
@onready var machine_time_label: Label = %MachineTimeLabel

var state_label : Dictionary[Pomo.State, String] = {
	Pomo.State.NONE: "No Current\nSession",
	Pomo.State.SHORT: "Short\nBreak",
	Pomo.State.LONG: "Long\nBreak",
	Pomo.State.WORK: "Work"
}


func _connect_signals():
	Config.big_timer_changed.connect(_on_timer_emplacement_changed)
	Pomo.pomo_changed_state.connect(on_pomo_state_changed)

func _ready() -> void:
	_connect_signals()

func _process(_delta: float) -> void:
	if Pomo.pomo_state != Pomo.State.NONE:
		var minutes = Pomo.cycle_timer.time_left / 60
		var seconds = fmod(Pomo.cycle_timer.time_left,60)
		var time_text = "%02d:%02d" % [minutes, seconds]
		time_label.text = time_text
		machine_time_label.text = time_text

# Display

func set_state_label(state: Pomo.State):
	if Config.status_scroll:
		var text_tween = create_tween()
		text_tween.tween_property(status_label, "visible_ratio", 0, 0.5)
		text_tween.tween_callback(func(): status_label.text = state_label.get(state))
		text_tween.tween_property(status_label, "visible_ratio", 1, 0.5)
	else:
		status_label.text = state_label.get(state)

# Signals
func on_pomo_state_changed(new_state: Pomo.State):
	set_state_label(new_state)
	if new_state == Pomo.State.NONE:
		time_label.text = "00:00"
		machine_time_label.text = "00:00"


# Session Control

func _on_timer_emplacement_changed(big: bool):
	if big:
		time_label.show()
		machine_time_label.hide()
	else:
		time_label.hide()
		machine_time_label.show()
