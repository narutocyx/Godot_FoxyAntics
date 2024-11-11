extends CharacterBody2D

class_name Player

const GRAVITY: float = 100.0

@export var SPEED: float = 120.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on_floor() == false:
		velocity.y += GRAVITY * delta
	Get_Input()
	move_and_slide()

func Get_Input() -> void:
	velocity.x = 0
	#animated_sprite_2d.play("idle")	
	if Input.is_action_pressed("move_left") == true:
		velocity.x = -SPEED
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
	elif Input.is_action_pressed("move_right") == true:
		velocity.x = SPEED
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("run")
