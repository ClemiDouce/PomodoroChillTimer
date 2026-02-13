class_name MainScreen extends Node2D

# Buttons
@onready var coffee_machine_button: InteractionArea = %CoffeeMachineButton
#TODO: Survoler le livre fait apparaitre le screen d'aide
#@onready var help_book_button: InteractionArea = %HelpBookButton
@onready var options_button: InteractionArea = %OptionsButton
@onready var credits_button: InteractionArea = %CreditsButton
@onready var credit_animation: AnimationPlayer = %CreditAnimation
@onready var option_animation: AnimationPlayer = %OptionAnimation
@onready var pomo_animation: AnimationPlayer = %PomoAnimation

# Light
@onready var light_animation_player: AnimationPlayer = %LightAnimationPlayer

# Panels
var credit_panel := false
var pomo_panel := false
var option_panel := false

func _connect_signals():
	coffee_machine_button.clicked.connect(_on_coffee_machine_clicked)
	options_button.clicked.connect(_on_option_button_clicked)
	credits_button.clicked.connect(_on_credits_button_clicked)
	
	credit_animation.animation_finished.connect(_on_credit_animation_changed)
	option_animation.animation_finished.connect(_on_option_animation_changed)
	pomo_animation.animation_finished.connect(_on_pomo_animation_changed)
	
func _ready() -> void:
	_connect_signals()

func _hide_all_panels():
	if credit_panel:
		credit_animation.play("opt_out")
	if option_panel:
		option_animation.play("opt_out")
	if pomo_panel:
		pomo_animation.play("opt_out")


func _on_coffee_machine_clicked():
	if pomo_animation.is_playing():
		return
		
	if pomo_panel:
		pomo_animation.play("opt_out")
	else:
		_hide_all_panels()
		pomo_animation.play("opt_in")
	
func _on_option_button_clicked():
	if option_animation.is_playing():
		return
		
	if option_panel:
		option_animation.play("opt_out")
	else:
		_hide_all_panels()
		option_animation.play("opt_in")
	
func _on_credits_button_clicked():
	if credit_animation.is_playing():
		return
		
	if credit_panel:
		credit_animation.play("opt_out")
	else:
		_hide_all_panels()
		credit_animation.play("opt_in")

func _on_credit_animation_changed(animation_name: String):
	credit_panel = animation_name == "opt_in"

func _on_option_animation_changed(animation_name: String):
	option_panel = animation_name == "opt_in"

func _on_pomo_animation_changed(animation_name: String):
	pomo_panel = animation_name == "opt_in"
