extends Control

var enemy_score = 0
var player_score = 0

# await signal & update labels accordingly
func _ready():
	var main = get_node("..")
	main.enemy_scored.connect(increment_enemy_score)
	main.player_scored.connect(increment_player_score)

func increment_player_score():
	player_score += 1
	update_display($HBoxContainer/PlayerScore, player_score)
	
func increment_enemy_score():
	enemy_score += 1
	update_display($HBoxContainer/EnemyScore, enemy_score)

func update_display(label, score):
	label.text = str(score)

func reset_display():
	enemy_score = 0
	player_score = 0
	update_display($HBoxContainer/EnemyScore, enemy_score)
	update_display($HBoxContainer/PlayerScore, player_score)
