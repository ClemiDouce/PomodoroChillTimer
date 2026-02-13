class_name PomoCreatorPanel extends Control

@export var animation_player : AnimationPlayer

@onready var cycle_input: SpinBox = %CycleInput
@onready var work_input: SpinBox = %WorkInput
@onready var short_break_input: SpinBox = %ShortBreakInput
@onready var long_break_input: SpinBox = %LongBreakInput


func _on_validate_button_pressed() -> void:
	if cycle_input.value > 0. and work_input.value > 0. and  short_break_input.value > 0. and long_break_input.value > 0.:
		var new_pomo = PomodoroConfig.new(
			int(cycle_input.value), int(short_break_input.value), int(long_break_input.value), int(work_input.value)
		)
		Pomo.launch_pomodoro(new_pomo)
		close_panel()

func _on_quit_button_pressed() -> void:
	close_panel()

func close_panel():
	animation_player.play("opt_out")
