extends KinematicBody2D

# Preload
const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
## Fireball preloads
const FIREBALL = preload("res://Effects/Fireball.tscn")
const BlueFireball = preload("res://Effects/BlueFireball.tscn")

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
onready var hitbox = $HitboxPivot/Hitbox
onready var hurtbox = $Hurtbox
## Special ability nodes
onready var specialDuration = $SpecialDuration
onready var specialCooldown = $SpecialCooldown

# Enums
## Player Actions
enum {
	MOVE,
	ATTACK
}

# Variables
var state = MOVE # Default player action
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var stats = PlayerStats
## Special Ability variables
var special = false
var cooldown = false
## Fireball variables
var fireball = FIREBALL.instance()

func _ready():
	randomize() # randomizes world code
	animationTree.active = true # Turns animation on
	hitbox.knockback_vector = velocity
	stats.connect("no_health", self, "queue_free")
	
func _physics_process(delta):
	# Checks for current animation state
	match state:
		MOVE: move_state(delta)
		ATTACK: attack_state(delta)
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		special = true
		specialDuration.start()

# Movement function
func move_state(delta):
	# Calculates the direction of movement based on key input
	# Allows for multi-directional movement
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # reduces the velocity to the smallest unit...1
	if input_vector != Vector2.ZERO:
		hitbox.knockback_vector = input_vector
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
		
	# Return input_vector for travel_vector
	return input_vector

# Attack function
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

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


func _on_SpecialDuration_timeout():
	special = false
	cooldown = true
	specialCooldown.start()

func _on_SpecialCooldown_timeout():
	cooldown = false

	
# Wizard specific functions
func spawn_fireball(x, y):
	if special == true:
		fireball = BlueFireball.instance()
	else:
		fireball = FIREBALL.instance()
	var spawn = get_tree().current_scene
	spawn.add_child(fireball)
	fireball.position = hitbox.global_position
	fireball.rotation = hitbox.global_rotation
	fireball.knockback_vector = input_vector
	fireball.travel_vector.x = x
	fireball.travel_vector.y = y
	print(fireball.travel_vector)
	
# Functions called in animation player
func fireball_down():
	spawn_fireball(0, 1)
	
func fireball_left():
	spawn_fireball(-1, 0)
	
func fireball_right():
	spawn_fireball(1, 0)
	
func fireball_up():
	spawn_fireball(0, -1)

