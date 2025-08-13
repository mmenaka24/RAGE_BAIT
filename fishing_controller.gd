extends Node2D

@export var reel_rate: int = 50    # how fast you pull fish in
@export var lose_rate: int = 20    # how fast you lose progress
@export var game_time: int = 60    # the time limit in seconds

var catching: bool = false
var fishing_started: bool = false
var score: int = 0
var catch_meter_start_value: int = 100

var catch_meter: TextureProgressBar
var hook: Area2D
var fish: Area2D
var timer_label: Label
var score_label: Label
var game_timer: Timer
var spawn_timer: Timer

func _ready() -> void:
	# node refs
	catch_meter = $CatchMeter as TextureProgressBar
	hook = $Player/Hook as Area2D
	fish = $Fish as Area2D
	timer_label = $TimerLabel as Label
	score_label = $ScoreLabel as Label
	game_timer = $GameTimer as Timer
	spawn_timer = $SpawnTimer as Timer
	
	# setup ui
	catch_meter.min_value = 0
	catch_meter.max_value = 140
	catch_meter.value = catch_meter_start_value
	timer_label.text = str(game_time)
	score_label.text = "Score: 0"
	
	# hide hook & fish initially
	hook.visible = false
	fish.visible = false
	
	# signals
	hook.connect("area_entered", Callable(self, "_on_hook_area_entered"))
	hook.connect("area_exited", Callable(self, "_on_hook_area_exited"))
	game_timer.connect("timeout", Callable(self, "_on_game_timeout"))
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timeout"))
	
	# start game
	score = 0
	game_timer.start(game_time)
	spawn_timer.start(randf_range(0.5, 5.0)) # first fish spawn delay

func _process(delta: float) -> void:
	timer_label.text = str(int(ceil(game_timer.time_left)))
	
	if fishing_started:
		if catching:
			catch_meter.value = max(0, catch_meter.value - reel_rate * delta)
		else:
			catch_meter.value = min(catch_meter.max_value, catch_meter.value + lose_rate * delta)

		if catch_meter.value <= 0:
			_on_fish_caught()
			# TODO: win animation or reset

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and fish.visible and not fishing_started:
		start_fishing()

# game cycle

func _on_spawn_timeout() -> void:
	# show fish, wait for player to press space
	fish.set_speed()
	fish.visible = true
	fishing_started = false
	catch_meter.value = min(catch_meter_start_value, catch_meter.max_value)
	spawn_timer.start(game_time)

func start_fishing() -> void:
	fishing_started = true
	hook.position = Vector2.ZERO
	hook.visible = true

func _on_fish_caught() -> void:
	score += 1
	score_label.text = "Score: %d" %score
	fishing_started = false
	hook.visible = false
	fish.visible = false
	spawn_timer.start(randf_range(0.5, 5.0)) # next fish delay

# end of game
func _on_game_timeout() -> void:
	fishing_started = false
	hook.visible = false
	fish.visible = false
	print("Game Over! Score: ", score)
	# move to next scene + pass score

# collisions
func _on_hook_area_entered(area: Area2D) -> void:
	if area == fish:
		catching = true

func _on_hook_area_exited(area: Area2D) -> void:
	if area == fish:
		catching = false
