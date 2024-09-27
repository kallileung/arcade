extends Control

# UI utils

func _ready():
	var main_game = get_node("../Game")
	main_game.score_changed.connect(update_score_display)

func update_score_display(new_score):
	$ScoreDisplay/HBoxContainer/ScoreVal.text = str(new_score)

func show_overlay():
	$GameOverScreen/CanvasLayer.visible = true
	
func hide_overlay():
	$GameOverScreen/CanvasLayer.visible = false
