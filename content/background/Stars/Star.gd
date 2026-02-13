extends Sprite2D

var way: bool = false

func _ready():
	way = randi() % 1
	frame = randi() % 3

func _on_Timer_timeout():
	if way:
		if frame + 1 > 2:
			way = false
			frame -= 1
		else:
			frame += 1
	else:
		if frame - 1 < 0:
			way = true
			frame += 1
		else:
			frame -= 1
