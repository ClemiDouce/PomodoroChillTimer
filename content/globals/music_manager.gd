extends Node

const MUSIC_BUS_INDEX = 1
const SOUND_BUS_INDEX = 2

const music_intro = preload("res://assets/music/music_intro.ogg")
const music_loop = preload("res://assets/music/music_loop.ogg")

const work_cycle = preload("res://assets/sound/br_cycle_work.wav")
const pause_cycle = preload("res://assets/sound/br_cycle_pause.wav")
const session_start = preload("res://assets/sound/br_session_start.wav")
const session_finish = preload("res://assets/sound/br_session_finish.wav")
const session_stop = preload("res://assets/sound/br_session_stop.wav")

const interface_sound = preload("res://assets/sound/br_numpad.wav")
const clickable_sound = preload("res://assets/sound/br_coffeemachine.wav")
const button_sound = preload("res://assets/sound/br_button.wav")

enum Sound {
	SESSION_FINISH,
	SESSION_START,
	SESSION_STOP,
	WORK,
	BREAK
}

enum InterfaceSound {
	CLICK,
	INTERFACE,
	BUTTON
}

# Players
@onready var music_player: AudioStreamPlayer = %MusicPlayer
@onready var cycle_change_player: AudioStreamPlayer = %CycleChangePlayer
@onready var interface_sound_player: AudioStreamPlayer = %InterfaceSoundPlayer

# Settings
var music_level : float = 50: set = set_music_level
var intro_passed : bool = false
var music_pause_position : float = 0.

func _ready() -> void:
	music_player.finished.connect(on_music_player_finished)

func on_music_player_finished():
	if !intro_passed:
		music_player.stream = music_loop
		music_player.play()
	else:
		music_player.seek(0.)

# Play Methods
func play_music():
	music_player.play()

func pause_music():
	music_pause_position = music_player.get_playback_position()
	music_player.playing = false

func resume_music():
	music_player.play(music_pause_position)
	
func stop_music():
	music_player.stream = music_intro
	music_player.stop()

func mute_music(value: bool):
	AudioServer.set_bus_mute(MUSIC_BUS_INDEX, value)

func play_sound(sound_to_play: Sound):
	match (sound_to_play):
		Sound.SESSION_FINISH:
			cycle_change_player.stream = session_finish
		Sound.SESSION_STOP:
			cycle_change_player.stream = session_stop
		Sound.WORK:
			cycle_change_player.stream = work_cycle
		Sound.BREAK:
			cycle_change_player.stream = pause_cycle
	cycle_change_player.play()
	
func play_interface_sound(sound_to_play: InterfaceSound):
	match(sound_to_play):
		InterfaceSound.CLICK:
			interface_sound_player.stream = clickable_sound
		InterfaceSound.INTERFACE:
			interface_sound_player.stream = interface_sound
		InterfaceSound.BUTTON:
			interface_sound_player.stream = button_sound
	interface_sound_player.play()


# Settings
func set_music_level(new_level: float):
	music_level = new_level
	var mapped_level = remap_range(music_level, 0, 100, - 60, 0)
	AudioServer.set_bus_volume_db(MUSIC_BUS_INDEX, mapped_level)

func remap_range(value, InputA, InputB, OutputA, OutputB):
	var result = (value - InputA) / (InputB - InputA) * (OutputB - OutputA) + OutputA
	return result
