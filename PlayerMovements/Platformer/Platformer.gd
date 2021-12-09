extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP

export var speed := 300.0
export var jump_force := 1000.0
export var gravity := 3000.0

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and velocity.y < 0.0
	var direction := get_direction()
	
	velocity = calculate_move_velocity(velocity, direction, speed, jump_force, is_jump_interrupted)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: float,
	jump_force: float,
	is_jump_interrupted: bool
) -> Vector2:
	var out_v := linear_velocity
	out_v.x = speed * direction.x
	out_v.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1:
		out_v.y = jump_force * direction.y
	
	if is_jump_interrupted:
		out_v.y = 0.0
		
	return out_v
