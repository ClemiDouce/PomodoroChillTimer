extends Node

@onready var sound_player = AudioStreamPlayer.new()
@onready var music_player = AudioStreamPlayer.new()
@onready var interface_player = AudioStreamPlayer.new()
var volume_tween : Tween

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

const MUSIC_BUS_INDEX = 1
const SOUND_BUS_INDEX = 2

var music_level: float = 100.0: set = set_music_level
var paused = false
var pause_break = false

func _ready():
	music_player.finished.connect(_on_music_player_finished)
	music_player.bus = "Music"
	sound_player.bus = "Sound"
	interface_player.bus = "Sound"
	add_child(music_player)
	add_child(sound_player)
	add_child(interface_player)
	
func play_music():
	paused = false
	music_player.stream = music_intro
	music_player.play()

func stop_music():
	paused = true
	if volume_tween:
		volume_tween.kill()
	volume_tween = create_tween()
	volume_tween.tween_property(music_player, "volume_db", -60, 3)
	await volume_tween.finished
	music_player.stop()
	music_player.volume_db = 0

func music_out():
	if volume_tween:
		volume_tween.kill()
	volume_tween = create_tween()
	volume_tween.tween_property(music_player, "volume_db",- 60, 3)

func music_in():
	if volume_tween:
		volume_tween.kill()
	volume_tween = create_tween()
	volume_tween.interpolate_property(music_player, "volume_db", - 60, 0, 3, Tween.TRANS_LINEAR, 
		Tween.EASE_IN)

func set_music_level(new_level: float):
	music_level = new_level
	if music_player.playing:
		var mapped_level = Utils.remap_range(music_level, 0, 100, - 60, 0)
		AudioServer.set_bus_volume_db(MUSIC_BUS_INDEX, mapped_level)


func play_sound(sound_to_play: String):
	match (sound_to_play):
		"session_finish":
			sound_player.stream = session_finish
		"session_stop":
			sound_player.stream = session_stop
		"work_cycle":
			sound_player.stream = work_cycle
		"pause_cycle":
			sound_player.stream = pause_cycle
	sound_player.play()
	
func play_interface_sound(sound_to_play: String):
	match (sound_to_play):
		"clickable":
			interface_player.stream = clickable_sound
		"interface":
			interface_player.stream = interface_player
		"button":
			interface_player.stream = button_sound
	interface_player.play()
