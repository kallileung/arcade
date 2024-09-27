extends Node3D
 
@export var fruits : Array[PackedScene]
var score = 0
var spawnTimer
var camera
var topCamera
var isBirdEyeView
var curr_fruit
var fruitID

# signals
signal score_changed

# Main game
# Fruit spawn component w/ RNG (Timer after drop)
# Send score updates to UI for update
# Check for fruit collisions (disappear/merge)
# Check for overfill (Game over with timer)
# Show game over screen with score
# Save high score to user file
# Reset state for new game
# TODO: Shake Bar progress & physics logic?
# TODO - polish: soundFX & visualFX

# Gameplay mechanics:
# - check for user input
# - handle camera movement
# - handle drop fruit

func _ready():
	spawnTimer = $SpawnTimer
	camera = get_node("PlayerPOV")
	topCamera = get_node("BirdsEyeView")
	isBirdEyeView = false
	fruitID = 0
	$SpawnTimer.timeout.connect(spawn_fruit)

func _physics_process(delta):
	# handle camera movement
	if Input.is_action_just_pressed("space"):
		toggle_view()
	elif Input.is_action_pressed("left_rotate"):
		rotate_camera(-1 * delta)
	elif Input.is_action_pressed("right_rotate"):
		rotate_camera(1 * delta)
	
	# handle moving drop position
	if curr_fruit != null:
		if Input.is_action_pressed("up"):
			curr_fruit.position.z -= 1
		elif Input.is_action_pressed("down"):
			curr_fruit.position.z += 1
		elif Input.is_action_pressed("left"):
			curr_fruit.position.x -= 1
		elif Input.is_action_pressed("right"):
			curr_fruit.position.x += 1
	
		# handle dropping fruit 
		if Input.is_action_just_pressed("drop"):
			release_current_fruit()
	
	var fruitsInContainer = get_tree().get_nodes_in_group("fruit")
	for fruit in fruitsInContainer:
		if (fruit != curr_fruit):
			fruit.validate_overfill(get_node("Upperbound").position.y)

# Game state management
func game_over():
	# show game over score stat screen
	save_score()
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func quit():
	get_tree().quit()

func back():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	
func new_game():
	score = 0
	
func save_score():
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_64(score)
	file.close()

func load_score():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var content = file.get_64()
	file.close()
	return content

# Game play functions
func spawn_fruit():
	# pick random fruit from fruits array
	var idxMax = fruits.size() / 3
	var rand_index = randi() % idxMax
	var fruit_scene = fruits[rand_index]
	
	# instantiate, set pos to SpawnPos
	curr_fruit = fruit_scene.instantiate()
	curr_fruit.position = $SpawnPos.position
	curr_fruit.gravity_scale = 0
	# add child to scene
	add_child(curr_fruit)
	fruitID += 1
	curr_fruit.set_ID(fruitID)
	curr_fruit.spawn.connect(spawn_merged_fruit)
	curr_fruit.overfill.connect(game_over)
	
func spawn_merged_fruit(type, x, y, z, points):
	# increment score, emit signal
	score += points
	score_changed.emit(score)
	ScoreComponent.set_score(score)
	if (type < fruits.size() - 1):
		var fruit_scene = fruits[type]
		var merged_fruit = fruit_scene.instantiate()
		merged_fruit.position.x = x
		merged_fruit.position.y = y
		merged_fruit.position.z = z
		add_child(merged_fruit)
		fruitID += 1
		merged_fruit.set_ID(fruitID)
		merged_fruit.spawn.connect(spawn_merged_fruit)
		merged_fruit.overfill.connect(game_over)
	get_tree().call_group("to_delete", "queue_free")
	
func release_current_fruit():
	# drop fruit
	curr_fruit.gravity_scale = 1
	$SpawnTimer.start()
	curr_fruit = null
	get_tree().call_group("fruit", "validate_in_bounds")
	# play sound fx
	$SoundFX.playing = true

# Camera navigation
func rotate_camera(dir):
	#  rotate camera around spring arm in either CW or CCW direction
	if !isBirdEyeView:
		var camera_origin = get_node("PlayerPOV")
		camera_origin.rotation.y += dir
	
func toggle_view():
	# switch between bird's eye view and perspective camera
	isBirdEyeView = !isBirdEyeView
	# set current active camera
	if isBirdEyeView:
		get_node("FillLine").hide()
		topCamera.set_current(true)
	else:
		get_node("FillLine").show()
		$PlayerPOV/Camera3D.set_current(true)
		


