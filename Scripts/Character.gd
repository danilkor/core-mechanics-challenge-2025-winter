extends CharacterBody2D
class_name Character


@export_category("Character Stats")
var max_health = 5
var health = 5
var speed = 110
var size = 5


# ====== SIGNALS ======
signal damaged(damage: int)
signal died

# ====== Shooting ======
var bullet_node = preload("res://Nodes/Bullet.tscn")
@onready var main_node = get_node("/root/Main")

# ======
var base: Node

func print_data() -> void: 
	print("max_health: ", max_health)
	print("health: ", health)
	print("speed: ", speed)
	print("size: ", size)	

func _ready() -> void:
	print("[DEBUG] New Character created: {")
	print_data()
	print("}")
	
	base = main_node.find_child("Base")
	pass 

func _process(delta: float) -> void:
	pass
	
# Should be called by bullet 
func damage() -> void:
	var damage_amount = 0
	# TODO 
	damaged.emit(damage_amount)
	
	
#shooting 
func shoot_bullet(direction: Vector2, friendly: bool) -> void:
	var bullet = bullet_node.instantiate()
	bullet.my_direction = direction
	bullet.position = position
	bullet.friendly = friendly
	main_node.add_child(bullet)
	print("shooting bullet: ")
	print("Direction: ")
	print(direction)
	
