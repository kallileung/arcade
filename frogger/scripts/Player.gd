extends Area2D

@export var SPEED = 5 # speed of player in pixels/sec.
var screen_size # size of the game window.
var main
var SLIDE_SPEED = 0
var river_yMin = 0



func _ready():
	main = get_node("..")
	screen_size = get_viewport_rect().size
	$AnimationTimer.timeout.connect(stop_animation)
	main.crash.connect(die)
	main.log_on.connect(ride_log)
	main.log_off.connect(hopoff_log)

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	
	if velocity.length() > 0:
		hop(velocity)
	
	if SLIDE_SPEED != 0:
		velocity.x = SLIDE_SPEED
		position += velocity * delta

func hop(velocity):
	velocity = velocity.normalized() * SPEED
	$AnimatedSprite2D.play()
	$AnimationTimer.start()
		
	position += velocity

func stop_animation():
	$AnimatedSprite2D.stop()
	
func die():
	print("CRASH")
	queue_free()
	
func drown():
	print("DROWN")
	queue_free()

func ride_log(xVector):
	print("I'm on!")
	SLIDE_SPEED = xVector
	
func hopoff_log():
	print("I'm off!")
	SLIDE_SPEED = 0

	
