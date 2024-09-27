extends RigidBody2D

var direction = Vector2(1.0, 0.0)

const BALL_SPEED = 500

func _ready():
	add_to_group("puck")
	linear_velocity = direction * BALL_SPEED

func init_going_left():
	linear_velocity = direction * BALL_SPEED * -1

func init_going_right():
	linear_velocity = direction * BALL_SPEED
	
func reverse_y():
	linear_velocity.y = -linear_velocity.y * BALL_SPEED

func reverse_x():
	linear_velocity.x = -linear_velocity.x * BALL_SPEED

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("ball hit paddle")
		reverse_x()
	elif body.is_in_group("wall"):
		print("ball hit wall")
		reverse_y()
		
