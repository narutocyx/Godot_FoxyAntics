extends PathFollow2D

@export var speed: float = 0.05
@export var spin_speed: float = 400.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += speed * delta
	rotation_degrees += spin_speed * delta
	
	if progress_ratio == 1 or progress_ratio == 0:
		speed = -speed
		spin_speed = -spin_speed
