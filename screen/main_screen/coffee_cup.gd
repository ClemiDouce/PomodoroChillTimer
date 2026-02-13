extends Node2D

@onready var cup_sprite: Sprite2D = %CupSprite
@onready var smoke_sprite: Sprite2D = %SmokeSprite
@onready var smoke_animation_player: AnimationPlayer = %SmokeAnimationPlayer

func _ready() -> void:
	E.pomo_changed_state.connect(_on_pomo_changed_state)
	cup_sprite.frame = 1
	smoke_sprite.hide()
	
func _on_pomo_changed_state(new_state: Pomo.State):
	match(new_state):
		Pomo.State.WORK, Pomo.State.NONE:
			cup_sprite.frame = 1
			smoke_sprite.hide()
		Pomo.State.SHORT, Pomo.State.LONG:
			smoke_sprite.show()
			cup_sprite.frame = 0
