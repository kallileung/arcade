extends Node2D

@export var obstacle_scene : PackedScene
var timer = null
@export var minSpawnTime = 0.8
@export var maxSpawnTime = 1.2
@export var xDirection = 1
@export var xForce = 30

func _ready():
	timer = $SpawnTimer
	timer.timeout.connect(spawn)

func spawn():
	var obstacle = obstacle_scene.instantiate()
	obstacle.position = position
	obstacle.get_child(0).constant_force.x = xDirection * xForce
	add_child(obstacle)
	timer.wait_time = minSpawnTime + randf()*(maxSpawnTime - minSpawnTime)
	
