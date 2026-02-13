extends Control

@onready var pause_button: TextureButton = %PauseButton
@onready var stop_button: TextureButton = %StopButton

func _ready() -> void:
	Pomo.pomo_changed_state.connect(on_pomo_state_changed)
	Pomo.pomo_started.connect(on_pomo_started)
	pause_button.hide()
	stop_button.hide()

# Signals Methods
func on_pomo_state_changed(new_state: Pomo.State):
	if new_state == Pomo.State.NONE:
		pause_button.hide()
		stop_button.hide()
		pause_button.button_pressed = false
		
func on_pomo_started():
	pause_button.show()
	stop_button.show()
# Buttons Methods
func _on_pause_button_toggled(toggled_on: bool) -> void:
	Pomo.toggle_pomodoro(toggled_on)


func _on_stop_button_pressed() -> void:
	Pomo.stop_pomodoro()


func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioManager.mute_music(toggled_on)
