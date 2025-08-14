extends Area2D

@export var max_move_speed: int = 100
@export var change_direction_time: float = 1.0 # seconds before picking a new direction
@export var fish_textures: Array[Texture2D] = []

var sprite: Sprite2D

var velocity: Vector2 = Vector2.ZERO
var lake_polygon: PackedVector2Array
var direction_timer: float = 0.0

var move_speed: int = 40
var flying_fish: bool = false

func _ready() -> void:
	sprite = $Sprite2D as Sprite2D
	var lake_area: Area2D = get_tree().get_root().find_child("LakeArea", true, false) as Area2D
	var collision_poly: CollisionPolygon2D = lake_area.get_node("CollisionPolygon2D") as CollisionPolygon2D
	
	# Convert polygon points to global position
	lake_polygon = PackedVector2Array()
	for p: Vector2 in collision_poly.polygon:
		lake_polygon.append(collision_poly.to_global(p))
	
	pick_new_direction()

func _process(delta: float) -> void:
	direction_timer -= delta
	if direction_timer <= 0:
		pick_new_direction()
	
	var new_position: Vector2 = global_position + velocity * delta
	if Geometry2D.is_point_in_polygon(new_position, lake_polygon):
		global_position = new_position
	elif flying_fish:
		pass
	else:
		pick_new_direction()

func set_speed() -> void:
	move_speed = randi_range(10, max_move_speed)

func pick_new_direction() -> void:
	# pick a random unit direction
	var angle: float = randf() * TAU
	velocity = Vector2(cos(angle), sin(angle)) * move_speed
	direction_timer = randf_range(0.01, change_direction_time)

func set_flying_fish() -> void:
	flying_fish = true
	sprite.texture = fish_textures[7]

func set_normal_fish() -> void:
	flying_fish = false
	sprite.texture = fish_textures[randi_range(0, 6)]
