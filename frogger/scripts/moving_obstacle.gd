extends CharacterBody2D

var screen_size
const PADDING = 100
@export var xDir = 1
@export var speed = 100

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(_delta):
	velocity = Vector2(xDir * speed, 0.0)
	
	if velocity.x > 0 and global_position.x > screen_size.x + PADDING / 2.0:
		global_position.x -= screen_size.x + PADDING
	elif velocity.x < 0 and global_position.x < -PADDING:
		global_position.x += screen_size.x + PADDING
		
	var _v = move_and_slide()
