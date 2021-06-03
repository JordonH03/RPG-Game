extends Hitbox

# Export
## Movement variables
export var MAX_SPEED = 120
export var ACCELERATION = 500
export var FRICTION = 500

# Onready
onready var sprite = $AnimatedSprite

# Variables
var velocity = Vector2.ZERO
var travel_vector = Vector2.ZERO
var knockback_vector = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 3


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	var velocity = Vector2.ZERO
	var travel_vector = Vector2.ZERO
	position = global_position
