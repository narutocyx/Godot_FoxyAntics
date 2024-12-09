extends Camera2D

@export var shake_amount: float = 3.0
@onready var shake_timer: Timer = $ShakeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	SignalManager.on_player_hit.connect(on_player_hit)
	SignalManager.on_game_over.connect(on_game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset = get_rand_offset()
	
func on_player_hit(lives: int) -> void:
	set_process(true)
	shake_timer.start()
	
func on_game_over() -> void:
	reset_camera()

func get_rand_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(-shake_amount, shake_amount)
		)

func reset_camera() -> void:
	set_process(false)
	offset = Vector2.ZERO

func _on_shake_timer_timeout() -> void:
	reset_camera()
