extends CharacterBody2D

@export var speed = 50
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	

func _process(delta):
	if (Input.is_action_pressed("down")):
		velocity.y += 1
	elif (Input.is_action_pressed("up")):
		velocity.y -= 1
	else:
		velocity = Vector2.ZERO
	
	position += velocity * delta * speed
