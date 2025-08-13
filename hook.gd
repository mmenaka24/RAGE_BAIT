extends Area2D

@export var speed: int = 40
var lake_polygon: PackedVector2Array

# wobble variables
@export var wobble_amount: float = 0.5
var wobble_offset: Vector2 = Vector2.ZERO
var base_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	base_position = global_position
	var lake_area: Area2D = get_tree().get_root().find_child("LakeArea", true, false)
	var collision_poly: CollisionPolygon2D = lake_area.get_node("CollisionPolygon2D") as CollisionPolygon2D
	
	# Convert polygon points to global position
	lake_polygon = PackedVector2Array()
	for p: Vector2 in collision_poly.polygon:
		lake_polygon.append(collision_poly.to_global(p))

func _process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		
	if direction != Vector2.ZERO:
		base_position += direction.normalized() * speed * delta
		
		# Keep hook inside lake
		# if Geometry2D.is_point_in_polygon(new_position, lake_polygon):
			# global_position = new_position
	
	# Wobble: add a small random offset around base_position
	var wobble_offset: Vector2 = Vector2(
		randf_range(-wobble_amount, wobble_amount),
		randf_range(-wobble_amount, wobble_amount)
	)
	global_position = base_position + wobble_offset
