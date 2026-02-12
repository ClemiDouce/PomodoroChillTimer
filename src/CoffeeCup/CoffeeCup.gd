extends Sprite2D

@onready var fumee = $Fumee
@onready var timer = $Timer

var way: bool = true

func _ready():
	toggle(false)

func toggle(state):
	if not state:
		frame = 1
		fumee.visible = false
		timer.stop()
	else:
		frame = 0
		fumee.visible = true
		
		self.way = true
		
		timer.start()
	
func _on_Timer_timeout():
	if way:
		if fumee.frame + 1 > 2:
			way = false
			fumee.frame -= 1
		else:
			fumee.frame += 1
	else:
		if fumee.frame - 1 < 0:
			way = true
			fumee.frame += 1
		else:
			fumee.frame -= 1
