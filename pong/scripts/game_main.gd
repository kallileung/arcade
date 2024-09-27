extends Node

signal enemy_scored
signal player_scored
@export var ball_scene: PackedScene
var ball

func _ready():
	spawn_ball()


func _on_left_goal_area_entered(area):
	if area.is_in_group("projectile"):
		player_scored.emit()
		play_next_point(-1)

func _on_right_goal_area_entered(area):
	if area.is_in_group("projectile"):
		enemy_scored.emit()
		play_next_point(1)

func play_next_point(direction):
	ball.queue_free()
	spawn_ball()
	
	if (direction == -1):
		get_tree().call_group("puck", "init_going_left")
	else:
		get_tree().call_group("puck", "init_going_right")

func new_game():
	pass

func spawn_ball():
	ball = ball_scene.instantiate()
	var ball_spawn_location = get_node("StartPosition")
	ball.position = ball_spawn_location.position
	call_deferred("add_child", ball)
