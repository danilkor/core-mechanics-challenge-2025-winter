extends StaticBody2D

@onready var wall_shape: CollisionPolygon2D = $CollisionPolygon2D

signal damage_wall(damage_polygon: CollisionPolygon2D)

func _ready() -> void:
	damage_wall.connect(_on_damage)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_damage(damage_polygon: CollisionPolygon2D) -> void:
	# offset polygon
	var offset_polygon: PackedVector2Array
	for vert in damage_polygon.polygon:
		offset_polygon.append((vert+damage_polygon.global_position)-wall_shape.global_position)
	
	# do damage
	var new_polygon = Geometry2D.clip_polygons(wall_shape.polygon, offset_polygon)[0]
	wall_shape.set_deferred("polygon", new_polygon)
	#recalculate to check for small parts (later)
