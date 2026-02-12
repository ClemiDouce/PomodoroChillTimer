extends Node2D

@onready var cafetiere_sprite = $Background/Cafetiere/Sprite2D
@onready var coffee_cup: Sprite2D = %CoffeeCup

@onready var light_sprite: Sprite2D = $Background/LightSprite

@onready var cycle_timer: Timer = %CycleTimer
@onready var help_screen: Control = %HelpScreen

# Sessions Control Buttons
@onready var pause_button: TextureButton = %PauseButton
@onready var stop_button: TextureButton = %StopButton
@onready var mute_button: TextureButton = %MuteButton

# Welcome Part
@onready var welcome_screen_parent: Control = %WelcomeScreen
@onready var welcome_text_panel: PanelContainer = %WelcomePanel


@onready var book_credit: Area2D = %Livre
@onready var cafetiere: Area2D = %Cafetiere
@onready var book_help: Area2D = %HelpBook
@onready var option: Area2D = %Option


# Panel Animators
@onready var credit_animation: AnimationPlayer = %CreditsPanelAnimation
@onready var options_animation: AnimationPlayer = %OptionsPanelAnimation
@onready var cycle_animation: AnimationPlayer = %CyclePanelAnimation

var light_way = true
var welcome_screen = false

var cycle_state = false
var credits_state = false
var options_state = false

func _ready():
	E.session_started.connect(cycle_out)

func cycle_in():
	cafetiere.monitoring = true
	cycle_animation.play("CycleIn")
	cycle_state = true
	
func cycle_out(_config = null):
	cafetiere.monitoring = false
	cycle_animation.play("CycleOut")
	cycle_state = false
	
func credits_in():
	book_credit.desactivated = true
	credit_animation.play("CreditsIn")
	credits_state = true
	
func credits_out():
	book_credit.desactivated = false
	credit_animation.play("CreditsOut")
	credits_state = false

func options_in():
	option.desactivated = true
	options_animation.play("OptionsIn")
	options_state = true
	
func options_out():
	option.desactivated = false
	options_animation.play("OptionsOut")
	options_state = false

func _on_Timer_state_changed(new_state):
	match (new_state):
		0:
			coffee_cup.toggle(false)
			cafetiere_sprite.frame = 0
			MusicManager.stop_music()
			if not MusicManager.sound_player.playing:
				MusicManager.play_sound("session_finish")
		1:
			coffee_cup.toggle(false)
			cafetiere_sprite.frame = 1
			MusicManager.play_sound("work_cycle")
			if MusicManager.pause_break:
				MusicManager.music_in()
			
		2, 3:
			coffee_cup.toggle(true)
			cafetiere_sprite.frame = 0
			MusicManager.play_sound("pause_cycle")
			if MusicManager.pause_break:
				MusicManager.music_out()


func _on_LightTimer_timeout():
	if light_way:
		if light_sprite.frame + 1 > 2:
			light_way = false
			light_sprite.frame -= 1
		else:
			light_sprite.frame += 1
	else:
		if light_sprite.frame - 1 < 0:
			light_way = true
			light_sprite.frame += 1
		else:
			light_sprite.frame -= 1


func _on_Livre_clicked():
	if credits_state == false:
		reset_panel()
		credits_in()


func _on_Cafetiere_clicked():
	if cycle_state == false:
		reset_panel()
		cycle_in()
		

func _on_Option_clicked():
	if options_state == false:
		reset_panel()
		options_in()
		

func _on_HelpBook_clicked():
	get_tree().call_group("clickable", "set_shader", false)
	stop_button.visible = true
	help_screen.visible = true
	
func reset_panel():
	if cycle_state == true:
		cycle_out()
	if options_state == true:
		options_out()
	if credits_state == true:
		credits_out()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click", false):
		reset_panel()

func _on_Quit_Credits_pressed():
	credits_out()
	MusicManager.play_interface_sound("button")

func _on_Quit_Cycle_pressed():
	cycle_out()
	MusicManager.play_interface_sound("button")
	

func _on_Quit_Options_pressed():
	options_out()
	MusicManager.play_interface_sound("button")
	


func _on_HelpBook_hoverred():
	get_tree().call_group("clickable", "set_shader", true)


func _on_HelpBook_stop_hoverred():
	get_tree().call_group("clickable", "set_shader", false)


func _on_HideHelp_pressed():
	MusicManager.play_interface_sound("button")
	if cycle_timer.actual_cycle_type == 0:
		stop_button.hide()
	welcome_text_panel.hide()
	welcome_screen_parent.hide()
	help_screen.hide()
