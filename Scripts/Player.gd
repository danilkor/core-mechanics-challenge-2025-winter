extends "res://Scripts/Character.gd"

var bullet_node = preload("res://Nodes/Bullet.tscn")
@onready var main_node = get_node("/root/Main")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func _input(event: ):
	# Use is_action_pressed to only accept single taps as input instead of mouse drags.
	if event.is_action_pressed("click"):
		process_mouse_click(event)


func moving_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction.normalized() * speed

func _physics_process(delta):
	moving_input()
	move_and_slide()

func process_mouse_click(event):
	var direction = (get_global_mouse_position()-position).normalized()
	shoot_bullet(direction)
	#get_node("/root/Main/Bullet").rebuild.emit()


#shooting 
func shoot_bullet(direction: Vector2) -> void:
	var bullet = bullet_node.instantiate();
	bullet.my_direction = direction
	bullet.position = position
	main_node.add_child(bullet)
	print("shooting bullet: ")
	print("Direction: ")
	print(direction)
