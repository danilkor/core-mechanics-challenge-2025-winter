extends Node2D

var my_direction: Vector2
var speed: int = 150
var time_to_live: float = 3 # in seconds
var wall_destruction_shape_resolution = 12 # amount of verticies
var wall_destruction_shape_size = 3


@onready var timer: Timer = $Timer

@onready var wall_destruction_area = $WallDestruction
@onready var wall_destruction_shape = $WallDestruction/DestructionShape


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
	wall_destruction_shape.polygon = []
	var new_polygon: PackedVector2Array = []
	for i in range(0,wall_destruction_shape_resolution):
		var x = sin(((2*PI)/wall_destruction_shape_resolution)*i)
		var y = -cos(((2*PI)/wall_destruction_shape_resolution)*i)
		
		new_polygon.append(((Vector2(x,y)+Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1)))*randf_range(0.9,1.5))*10)
	wall_destruction_shape.polygon = new_polygon
	
# time to live
func _on_timer_timeout():
	explode()

# TODO: should deal damage to the enemies nearby, and destroy walls 
func explode() -> void: 
	get_node(".").queue_free()
