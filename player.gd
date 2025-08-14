extends Sprite2D

@onready var end_of_rod: Marker2D = $Rod/EndOfRod
@onready var fishing_line: Line2D = $FishingLine
@onready var hook: Area2D = $Hook
@onready var hook_position: Marker2D = $Hook/Marker2D

func _process(delta: float) -> void:
	if hook.visible:
		fishing_line.clear_points()
		fishing_line.add_point(to_local(end_of_rod.global_position))
		fishing_line.add_point(to_local(hook_position.global_position))
