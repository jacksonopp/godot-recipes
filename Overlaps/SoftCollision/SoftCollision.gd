extends Area2D

#ABOUT THIS SCENE
# Add this scene to a scene to avoid crowding/overlapping

func is_colliding() -> bool:
	var areas := get_overlapping_areas()
	return areas.size() > 0
	
func get_push_vector() -> Vector2:
	var areas := get_overlapping_areas()
	var push_vector := Vector2.ZERO
	if is_colliding():
		var area: Area2D = areas[0]
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector
