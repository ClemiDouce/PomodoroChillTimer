extends Control

@export var animation_panel: AnimationPlayer

@onready var volume_slider = %VolumeSlider
@onready var toggle_break = %BreakMusic

func _ready():
	volume_slider.value = AudioManager.music_level

func _on_volume_slider_value_changed(value: float):
	AudioManager.music_level = value

func _on_break_music_toggled(toggled: bool):
	Config.music_stop_on_break = toggled

func _on_old_timer_style_toggled(toggled_on: bool) -> void:
	Config.big_timer = !toggled_on

func _on_status_scroll_toggled(toggled_on: bool) -> void:
	Config.status_scroll = toggled_on

func _on_quit_pressed() -> void:
	animation_panel.play("opt_out")
