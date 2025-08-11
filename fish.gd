extends Area2D

@export var move_speed: int = 10
var target_position: Vector2 = Vector2.ZERO
var lake_polygon: PackedVector2Array

func _ready() -> void:
	var lake_area: Area2D = get_tree().get_root().find_child("LakeArea", true, false) as Area2D
	var collision_poly: CollisionPolygon2D = lake_area.get_node("CollisionPolygon2D") as CollisionPolygon2D
	
	# Convert polygon points to global position
	lake_polygon = PackedVector2Array()
	for p: Vector2 in collision_poly.polygon:
		lake_polygon.append(collision_poly.to_global(p))
	
	set_random_target()

func _process(delta: float) -> void:
	var direction: Vector2 = (target_position - position)
	if direction.length() < 5:
		set_random_target()
	else:
		var new_position: Vector2 = global_position + direction.normalized() * move_speed * delta
		if Geometry2D.is_point_in_polygon(new_position, lake_polygon):
			global_position = new_position
		else:
			set_random_target()

func set_random_target() -> void:
	var tries: int = 0
	while tries < 100:
		var candidate_target_position: Vector2 = lake_polygon[int(randf() * lake_polygon.size())]
		if Geometry2D.is_point_in_polygon(candidate_target_position, lake_polygon):
			target_position = candidate_target_position
			return
		tries += 1
