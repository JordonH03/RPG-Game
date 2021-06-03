extends KinematicBody2D

# Preload
const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const FIREBALL = preload("res://Effects/Fireball.tscn")

# Export
## Movement variables
export var MAX_SPEED = 120
export var ACCELERATION = 500
export var FRICTION = 500

# Onready
## Animation nodes
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
## Collision nodes
onready var fireballSpawn = $HitboxPivot/Hitbox
onready var hurtbox = $Hurtbox

# Enums
## Player Actions
enum {
	MOVE,
	ATTACK
}

# Variables
var stats = PlayerStats
var state = MOVE # Default player action
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var fireball = FIREBALL.instance()

func _ready():
	randomize() # randomizes world code
	animationTree.active = true # Turns animation on
	fireball.knockback_vector = velocity
	stats.connect("no_health", self, "queue_free")
	
func _physics_process(delta):
	# Checks for current animation state
	match state:
		MOVE: move_state(delta)
		ATTACK: attack_state(delta)

# Movement function
func move_state(delta):
	# Calculates the direction of movement based on key input
	# Allows for multi-directional movement
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # reduces the velocity to the smallest unit...1
	if input_vector != Vector2.ZERO:
		# Sets the different animations based on key input
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # moves player to 0,0 by FRICTION val
		
	# Commands player body to stop on collision
	move()
	
	# Checks for ATTACK action and switches animation
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

# Attack function
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	fireball = FIREBALL.instance()
	var spawn = get_tree().current_scene
	spawn.add_child(fireball)
	fireball.position = fireballSpawn.global_position
	fireball.rotation = fireballSpawn.global_rotation
	fireball.travel_vector.x = fireballSpawn.position.x
	fireball.travel_vector.y = fireballSpawn.position.y
	fireball.travel_vector = fireball.travel_vector.normalized()
	fireball.knockback_vector = input_vector
	fireball.velocity = fireball.velocity.move_toward(fireball.travel_vector * MAX_SPEED, ACCELERATION * delta)
	fireball.velocity = move_and_collide(fireball.velocity)

func attack_animation_finished():
	state = MOVE

# General movement function
func move():
	velocity = move_and_slide(velocity)

# Signal Functions

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)


func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
