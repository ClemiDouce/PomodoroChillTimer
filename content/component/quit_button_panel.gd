extends TextureButton

func _ready() -> void:
	mouse_entered.connect(func(): self_modulate = Color.BLACK)
	mouse_exited.connect(func(): self_modulate = Color("#808080"))
