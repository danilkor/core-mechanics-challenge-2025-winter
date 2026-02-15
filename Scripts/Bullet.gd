extends Node2D

var my_direction: Vector2

# ====== SETTINGS ======
@export_category("Settings")
var speed: int = 150
var time_to_live: float = 180 # in seconds
var wall_destruction_shape_resolution = 16 # amount of verticies
var wall_destruction_shape_size = 5

# ======= INNER PARTS ======
@onready var timer: Timer = $Timer
@onready var wall_destruction_area = $WallDestruction
@onready var wall_destruction_shape = $WallDestruction/DestructionShape


# ====== SIGNALS ======
signal rebuild 


# ==== EXTRA ======
const wall_class = preload("res://Scripts/Wall.gd")


func _ready() -> void:
	timer.wait_time = time_to_live
	timer.start()
	generate_wall_destruction_shape()
	
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position += my_direction*speed*delta

#initiating
func generate_wall_destruction_shape() -> void:
	#clean starting polygon (if i use empty one in editor it gives an error
	wall_destruction_shape.polygon = []
	
	# generate new random bullet shape
	var new_polygon: PackedVector2Array = []
	for i in range(0,wall_destruction_shape_resolution):
		var angle = (2.0 * PI / wall_destruction_shape_resolution) * i
		var x = sin(angle)
		var y = -cos(angle)
		new_polygon.append(
			((Vector2(x,y)+Vector2(randf_range(-1, 1), randf_range(-1, 1)))*randf_range(0.9,1.5))
			*wall_destruction_shape_size)
		create_circle(new_polygon.get(new_polygon.size()-1), 0.1)
		
	# reorder vertices to remove overlapping (sort by angle to center)
#	
	var center := Vector2.ZERO
	for vert in new_polygon:
		center += vert
	center /= new_polygon.size();
	create_circle(center, 10)
	
	new_polygon = Geometry2D.offset_polygon(new_polygon, 15)[0]
	
	wall_destruction_shape.polygon = new_polygon
	
# time to live
func _on_timer_timeout():
	explode()

# TODO: should deal damage to the enemies nearby, and destroy walls 
func explode() -> void: 
	# find all colliding walls
	var walls = wall_destruction_area.get_overlapping_bodies()	
	for wall in walls:
		if wall is wall_class:
			wall.damage_wall.emit(wall_destruction_shape)
			pass
	get_node(".").queue_free()

func _on_touch(body: Node2D) -> void: 
	explode()
	
# temporary here for debugging purposes
# TODO move to external drawing library 	
func create_circle(pos: Vector2, radius: float):
	var circle = Polygon2D.new()
	circle.position = pos
	circle.color = Color.WHITE

	var new_polygon: PackedVector2Array = []
	var resolution := 32
	var size := radius   # use given radius

	for i in range(resolution):
		var angle = (2.0 * PI / resolution) * i
		var x = sin(angle)
		var y = -cos(angle)
		new_polygon.append(Vector2(x, y))

	circle.polygon = new_polygon
	add_child(circle)
	var timer := Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(func():
		circle.queue_free()
	)

	circle.add_child(timer)
	timer.start()
