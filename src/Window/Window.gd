@tool 
extends Sprite2D

var active = false
var way = false
var light_min_frame
var light_max_frame

enum SIZE{XL, L, M, S, XS}

@export var size: SIZE

@onready var timer = $Wink
@onready var light = $Light3D

func _ready():
	randomize()
	
	var color = randi() % 3
	self.frame = int(size) * 3 + color
	
	var buffer_light
	if size in [3, 4]:
		buffer_light = 2
	elif size in [1, 2]:
		buffer_light = 1
	else:
		buffer_light = 0
	light_min_frame = buffer_light * 9 + color * 3
	light_max_frame = light_min_frame + 2
	light.frame = light_min_frame + randi() % 3
		

func toggle():
	if active:
		active = false
		timer.stop()
		visible = false
	else:
		active = true
		visible = true
		
		self.way = randi() % 1
		
		timer.start()





func _on_Wink_timeout():
	if way:
		if light.frame + 1 > light_max_frame:
			way = false
			light.frame -= 1
		else:
			light.frame += 1
	else:
		if light.frame - 1 < light_min_frame:
			way = true
			light.frame += 1
		else:
			light.frame -= 1
