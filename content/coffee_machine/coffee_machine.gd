extends Sprite2D

func _ready() -> void:
	E.pomo_changed_state.connect(_on_pomo_changed_state)
	
func _on_pomo_changed_state(new_state: Pomo.State):
	match(new_state):
		Pomo.State.WORK:
			self.frame = 1
		Pomo.State.SHORT, Pomo.State.LONG, Pomo.State.NONE:
			self.frame = 0
