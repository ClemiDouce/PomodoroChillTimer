class_name MainScreen extends Node2D

# Buttons
@onready var coffee_machine_button: InteractionArea = %CoffeeMachineButton
#@onready var help_book_button: InteractionArea = %HelpBookButton
@onready var options_button: InteractionArea = %OptionsButton
@onready var credits_button: InteractionArea = %CreditsButton

# Light
@onready var light_animation_player: AnimationPlayer = %LightAnimationPlayer

# Cycle
@onready var pomo_manager: PomodoroManager = %CycleManager

func _connect_signals():
	coffee_machine_button.clicked.connect(_on_coffee_machine_clicked)
	options_button.clicked.connect(_on_option_button_clicked)
	credits_button.clicked.connect(_on_credits_button_clicked)
	
func _ready() -> void:
	_connect_signals()

func _on_coffee_machine_clicked():
	var test_config := PomodoroConfig.new(3, 1, 1, 1)
	pomo_manager.launch_pomodoro(test_config)
	
func _on_option_button_clicked():
	pass
	
func _on_credits_button_clicked():
	pass
