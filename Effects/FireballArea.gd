extends Hitbox

#Onready
onready var area = $Area
onready var explosionTimer = $ExplosionTimer

func _ready():
	damage = 3
	explosionTimer.start()


func _on_ExplosionTimer_timeout():
	queue_free()
