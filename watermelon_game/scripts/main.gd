extends Control
var finalScore = 0

func _ready():
	finalScore = ScoreComponent.get_score()
	update_score(finalScore)

func quit():
	get_tree().quit()

func back():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	
func new_game():
	get_tree().change_scene_to_file("res://scenes/suika.tscn")

func update_score(score):
	$VBoxContainer/HBoxContainer/ScoreVal.text = str(score)
