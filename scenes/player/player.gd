extends CharacterBody2D

class_name Player

enum PlayerState {IDLE, RUN, JUMP, FALL, HURT}

const FALLEN_OFF: float = 200.0
const GRAVITY: float = 690.0
const RUN_SPEED: float = 130.0
const JUMP_VELOCITY: float = -260.0
const MAX_FALL: float = 400.0
const HURT_JUMP_VELOCITY: float = -130.0

var _state: PlayerState = PlayerState.IDLE

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug_label: Label = $DebugLabel
@onready var shooter: Shooter = $Shooter
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var invincible_player: AnimationPlayer = $InvinciblePlayer
@onready var hurt_timer: Timer = $HurtTimer
@onready var sound: AudioStreamPlayer2D = $Sound

var _invincible: bool = false
var _lives: int = 3

func _ready() -> void:
	call_deferred("late_setup")
	
func late_setup() -> void:
	SignalManager.on_level_start.emit(_lives)

func _physics_process(delta: float) -> void:
	
	fallen_off()
	
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
	get_input()
	move_and_slide()
	update_player_state()
	update_debug_label()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
#input
func shoot() -> void:
	if animated_sprite_2d.flip_h == false:
		shooter.shoot(Vector2.RIGHT)
	else:
		shooter.shoot(Vector2.LEFT)


func get_input() -> void:
	if _state == PlayerState.HURT:
		return
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -RUN_SPEED
		animated_sprite_2d.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x = RUN_SPEED
		animated_sprite_2d.flip_h = false
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump") and is_on_floor() == true:
		velocity.y = JUMP_VELOCITY
		SoundManager.play_clip(sound, SoundManager.SOUND_JUMP)
		
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

#state
func update_player_state() -> void:
	if _state == PlayerState.HURT:
		return
	
	if is_on_floor() == true:
		if velocity.x == 0:
			set_state(PlayerState.IDLE)
		else:
			set_state(PlayerState.RUN)
	else:
		if velocity.y < 0:
			set_state(PlayerState.JUMP)
		else:
			set_state(PlayerState.FALL)

func set_state(new_state: PlayerState) -> void:
	if new_state == _state:
		return
	
	if _state == PlayerState.FALL:
		if new_state == PlayerState.IDLE or new_state == PlayerState.RUN:
			SoundManager.play_clip(sound, SoundManager.SOUND_LANDDING)
		
	_state = new_state
	
	match _state:
		PlayerState.IDLE:
			animated_sprite_2d.play("idle")
		PlayerState.RUN:
			animated_sprite_2d.play("run")
		PlayerState.JUMP:
			animated_sprite_2d.play("jump")
		PlayerState.FALL:
			animated_sprite_2d.play("fall")
		PlayerState.HURT:
			apply_jump_hit()
			

#debug
func update_debug_label() -> void:
	debug_label.text = "floor:%s invincible:%s\n%s\n%.f, %.f\n%d" % [
		is_on_floor(), _invincible,
		PlayerState.keys()[_state],
		velocity.x, velocity.y, _lives
	]

func fallen_off() -> void:
	if position.y < FALLEN_OFF:
		return
	reduce_lives(_lives)

func reduce_lives(reduction: int) -> bool:
	_lives -= reduction
	SignalManager.on_player_hit.emit(_lives)
	if _lives <= 0:
		SignalManager.on_game_over.emit()
		set_physics_process(false)
		animated_sprite_2d.stop()
		invincible_player.stop()
		print("Game Over")
		return false
	return true

func go_invincible() -> void:
	_invincible = true
	invincible_player.play("invincible_flash")
	invincible_timer.start()

func apply_hit() -> void:
	if _invincible == true:
		return
	
	if reduce_lives(1) == false:
		return
	
	SoundManager.play_clip(sound, SoundManager.SOUND_DAMAGE)
	set_state(PlayerState.HURT)
	go_invincible()

func apply_jump_hit() -> void:
	var velocity_hurt_x: float = 0.0
	
	if animated_sprite_2d.flip_h == false:
		velocity_hurt_x = -50.0
	else:
		velocity_hurt_x = 50.0
	velocity = Vector2(velocity_hurt_x, HURT_JUMP_VELOCITY)
	hurt_timer.start()
	animated_sprite_2d.play("hurt")
	
func _on_invincible_timer_timeout() -> void:
	_invincible = false
	invincible_player.stop()

func _on_hit_box_area_entered(area: Area2D) -> void:
	apply_hit()

func _on_hurt_timer_timeout() -> void:
	set_state(PlayerState.IDLE)
