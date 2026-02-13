class_name PomodoroManager extends Node

@export var cycle_timer : Timer 

# Display Nodes
@onready var status_label: Label = %CycleStatusLabel
@onready var time_label: Label = %TimeLabel
@onready var machine_time_label: Label = %MachineTimeLabel

# Control Buttons
@onready var pause_button: TextureButton = %PauseButton
@onready var stop_button: TextureButton = %StopButton
@onready var mute_button: TextureButton = %MuteButton
@onready var session_control: Control = %SessionControl

var state_label : Dictionary[Pomo.State, String] = {
	Pomo.State.NONE: "No\nSession",
	Pomo.State.SHORT: "Short\nBreak",
	Pomo.State.LONG: "Long\nBreak",
	Pomo.State.WORK: "Work"
}

var pomo_state : Pomo.State: set = set_pomo_state
var current_pomo : PomodoroConfig = null

func _connect_signals():
	cycle_timer.timeout.connect(_on_cycle_timer_timeout)
	Config.big_timer_changed.connect(_on_timer_emplacement_changed)

func _ready() -> void:
	# Test Config
	_connect_signals()
	#var test_config := PomodoroConfig.new(3, 1, 1, 1)
	#launch_pomodoro(test_config)

func _process(_delta: float) -> void:
	if pomo_state != Pomo.State.NONE:
		var minutes = cycle_timer.time_left / 60
		var seconds = fmod(cycle_timer.time_left,60)
		var time_text = "%02d:%02d" % [minutes, seconds]
		time_label.text = time_text
		machine_time_label.text = time_text

# Logic
func launch_pomodoro(config: PomodoroConfig):
	current_pomo = config
	pomo_state = Pomo.State.WORK
	session_control.show()
	AudioManager.play_sound(AudioManager.Sound.SESSION_START)
	AudioManager.play_music()

func stop_pomodoro():
	pomo_state = Pomo.State.NONE
	current_pomo = null

# Display

func set_state_label():
	var text_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	text_tween.tween_property(status_label, "visible_ratio", 0, 1.)
	text_tween.tween_callback(func(): status_label.text = state_label.get(pomo_state))
	text_tween.tween_property(status_label, "visible_ratio", 1, 1.2)
	

# Signals
func _on_cycle_timer_timeout():
	match(pomo_state):
		Pomo.State.WORK:
			current_pomo.current_cycle += 1
			if Config.music_stop_on_break:
				AudioManager.pause_music()
			if current_pomo.current_cycle == current_pomo.total_cycle:
				pomo_state = Pomo.State.LONG
			else:
				pomo_state = Pomo.State.SHORT
		Pomo.State.SHORT, Pomo.State.LONG:
			if Config.music_stop_on_break:
				AudioManager.resume_music()
			pomo_state = Pomo.State.WORK

		_:
			push_error("Mistake in code")

# Setters
func set_pomo_state(new_state: Pomo.State):
	pomo_state = new_state
	set_state_label()
	E.pomo_changed_state.emit(new_state)
	match(new_state):
		Pomo.State.SHORT:
			AudioManager.play_sound(AudioManager.Sound.BREAK)
			cycle_timer.wait_time = current_pomo.short_break * 60
			cycle_timer.start()

		Pomo.State.LONG:
			AudioManager.play_sound(AudioManager.Sound.BREAK)
			cycle_timer.wait_time = current_pomo.long_break * 60
			cycle_timer.start()

		Pomo.State.WORK:
			AudioManager.play_sound(AudioManager.Sound.WORK)
			cycle_timer.wait_time = current_pomo.work * 60
			cycle_timer.start()

		Pomo.State.NONE:
			cycle_timer.stop()
			session_control.hide()
			AudioManager.stop_music()
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

func _on_pause_button_toggled(toggled_on: bool) -> void:
	cycle_timer.paused = toggled_on
	if toggled_on:
		AudioManager.pause_music()
	else:
		AudioManager.resume_music()


func _on_stop_button_pressed() -> void:
	AudioManager.play_sound(AudioManager.Sound.SESSION_STOP)
	stop_pomodoro()


func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioManager.mute_music(toggled_on)
