extends EnemyBase

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer

const JUMP_MIN_TIME: float = 2.0
const JUMP_MAX_TIME: float = 4.0

const JUMP_VELOCITY_X: float = 100
const JUMP_VELOCITY_Y: float = 150

const JUMP_VELOCTIY_R: Vector2 = Vector2(JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)
const JUMP_VELOCITY_L: Vector2 = Vector2(-JUMP_VELOCITY_X, -JUMP_VELOCITY_Y)

var _can_jump: bool = true
var _seen_player: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_on_floor() == false:
		velocity.y += _gravity * delta
	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")
		flip_me()
	
	apply_jump()
	move_and_slide()
	

func apply_jump() -> void:
	if is_on_floor() == false:
		return
	
	if _seen_player == false or _can_jump == false:
		return
	
	if animated_sprite_2d.flip_h == false:
		velocity = JUMP_VELOCITY_L
	else:
		velocity = JUMP_VELOCTIY_R
	
	_can_jump = false
	
	animated_sprite_2d.play("jump")
	start_timer()
	
func start_timer() -> void:
	jump_timer.wait_time = randf_range(JUMP_MIN_TIME, JUMP_MAX_TIME)
	jump_timer.start()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("see player!")
	_seen_player = true

func _on_jump_timer_timeout() -> void:
	_can_jump = true

func flip_me() -> void:
	if _player_ref.global_position.x > global_position.x and animated_sprite_2d.flip_h == false:
		animated_sprite_2d.flip_h = true
	if _player_ref.global_position.x < global_position.x and animated_sprite_2d.flip_h == true:
		animated_sprite_2d.flip_h = false
