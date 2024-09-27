extends CharacterBody2D
const SPEED = 50 # paddle speed in pixels per sec
# AI: enemy paddle will try to follow y position of ball
func _process(delta):
	if (Input.is_action_pressed("down_wasd")):
		velocity.y += 1
	elif (Input.is_action_pressed("up_wasd")):
		velocity.y -= 1
	else:
		velocity = Vector2.ZERO
	
	position += velocity * delta * SPEED
