extends Hitbox

# Export
## Movement variables
export var MAX_SPEED = 500
export var ACCELERATION = 200

# Variables
var travelVector = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("default")
	damage = 3
	
func _physics_process(delta):
	travelVector = travelVector.normalized()
	knockbackVector = travelVector
	travelVector = travelVector.move_toward(travelVector * MAX_SPEED, ACCELERATION * delta)
	self.translate(travelVector)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	travelVector = Vector2.ZERO
	position = global_position


func _on_Fireball_body_entered(body):
	queue_free()
	travelVector = Vector2.ZERO
	position = global_position
