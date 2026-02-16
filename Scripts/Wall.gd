extends StaticBody2D
class_name Wall
@onready var wall_shape: CollisionPolygon2D = $CollisionPolygon2D

signal damage_wall(damage_polygon: CollisionPolygon2D)

var wall_node = preload("res://Nodes/Wall.tscn")

func _ready() -> void:
	damage_wall.connect(_on_damage)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_new_wall(polygon: PackedVector2Array):
	var new_wall: Wall = wall_node.instantiate()
	new_wall.get_node("CollisionPolygon2D").polygon = polygon
	new_wall.position = position
	call_deferred("add_sibling", new_wall)

func _on_damage(damage_polygon: CollisionPolygon2D) -> void:
	# offset polygon
	var offset_polygon: PackedVector2Array
	for vert in damage_polygon.polygon:
		offset_polygon.append((vert+damage_polygon.global_position)-wall_shape.global_position)
	
	# do damage
	var new_polygons = Geometry2D.clip_polygons(wall_shape.polygon, offset_polygon)
	wall_shape.set_deferred("polygon", new_polygons[0])
	
	# create new wall parts if there are some
	if new_polygons.size() > 1:
		new_polygons.remove_at(0)
		for new_pol in new_polygons:
			create_new_wall(new_pol)
	#recalculate to check for small parts (later)
