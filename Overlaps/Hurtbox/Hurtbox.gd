extends Area2D

# This is a hurbox with an invicibility timer

export(float) var invincibility_time = 0.5

signal invincibility_started
signal invincibility_ended

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

var invincible = false setget set_invincible

# Setter function for invincibility, emits when value changes
func set_invincible(value: bool) -> void:
	invincible = value
	emit_signal("invincibility_started" if invincible else "invincibility_ended")
	
# Starts the invincibility timer
func start_invincibility(duration: float = invincibility_time) -> void:
	self.invincible = true
	timer.start(duration)

# Sets invincibility when timer ends
func _on_Timer_timeout() -> void:
	self.invincible = false

# disables hurbox collision when invincibility starts 
func _on_Hurtbox_invincibility_started() -> void:
	collisionShape.set_deferred("disabled", true)

# enables hurtbox collision when invincibility ends
func _on_Hurtbox_invincibility_ended() -> void:
	collisionShape.disabled = false
