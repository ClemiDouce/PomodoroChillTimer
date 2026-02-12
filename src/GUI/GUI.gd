extends Control

var is_muted = false

const music_off_sprite = preload("res://assets/sprite/GUI/musicOff.png")
const music_on_sprite = preload("res://assets/sprite/GUI/musicOn.png")

@onready var pause_button: TextureButton = %PauseButton
@onready var stop_button: TextureButton = %StopButton
@onready var mute_button: TextureButton = %MuteButton

func _ready():
	E.session_started.connect(_on_session_started)
	E.session_stopped.connect(_on_session_stopped)

func _on_session_started(_config = null):
	stop_button.show()
	pause_button.show()
	
func _on_session_stopped():
	stop_button.hide()
	pause_button.hide()
	pause_button.button_pressed = false


func _on_StopButton_pressed():
	E.emit_signal("session_stopped")

func _on_pause_button_pressed(toggled: bool):
	print(toggled)

func _on_MuteButton_pressed():
	is_muted = not is_muted
	if is_muted:
		mute_button.texture_normal = music_off_sprite
		MusicManager.music_level = 0
	else:
		mute_button.texture_normal = music_on_sprite
		MusicManager.music_level = 100
