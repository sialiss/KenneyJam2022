extends Area2D

func _physics_process(delta):
	if get_overlapping_areas().size() + get_overlapping_bodies().size():
		queue_free()
	set_physics_process(false)
