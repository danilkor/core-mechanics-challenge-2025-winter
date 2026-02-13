extends StaticBody2D

@onready var polygon = $CollisionPolygon2D
func _ready() -> void:
	print(polygon.polygon)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
