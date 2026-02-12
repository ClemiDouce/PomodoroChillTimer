extends AnimationPlayer

var animation_queue = []

signal all_finished

func add_anim(anim_name: String):
	animation_queue.append(anim_name)
	
func start():
	if animation_queue.size() > 0:
		var anim_to_play = animation_queue.pop_front()
		self.play(anim_to_play)
	else:
		print("Pas d'animation dans la liste")
		emit_signal("all_finished")


func _on_Animation_animation_finished(anim_name):
	if animation_queue.size() > 0:
		var anim_to_play = animation_queue.pop_front()
		self.play(anim_to_play)
	else:
		emit_signal("all_finished")
		print("Fin d'animation")
