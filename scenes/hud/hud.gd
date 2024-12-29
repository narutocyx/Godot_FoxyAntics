extends Control

@onready var score_label: Label = $MC/HB/ScoreLabel
@onready var hb_hearts: HBoxContainer = $MC/HB/HBHearts
@onready var color_rect: ColorRect = $ColorRect
@onready var vb_level_complete: VBoxContainer = $ColorRect/VBLevelComplete
@onready var vb_game_over: VBoxContainer = $ColorRect/VBGameOver

var _hearts: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_score_updated(ScoreManager.get_score())
	_hearts = hb_hearts.get_children()
	SignalManager.on_player_hit.connect(on_player_hit)
	SignalManager.on_level_start.connect(on_player_hit)
	SignalManager.on_game_over.connect(on_game_over)
	SignalManager.on_score_updated.connect(on_score_updated)
 

func on_player_hit(lives: int) -> void:
	for life in range(_hearts.size()):
		if lives > life:
			_hearts[life].visible = true
		else:
			_hearts[life].visible = false

func show_hud() -> void:
	color_rect.show()

func on_game_over() -> void:
	show_hud()
	vb_game_over.show()
	
func on_score_updated(score: int) -> void:
	score_label.text = "%05d" % score
