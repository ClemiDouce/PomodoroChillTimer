class_name InteractionArea extends Area2D

@export var sprite : Sprite2D
@export var action_label : Label
var sprite_material : ShaderMaterial

# Click
signal clicked

var is_mouse_hover := false

func _ready() -> void:
	assert(action_label, "No label set into export")
	action_label.hide()
	if sprite.material:
		sprite_material = sprite.material

func _mouse_enter() -> void:
	sprite_material.set_shader_parameter("width", 1)
	is_mouse_hover = true
	action_label.show()
	
func _mouse_exit() -> void:
	sprite_material.set_shader_parameter("width", 0)
	is_mouse_hover = false
	action_label.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if is_mouse_hover and Input.is_action_just_pressed("click"):
			AudioManager.play_interface_sound(AudioManager.InterfaceSound.CLICK)
			clicked.emit()
