extends Control

@onready var volume_slider = %VolumeSlider
@onready var toggle_break = %BreakMusic

func _ready():
	volume_slider.value = MusicManager.music_level

func _on_VolumeSlider_value_changed(value):
	MusicManager.music_level = value

func _on_BreakMusic_toggled(button_pressed):
	MusicManager.pause_break = button_pressed
