extends KinematicBody2D

# ABOUT THIS SCRIPT
# You need to have inputs set up as follows
# move_right, move_left, move_up, move_down

export var acceleration = 1000
export var max_speed = 200
export var friction = 1000

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var direction_vector := calculate_direction()
	calculate_velocity(direction_vector, delta, max_speed, friction)
	move()
	

func move() -> void:
	velocity = move_and_slide(velocity)

# Calculates the movement vector, normalizing diagonal directions
func calculate_direction() -> Vector2:
	var vector := Vector2.ZERO
	
	vector.x = Input.get_action_strength("move_right") - Input.get_action_raw_strength("move_left")
	vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if is_moving_diagonally(vector):
		vector = vector.normalized()
	
	return vector

# Calculates and returns the velocity based off of the speed when moving
# velocity based off of friction when stopping
# speed and friction are optional parameters
func calculate_velocity(
		direction: Vector2,  
		delta: float, 
		speed: float, 
		player_friction
	) -> void:
#	var vel = Vector2.ZERO
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, player_friction * delta)
		
	
	
func is_moving_diagonally(vector: Vector2) -> bool:
	var moving_diagonally = false
	
	if vector.x == 1 or vector.x == -1:
		if vector.y == 1 or vector.y == -1:
			moving_diagonally = true
	
	return moving_diagonally
