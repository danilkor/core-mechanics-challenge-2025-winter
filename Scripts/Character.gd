extends CharacterBody2D
class_name Character

var max_health = 5
var health = 5
var speed = 110
var size = 5


func print_data() -> void: 
	print("max_health: ", max_health)
	print("health: ", health)
	print("speed: ", speed)
	print("size: ", size)	

func _ready() -> void:
	print("[DEBUG] New Character created: {")
	print_data()
	print("}")
	pass 

func _process(delta: float) -> void:
	pass
	
