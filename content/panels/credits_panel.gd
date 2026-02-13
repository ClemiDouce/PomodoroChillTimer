extends Control

@export var animation_panel: AnimationPlayer



func _on_quit_pressed() -> void:
	animation_panel.play("opt_out")
