extends KinematicBody2D

# ABOUT THIS SCRIPT
# This script is expecting an enemy seeking a player

# This script is expecting the following:
# You have a tilemap with at least one tile with navigation enabled

# You have a level navigation node set to the "LeveLNavigation" group

# You have a destination set to the "Player" group
# You can change the desination group in the inspector if your not going
# to a destination

export(int) var SPEED: int = 40
export var DESTINATION_GROUP = "Player"

# Hide or delete line
onready var line = $Line2D

var path: Array = [] # Contains destination pos
var levelNavigation: Navigation2D = null
var destination: KinematicBody2D = null
var velocity := Vector2.ZERO

func _ready() -> void:
	yield(get_tree(), "idle_frame")
	var tree = get_tree()
	if tree.has_group("LevelNavigation"):
		levelNavigation = tree.get_nodes_in_group("LevelNavigation")[0]
	if tree.has_group("Player"):
		destination = tree.get_nodes_in_group(DESTINATION_GROUP)[0]

func _physics_process(delta: float) -> void:
	if destination and levelNavigation:
#		Its not optimized to generate the path on every physics process
		generate_path()
		navigate(delta)
	move()
	
# Navigates to the destination
func navigate(delta: float):
	if path.size() > 0:
		velocity = global_position.direction_to(path[1]) * SPEED * delta
		
		if global_position == path[0]:
			path.pop_front()
	
# Generates a path to the destination
func generate_path():
	if levelNavigation != null and destination != null:
		path = levelNavigation.get_simple_path(global_position, destination.global_position, false)
		line.points = path

# Moves towards
func move():
	velocity = move_and_slide(velocity)
