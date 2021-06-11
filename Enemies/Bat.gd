extends KinematicBody2D

# Preloads
const ENEMY_DEATH_EFFECT = preload("res://Effects/EnemyDeathEffect.tscn") # Preloads animation scene for later use

# Exports
export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_RANGE = 4

# Onready
onready var stats = $Stats # Acesses Stats node properties
## Collision/Detection
onready var playerDetectionArea = $PlayerDetectionArea
onready var hurtbox = $StaticBody2D/Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
## Animation
onready var sprite = $BodySprite
onready var animationPlayer = $AnimationPlayer

# Enums
## Bat actions
enum {
	IDLE,
	WANDER,
	CHASE	
}

# Variables
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO # Initializes knockback

func _ready():
	# Sets enemies to either sit still or wander around on load
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	# The enemy is knocked back when hit
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	# Check current state
	match state:
		IDLE: 
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				randomize_wander_state()
				
		WANDER:
			seek_player() # While wandering keep detecting for player
			# Move to a random point within range
			if wanderController.get_time_left() == 0:
				randomize_wander_state()
				
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_RANGE:
				randomize_wander_state()
				
		CHASE:
			var player = playerDetectionArea.player
			# While enemy can detect player, move towards it
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			
	if softCollision.is_colliding():
					velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
		
func seek_player():
	if playerDetectionArea.can_see_player():
		state = CHASE
		
func pick_random_state(stateList):
	# Randomize the order of given states
	stateList.shuffle()
	# Return/Choose the first state
	return stateList.pop_front()
	
func accelerate_towards_point(point, delta):
	# Move
	var direction =  global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func randomize_wander_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

# Signal Functions

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockbackVector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.5)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = ENEMY_DEATH_EFFECT.instance()  # Create instance/copy of effect scene
	get_parent().add_child(enemyDeathEffect)            # Add effect to parent (bat)
	enemyDeathEffect.global_position = global_position  # Set position of instance to parent


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
