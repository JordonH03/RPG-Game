extends Hitbox

# Export
## Movement variables
export var MAX_SPEED = 500
export var ACCELERATION = 200

# Variables
var travel_vector = Vector2.ZERO
var knockback_vector = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")
	damage = 3
	
func _physics_process(delta):
	travel_vector = travel_vector.normalized()
	travel_vector = travel_vector.move_toward(travel_vector * MAX_SPEED, ACCELERATION * delta)
	self.translate(travel_vector)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	travel_vector = Vector2.ZERO
	position = global_position


func _on_Fireball_body_entered(body):
	queue_free()
	travel_vector = Vector2.ZERO
	position = global_position
