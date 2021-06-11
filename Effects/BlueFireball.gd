extends Hitbox

#Preload
const FIREBALL_AREA = preload("res://Effects/FireballArea.tscn")
const ENEMY_DEATH_EFFECT = preload("res://Effects/EnemyDeathEffect.tscn")

# Export
## Movement variables
export var MAX_SPEED = 500
export var ACCELERATION = 200

# Onready
onready var explosionTimer = $ExplosionTimer
onready var areaEffect = $AreaEffect
onready var fireballEffect = $FireballEffect

# Variables
var travelVector = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")
	
func _physics_process(delta):
	travelVector = travelVector.normalized()
	knockbackVector = travelVector
	travelVector = travelVector.move_toward(travelVector * MAX_SPEED, ACCELERATION * delta)
	self.translate(travelVector)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	travelVector = Vector2.ZERO
	position = global_position


func _on_BlueFireball_body_entered(body):
	# Spawn blast fireball AoE
	var fireballArea = FIREBALL_AREA.instance()
	var main = get_tree().current_scene
	main.add_child(fireballArea)
	fireballArea.global_position = global_position
	queue_free()

