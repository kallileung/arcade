extends Node2D

signal log_on
signal log_off
signal crash
@export var player_scene : PackedScene
var lives = 3
var score = 0

func ready():
	var death_fx = get_node("DeathFx")
	death_fx.finished.connect(cleanup_blood)

func game_over():
	get_node("../GameSummary").show()
	var score_label = get_node("../GameSummary/VBoxContainer/HBoxContainer/ScoreVal")
	score_label.text = str(score)
	
func cleanup_blood():
	var death_fx = get_node("DeathFx")
	death_fx.hide()
	
func death_by_drowning():
	print("FROG drowned")
	lives -= 1
	crash.emit()
	if (lives <= 0):
		game_over()
	update_player_lives_label(lives)
	respawn_player()

func _on_player_body_entered(body):
	if body.is_in_group("car"):
		var player_pos = body.position
		crash.emit()
		lives -= 1
		if (lives <= 0):
			game_over()
		update_player_lives_label(lives)
		var death_fx = get_node("DeathFx")
		death_fx.position = player_pos
		death_fx.show()
		death_fx.emitting = true
		respawn_player()
	elif body.is_in_group("log"):
		log_on.emit(body.velocity.x)

func _on_player_body_exited(body):
	if body.is_in_group("log"):
		log_off.emit()
	# CHECK IF PLAYER LANDS IN RIVER AND EMIT SWIM SIGNAL

func update_player_lives_label(lives_left):
	var label = get_node("../HUD/LivesLabel")
	label.text = str(lives_left)
	
func update_score_label(new_score):
	var label = get_node("../HUD/ScoreLabel")
	label.text = str(new_score)

func respawn_player():
	var pos = $StartPosition.position
	var player = player_scene.instantiate()
	player.position = pos
	player.body_entered.connect(_on_player_body_entered)
	player.body_exited.connect(_on_player_body_exited)
	call_deferred("add_child",player)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_restart_button_pressed():
	lives = 3
	score = 0
	update_player_lives_label(lives)
	update_score_label(score)
	get_node("../GameSummary").hide()

func _on_goal_area_entered(_area):
	print("GOAL!")
	score += 100
	update_score_label(score)
	crash.emit()
	respawn_player()
