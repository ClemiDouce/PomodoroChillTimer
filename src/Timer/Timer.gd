extends Timer

@onready var label_temps = get_node("../GUI/Temps")
@onready var label_status = get_node("../GUI/Status")

enum CYCLE_TYPE{PAUSE, WORK, SHORT, LONG}

var actual_cycle: int = 0
var cycle_number: int
var long_time: int
var short_time: int
var work_time: int

var actual_cycle_type = CYCLE_TYPE.PAUSE: set = set_cycle_type

signal state_changed(new_state)

func _ready():

	E.connect("session_started", Callable(self, "start_session"))

	self.connect("timeout", Callable(self, "_on_self_timeout"))

	E.connect("session_stopped", Callable(self, "reset"))

func _process(_delta):
	label_temps.text = milli_to_time(self.time_left)
	
func milli_to_time(time):
	var minute = floor(time / 60)
	var seconde = ceil(int(time) % 60)
	if seconde < 10:
		seconde = "0" + str(seconde)
	if minute < 10:
		minute = "0" + str(minute)
	return str(minute) + ":" + str(seconde)

func start_session(config: Dictionary):
	long_time = config.long_time
	short_time = config.short_time
	work_time = config.work_time
	cycle_number = config.cycle_number
	MusicManager.play_music()
	start_work()

func start_work():
	self.start(work_time)
	self.actual_cycle_type = CYCLE_TYPE.WORK
	self.actual_cycle += 1
	
func start_short():
	self.start(short_time)
	self.actual_cycle_type = CYCLE_TYPE.SHORT

func start_long():
	self.start(long_time)
	self.actual_cycle_type = CYCLE_TYPE.LONG

func reset():
	MusicManager.stop_music()
	self.actual_cycle_type = CYCLE_TYPE.PAUSE
	self.actual_cycle = 0
	self.stop()
	
func set_cycle_type(new_value):
	actual_cycle_type = new_value
	emit_signal("state_changed", new_value)
	match (actual_cycle_type):
		CYCLE_TYPE.WORK:
			label_status.text = "Work"
		CYCLE_TYPE.SHORT:
			label_status.text = "Short Pause"
		CYCLE_TYPE.LONG:
			label_status.text = "Long Pause"
		CYCLE_TYPE.PAUSE:
			label_status.text = "No Session"
	
func _on_self_timeout():
	match (actual_cycle_type):
		CYCLE_TYPE.WORK:
			if actual_cycle < cycle_number:
				start_short()
			else:
				start_long()
		CYCLE_TYPE.SHORT:
			start_work()
		CYCLE_TYPE.LONG:
			reset()
			print("Session terminé !")
	
