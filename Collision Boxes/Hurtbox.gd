extends Area2D

# Preload
const HitEffect = preload("res://Effects/HitEffect.tscn")

# Onready
onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func create_hit_effect():
	var effect = HitEffect.instance()         # Create instance of effect scene
	var main = get_tree().current_scene       # Get access to current scene
	main.add_child(effect)                    # Add effect to current scene
	effect.global_position = global_position  # Set effect position

# Signal Functions

func _on_Timer_timeout():
	self.invincible = false

func _on_Hurtbox_invincibility_started():
	collisionShape.set_deferred("disabled", true)
	
func _on_Hurtbox_invincibility_ended():
	collisionShape.set_deferred("disabled", false)
