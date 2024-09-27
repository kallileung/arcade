extends Node2D

# Member variables
var direction = Vector2(0.0, 1.0)
const INIT_BALL_SPEED = 250
const PAD_SPEED = 300
var ball_speed = INIT_BALL_SPEED

var score
var lives
var screen_size
var pad_size

func _ready():
	#screen_size = get_viewport_rect().size
	screen_size = get_node("RightWall").position
	pad_size = get_node("paddle").get_texture().get_size()
	score = 0
	lives = 3
	var bricks = get_tree().get_nodes_in_group("brick")
	for brick_node in bricks:
		brick_node.brick_hit.connect(_on_score)
	set_process(true)

func _process(delta):
	var ball_pos = get_node("ball").position
	var pad_pos = get_node("paddle").position
	var paddle_rect = Rect2(pad_pos-0.5*pad_size, pad_size)
	
	# Move paddle
	if (Input.is_action_pressed("left")):
		pad_pos.x -= PAD_SPEED * delta
	if (Input.is_action_pressed("right")):
		pad_pos.x += PAD_SPEED * delta
	get_node("paddle").position = pad_pos
	
	# Move ball
	# check for wall, ceiling collisions
	# check for paddle collision
	# check for brick collisions
	# update ball position
	ball_pos += direction * ball_speed * delta
	# roof
	if (ball_pos.y < 0 and direction.y < 0):
		direction = reverse_y_rand_x(direction)
	# wall
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		direction.x = -direction.x 
	# paddle
	if (paddle_rect.has_point(ball_pos)):
		direction = reverse_y_rand_x(direction)
		# floor
	if (ball_pos.y > screen_size.y and direction.y > 0):
		lives -= 1
		$LivesLabel.text = str(lives)
		if (lives < 0):
			new_game()
		ball_pos = get_node("StartPosition").position
		ball_speed = INIT_BALL_SPEED
		direction = Vector2(0.0, 1.0)
	# brick - handle in call back
	get_node("ball").position = ball_pos
		
func reset_ball_pos():
	get_node("ball").position = get_node("StartPosition").position
	ball_speed = INIT_BALL_SPEED
	direction = Vector2(0.0, 1.0)
	
func reverse_y_rand_x(dir):
	dir.y = -dir.y
	dir.x = randf()*3.0-1
	return Vector2(dir.x, dir.y).normalized()
	
func reverse_x_rand_y(dir):
	dir.x = -dir.x
	dir.y = randf()*3.0-1
	return Vector2(dir.x, dir.y).normalized()
	
func new_game():
	get_tree().reload_current_scene()

func _on_score(value):
	score += value
	direction = reverse_y_rand_x(direction)
	ball_speed *= 1.1
	$ScoreLabel.text = str(score)
