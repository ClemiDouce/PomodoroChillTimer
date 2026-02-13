extends Node

#region Signals
signal pomo_started
signal pomo_stopped
signal pomo_paused

signal pomo_changed_state(new_state: State)
#endregion

enum State {
	NONE,
	WORK,
	SHORT,
	LONG
}

var cycle_timer: Timer

var pomo_state : State = State.NONE: set = set_pomo_state
var current_pomo : PomodoroConfig = null

func _ready() -> void:
	cycle_timer = Timer.new()
	cycle_timer.autostart = false
	cycle_timer.one_shot = true
	add_child(cycle_timer)
	cycle_timer.timeout.connect(_on_cycle_timer_timeout)

func launch_pomodoro(config: PomodoroConfig):
	current_pomo = config
	pomo_state = State.WORK
	pomo_started.emit()
	AudioManager.play_sound(AudioManager.Sound.SESSION_START)
	AudioManager.play_music()

func stop_pomodoro():
	pomo_stopped.emit()
	AudioManager.play_sound(AudioManager.Sound.SESSION_STOP)
	pomo_state = State.NONE
	current_pomo = null

func toggle_pomodoro(state: bool):
	cycle_timer.paused = state
	if state:
		AudioManager.pause_music()
		pomo_paused.emit()
	else:
		AudioManager.resume_music()
# Pomo State

func _on_cycle_timer_timeout():
	match(pomo_state):
		State.WORK:
			current_pomo.current_cycle += 1
			if Config.music_stop_on_break:
				AudioManager.pause_music()
			if current_pomo.current_cycle == current_pomo.total_cycle:
				pomo_state = State.LONG
			else:
				pomo_state = State.SHORT
		State.SHORT, State.LONG:
			if Config.music_stop_on_break:
				AudioManager.resume_music()
			pomo_state = State.WORK

		_:
			push_error("Mistake in code")

func set_pomo_state(new_state: State):
	pomo_state = new_state
	pomo_changed_state.emit(new_state)
	match(new_state):
		State.SHORT:
			AudioManager.play_sound(AudioManager.Sound.BREAK)
			cycle_timer.wait_time = current_pomo.short_break * 60
			cycle_timer.start()

		State.LONG:
			AudioManager.play_sound(AudioManager.Sound.BREAK)
			cycle_timer.wait_time = current_pomo.long_break * 60
			cycle_timer.start()

		State.WORK:
			AudioManager.play_sound(AudioManager.Sound.WORK)
			cycle_timer.wait_time = current_pomo.work * 60
			cycle_timer.start()

		State.NONE:
			cycle_timer.stop()
			AudioManager.stop_music()
