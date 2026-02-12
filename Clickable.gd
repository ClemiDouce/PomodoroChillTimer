extends Area2D

@onready var sprite = $Sprite2D
var desactivated = false
var is_mouse_over = false

signal clicked
signal hoverred
signal stop_hoverred

func set_shader(state: bool):
	if state:
		sprite.material.set_shader_parameter("width", 1)
		$Title.visible = true
	else:
		sprite.material.set_shader_parameter("width", 0)
		$Title.visible = false

func _on_Clickable_mouse_entered():
	is_mouse_over = true
	emit_signal("hoverred")
	if not desactivated:
		set_shader(true)
	
	
func _on_Clickable_mouse_exited():
	emit_signal("stop_hoverred")
	set_shader(false)
	is_mouse_over = false
	
func _input(event):
	if not desactivated:
		if (event is InputEventMouseButton and event.is_action_pressed("click", false)
			and is_mouse_over):
			get_viewport().set_input_as_handled()
			MusicManager.play_interface_sound("clickable")
			emit_signal("clicked")
		
		
		
