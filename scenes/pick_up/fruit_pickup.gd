extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const GRAVITY: float = 500
const JUMP: float = -120

var start_y: float = 0
var speed_y: float = JUMP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	start_y = position.y
	
	var ln: Array[String] = []
	for anim in animated_sprite_2d.sprite_frames.get_animation_names():
		ln.push_back(anim)
	animated_sprite_2d.animation = ln.pick_random()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += speed_y * delta
	speed_y += GRAVITY * delta
	
	if position.y > start_y:
		set_process(false)

func kill_me() -> void:
	hide()
	queue_free()

func _on_life_timer_timeout() -> void:
	kill_me()
