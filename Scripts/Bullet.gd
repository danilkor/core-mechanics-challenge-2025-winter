extends Node2D

var my_direction: Vector2
var speed: int = 150
var time_to_live: float = 180 # in seconds
var wall_destruction_shape_resolution = 16 # amount of verticies
var wall_destruction_shape_size = 5


@onready var timer: Timer = $Timer

@onready var wall_destruction_area = $WallDestruction
@onready var wall_destruction_shape = $WallDestruction/DestructionShape

signal rebuild 

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
			((Vector2(x,y)+Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1)))*randf_range(0.9,1.5))
			*wall_destruction_shape_size)
		
	# reorder vertices to remove overlapping (sort by angle to center)
	
	var center := Vector2.ZERO
	for vert in new_polygon:
		center += vert
	center /= new_polygon.size();
	create_circle(center, 10)
	
	
	
	wall_destruction_shape.polygon = new_polygon
	print("Built")
	print(wall_destruction_shape.polygon)
	
# time to live
func _on_timer_timeout():
	explode()

# TODO: should deal damage to the enemies nearby, and destroy walls 
func explode() -> void: 
	get_node(".").queue_free()
	
	
	
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
	timer.wait_time = 10.0
	timer.one_shot = true
	timer.timeout.connect(func():
		circle.queue_free()
	)

	circle.add_child(timer)
	timer.start()
