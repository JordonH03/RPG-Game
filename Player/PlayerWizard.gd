extends KinematicBody2D

# Preload
const PLAYER_HURT_SOUND = preload("res://Player/PlayerHurtSound.tscn")
## Fireball preloads
const FIREBALL = preload("res://Effects/Fireball.tscn")
const BLUE_FIREBALL = preload("res://Effects/BlueFireball.tscn")

# Export
## Movement variables
export var MAX_SPEED = 120
export var ACCELERATION = 500
export var ROLL_SPEED = 125
export var FRICTION = 500

# Onready
## Animation nodes
onready var sprite = $Sprite
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
onready var specialAnimationPlayer = $SpecialAnimationPlayer

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
var knockbackVector = Vector2.ZERO
var stats = PlayerStats
## Special Ability variables
var special = false
var cooldown = false
## Fireball variables
var fireball = FIREBALL.instance()

func _ready():
	randomize() # randomizes world code
	animationTree.active = true # Turns animation on
	hitbox.knockbackVector = velocity
	stats.connect("no_health", self, "queue_free")
	# Sets width of special outline to 0
	sprite.get_material().set_shader_param("size", 0.0)
	
func _physics_process(delta):
	# Checks for current animation state
	match state:
		MOVE: move_state(delta)
		ATTACK: attack_state(delta)
		ROLL: roll_state(delta)
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		special = true
		# Sets the outline to a visible width
		sprite.get_material().set_shader_param("size", 0.5)
		specialDuration.start()

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
	
func cooldown_finished():
	specialAnimationPlayer.stop()

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


func _on_SpecialDuration_timeout():
	special = false
	cooldown = true
	specialAnimationPlayer.play("SpecialEnd")
	specialDuration.stop()
	specialCooldown.start()
	print("special end")

func _on_SpecialCooldown_timeout():
	cooldown = false
	specialAnimationPlayer.play("CooldownEnd")
	specialCooldown.stop()
	print("cooldown end")

	
# Wizard specific functions
func spawn_fireball(x, y):
	if special == true:
		fireball = BLUE_FIREBALL.instance()
	else:
		fireball = FIREBALL.instance()
	var spawn = get_tree().current_scene
	spawn.add_child(fireball)
	fireball.position = hitbox.global_position
	fireball.rotation = hitbox.global_rotation
	fireball.knockbackVector = rollVector
	fireball.travelVector.x = x
	fireball.travelVector.y = y
	#print(fireball.travelVector)
	
# Functions called in animation player
func fireball_down():
	spawn_fireball(0, 1)
	
func fireball_left():
	spawn_fireball(-1, 0)
	
func fireball_right():
	spawn_fireball(1, 0)
	
func fireball_up():
	spawn_fireball(0, -1)

