extends CharacterBody2D

class_name Player

enum PlayerState { IDLE, RUN, JUMP, FALL, HURT }

const GRAVITY: float = 690.0
const RUN_SPEED: float =120.0
const MAX_FALL: float =400
const JUMP_VELOCITY: float = -260.0

var _state: PlayerState = PlayerState.IDLE

@export var SPEED: float = 120.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var debug_label: Label = $DebugLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
	
	get_input()
	move_and_slide()
	calculate_states()
	update_debug_label()

func get_input() -> void:
		
	if Input.is_action_pressed("move_left") == true:
		velocity.x = -RUN_SPEED
		animated_sprite_2d.flip_h = true
	elif Input.is_action_pressed("move_right") == true:
		velocity.x = RUN_SPEED
		animated_sprite_2d.flip_h = false
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("jump") == true and is_on_floor() == true:
		velocity.y = JUMP_VELOCITY
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)

#states
func calculate_states() -> void:
	
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
	_state = new_state
	
	match _state:
		PlayerState.IDLE:
			animated_sprite_2d.play("idle")
		PlayerState.JUMP:
			animated_sprite_2d.play("jump")
		PlayerState.RUN:
			animated_sprite_2d.play("run")
		PlayerState.FALL:
			animated_sprite_2d.play("fall")
		
#debug
func update_debug_label() -> void:
	debug_label.text = "floor:%s\n%s\n%.0f,%.0f" % [
		is_on_floor(),
		PlayerState.keys()[_state],
		velocity.x, velocity.y]
