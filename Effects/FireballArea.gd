extends Hitbox

#Onready
onready var area = $Area
onready var explosionTimer = $ExplosionTimer

# Variables
var knockback_vector = Vector2.ZERO

func _ready():
	damage = 6
	explosionTimer.start()


func _on_ExplosionTimer_timeout():
	queue_free()
