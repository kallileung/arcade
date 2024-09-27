extends Node

@export var type = 0
@export var points = 2
@export var ID = -1
signal spawn
signal warning
signal overfill
var isWarning = false
var warningTimer = null
const FLOOR_BOUNDARY = -13.5
var heightLimit = 0

func _ready():
	self.body_entered.connect(on_collide_merge)
	warningTimer = Timer.new()
	warningTimer.wait_time = 5.0
	warningTimer.one_shot = true
	warningTimer.timeout.connect(validate_gameover)
	add_child(warningTimer)
	
	
func set_ID(num):
	ID = num

func on_collide_merge(body):
	if (body.is_in_group("fruit") and body.type == type and body.ID < ID):
		# merge
		# average positions
		var next_type = type+1
		var scoredPts = points
		var pos_x = (self.position.x + body.position.x)/2.0
		var pos_y = (self.position.y + body.position.y)/2.0
		var pos_z = (self.position.z + body.position.z)/2.0
		# emit signal
		# TODO: may need to add delay to spawn for effects
		# mark fruit pair for deletion
		self.add_to_group("to_delete")
		body.add_to_group("to_delete")
		spawn.emit(next_type, pos_x, pos_y, pos_z, scoredPts)

func validate_in_bounds():
	if (self.position.y < FLOOR_BOUNDARY):
		queue_free()
		
func validate_overfill(maxHeight):
	heightLimit = maxHeight
	if (self.position.y > maxHeight):
		if (isWarning):
			return
		warning.emit(1)
		isWarning = true
		warningTimer.start()
	else:
		isWarning = false
		warning.emit(0)
		warningTimer.stop()
		
func validate_gameover():
	if (self.position.y > heightLimit):
		overfill.emit()
	else:
		warning.emit(0)
		isWarning = false
		warningTimer.stop()
