extends Node2D

@export var reel_rate: int = 30    # how fast you pull fish in
@export var lose_rate: int = 20    # how fast you lose progress

var catching: bool = false
var fishing_started: bool = false

var catch_meter: TextureProgressBar
var hook: Area2D
var fish: Area2D

func _ready() -> void:
	catch_meter = $CatchMeter as TextureProgressBar
	hook = $Player/Hook as Area2D
	fish = $Fish as Area2D
	catch_meter.max_value = 100
	catch_meter.value = 100

	hook.connect("area_entered", Callable(self, "_on_hook_area_entered"))
	hook.connect("area_exited", Callable(self, "_on_hook_area_exited"))

func _process(delta: float) -> void:
	
	if not fishing_started:
		if Input.is_action_just_pressed("ui_accept"): # space by default
			fishing_started = true
			return

	if catching:
		catch_meter.value = max(0, catch_meter.value - reel_rate * delta)
	else:
		catch_meter.value = min(catch_meter.max_value, catch_meter.value + lose_rate * delta)

	if catch_meter.value <= 0:
		print("You caught the fish!")
		fishing_started = false
		# TODO: win animation or reset

func _on_hook_area_entered(area: Area2D) -> void:
	if area == fish:
		catching = true

func _on_hook_area_exited(area: Area2D) -> void:
	if area == fish:
		catching = false
