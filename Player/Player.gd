extends KinematicBody2D

class_name Player

# Preload
const PLAYER_HURT_SOUND = preload("res://Player/PlayerHurtSound.tscn")

# Export
## Movement variables
export var MAX_SPEED = 120
export var ACCELERATION = 500
export var ROLL_SPEED = 125
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
onready var audioStreamPlayer = $AudioStreamPlayer

# Enums
## Player Actions
enum {
	MOVE,
	ATTACK,
	ROLL
}

# Variables
var state = MOVE # Default player action
var velocity = Vector2.ZERO
var rollVector = Vector2.ZERO
var stats = PlayerStats
## Special Ability variables
var special = false
var cooldown = false


func _ready():
	randomize() # randomizes world code
	animationTree.active = true # Turns animation on
	hitbox.knockbackVector = rollVector
	stats.connect("no_health", self, "queue_free")
	
func _physics_process(delta):
	# Checks for current animation state
	match state:
		MOVE: move_state(delta)
		ATTACK: attack_state(delta)
		ROLL: roll_state(delta)

# Movement function
func move_state(delta):
	var inputVector = Vector2.ZERO
	# Calculates the direction of movement based on key input
	# Allows for multi-directional movement
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized() # reduces the velocity to the smallest unit...1
	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		hitbox.knockbackVector = inputVector
		# Sets the different animations based on key input
		var animations = ["Idle", "Run", "Attack", "Roll"]
		for animation in animations:
			animationTree.set("parameters/" + animation + "/blend_position", inputVector)
		animationState.travel("Run")
		velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta) # moves player to 0,0 by FRICTION val
		
	# Commands player body to stop on collision
	move()
	
	# Checks for ATTACK action and switches animation
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		state = ROLL

# Attack function
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE
	
func roll_state(_delta):
	velocity = rollVector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func roll_animation_finished():
	state = MOVE

# General movement function
func move():
	velocity = move_and_slide(velocity)
	

# Signal Functions

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	var playerHurtSound = PLAYER_HURT_SOUND.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

