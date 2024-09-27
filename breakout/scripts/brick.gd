extends Sprite2D
@export var points = 10
signal brick_hit

func _on_area_2d_area_entered(area):
	if area.is_in_group("ball"):
		brick_hit.emit(points)
		queue_free()
