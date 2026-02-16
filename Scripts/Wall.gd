extends StaticBody2D
class_name Wall
@onready var wall_shape: CollisionPolygon2D = $CollisionPolygon2D
@onready var wall_texture_polygon: Polygon2D = $TexturePolygon2D
signal damage_wall(damage_polygon: CollisionPolygon2D)
signal wall_changed(wall_polygon: PackedVector2Array)
var wall_node = preload("res://Nodes/Wall.tscn")
var navigation_region: NavigationRegion2D
@export var min_area = 150
var wall_obstacle: NavigationObstacle2D
var main_navigation_region: NavigationRegion2D

func _ready() -> void:
	area_check()
	
	damage_wall.connect(_on_damage)
	wall_changed.connect(change_texture)
	wall_changed.connect(change_obstacle)
	
	main_navigation_region = get_node("/root/Main/NavigationRegion2D")
	
	#create obstacle
	wall_obstacle = NavigationObstacle2D.new()
	wall_obstacle.position = position
	wall_obstacle.affect_navigation_mesh = true
	main_navigation_region.add_child(wall_obstacle)
	emit_signal.call_deferred("wall_changed")
	

func create_new_wall(polygon: PackedVector2Array):
	var new_wall: Wall = wall_node.instantiate()
	new_wall.get_node("CollisionPolygon2D").polygon = polygon
	new_wall.position = position
	call_deferred("add_sibling", new_wall)

func area_check():
	var area = CustomGeometry2D.calculate_area(wall_shape.polygon)
	print(area)
	if area < min_area:
		if wall_obstacle:
			wall_obstacle.queue_free()
		queue_free()

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
			
	# check if the wall is too small now
	call_deferred("area_check")
	emit_signal.call_deferred("wall_changed")
	

func change_texture():
	wall_texture_polygon.polygon = wall_shape.polygon

func change_obstacle():
	wall_obstacle.vertices = wall_shape.polygon
	if not main_navigation_region.is_baking():
		main_navigation_region.bake_navigation_polygon()
		
		
