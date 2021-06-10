extends Hitbox

#Preload
const FIREBALL_AREA = preload("res://Effects/FireballArea.tscn")
const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

# Export
## Movement variables
export var MAX_SPEED = 500
export var ACCELERATION = 200

# Onready
onready var explosionTimer = $ExplosionTimer
onready var areaEffect = $AreaEffect
onready var fireballEffect = $FireballEffect

# Variables
var travel_vector = Vector2.ZERO
var knockback_vector = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")
	
func _physics_process(delta):
	travel_vector = travel_vector.normalized()
	knockback_vector = travel_vector
	travel_vector = travel_vector.move_toward(travel_vector * MAX_SPEED, ACCELERATION * delta)
	self.translate(travel_vector)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	travel_vector = Vector2.ZERO
	position = global_position


func _on_BlueFireball_body_entered(body):
	# Spawn blast fireball AoE
	var fireballArea = FIREBALL_AREA.instance()
	var main = get_tree().current_scene
	main.add_child(fireballArea)
	fireballArea.global_position = global_position
	queue_free()
	# Add explosion effect
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

